import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:image/image.dart';
import 'package:nebula/src/helper.dart';
import 'package:nebula/src/nebula.dart';
import 'package:nebula/src/nebula_decoder.dart';
import 'package:restio/restio.dart';

const defaultQuality = 70;
const defaultWidth = 512;
const defaultHeight = 512;

final catalogRequest = Request.get(
    'https://raw.githubusercontent.com/Stellarium/stellarium/master/nebulae/default/catalog.dat');
final extendedCatalogRequest = Request.get(
    'https://github.com/Stellarium/stellarium-data/releases/latest/download/catalog.dat');
final namesRequest = Request.get(
    'https://raw.githubusercontent.com/Stellarium/stellarium/master/nebulae/default/names.dat');
final defaultCatalogFile = File('catalog.dat');
final defaultExtendedCatalogFile = File('catalog.extended.dat');
final defaultNamesFile = File('names.dat');
final defaultOutputFile = File('catalog.json');
final defaultZippedOutputFile = File('catalog.json.gz');

final progressBar = ProgressBar();

final restio = Restio(
  onDownloadProgress: (res, length, total, end) {
    final contentLength = res.headers.last('Content-Length')?.asInt ?? -1;

    if (contentLength > 0) {
      final progress = (total * 100 / contentLength).toStringAsFixed(1);
      progressBar.update('Progress: $total/$contentLength ($progress%)');

      if (end) {
        progressBar.end();
      }
    }
  },
);

class ProgressBar {
  var _output = '';
  String prefix = '';

  void update(String text) {
    for (var i = 0; i < prefix.length; i++) {
      stdout.writeCharCode(8); // Backspace.
    }

    for (var i = 0; i < _output.length; i++) {
      stdout.writeCharCode(8); // Backspace.
    }

    _output = text;

    stdout.write(prefix);
    stdout.write(text);
  }

  void end() {
    stdout.writeln();
  }
}

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i')
    ..addOption('names', abbr: 'n')
    ..addOption('output', abbr: 'o')
    ..addOption('photo-output', defaultsTo: './photos')
    ..addOption('quality', abbr: 'q', defaultsTo: '$defaultQuality')
    ..addOption('width', abbr: 'w', defaultsTo: '$defaultWidth')
    ..addOption('height', abbr: 'h', defaultsTo: '$defaultHeight')
    ..addFlag('extended', abbr: 'x')
    ..addFlag('minify', abbr: 'm')
    ..addFlag('zipped', abbr: 'z')
    ..addFlag('force', abbr: 'f')
    ..addFlag('photos', abbr: 'p')
    ..addFlag('only-photos', negatable: false)
    ..addFlag('webp', negatable: false)
    ..addFlag('reverse', abbr: 'r');

  final result = parser.parse(args);

  await handleCatalog(result);
}

Future<void> handleCatalog(ArgResults result) async {
  final extended = result['extended'] as bool;
  final minify = result['minify'] as bool;
  final zipped = result['zipped'] as bool;
  final force = result['force'] as bool;
  final onlyPhotos = result['only-photos'] as bool;
  final photos = result['photos'] as bool || onlyPhotos;
  final input = result['input'] as String;
  final names = result['names'] as String;
  final output = result['output'] as String;
  final photoOutput = result['photo-output'] as String;
  final quality = int.tryParse(result['quality']) ?? defaultQuality;
  final width = int.tryParse(result['width']) ?? defaultWidth;
  final height = int.tryParse(result['height']) ?? defaultHeight;
  final webp = result['webp'] as bool;
  final reverse = result['reverse'] as bool;

  File inputFile;
  File namesFile;
  File outputFile;

  if (input != null) {
    inputFile = File(input);
  } else if ((!force || onlyPhotos) &&
      !extended &&
      defaultCatalogFile.existsSync()) {
    inputFile = defaultCatalogFile;
    print('Using the default DSO catalog file at ${inputFile.absolute}');
  } else if ((!force || onlyPhotos) &&
      extended &&
      defaultExtendedCatalogFile.existsSync()) {
    inputFile = defaultExtendedCatalogFile;
    print('Using the default DSO catalog file at ${inputFile.absolute}');
  } else {
    final call =
        restio.newCall(extended ? extendedCatalogRequest : catalogRequest);
    final editionName = extended ? 'Extended' : 'Standard';

    print('Downloading $editionName Edition catalog...');

    final response = await call.execute();

    try {
      inputFile = extended ? defaultExtendedCatalogFile : defaultCatalogFile;
      final data = await response.body.decompressed();
      inputFile.writeAsBytesSync(data);
    } catch (e) {
      return print('Error: $e');
    } finally {
      await response.close();
    }
  }

  if (!inputFile.existsSync()) {
    return print('DSO catalog file can not be found');
  }

  if (names != null) {
    namesFile = File(names);
  } else if ((!force || onlyPhotos) && defaultNamesFile.existsSync()) {
    namesFile = defaultNamesFile;
    print('Using the default DSO names catalog file at ${namesFile.absolute}');
  } else {
    final call = restio.newCall(namesRequest);

    print('Downloading DSO names catalog...');

    final response = await call.execute();

    try {
      namesFile = defaultNamesFile;
      final data = await response.body.raw();
      namesFile.writeAsBytesSync(gzip.decode(data));
    } catch (e) {
      return print('Error: $e');
    } finally {
      await response.close();
    }
  }

  if (!namesFile.existsSync()) {
    return print('DSO catalog names file can not be found');
  }

  print('Loading DSO objects...');

  if (output != null) {
    outputFile = File(output);
  } else {
    outputFile = zipped ? defaultZippedOutputFile : defaultOutputFile;
  }

  final encoder = minify ? json.encoder : JsonEncoder.withIndent('\t');

  final data = await inputFile
      .openRead()
      .transform(gzip.decoder)
      .transform(NebulaDecoder(
        names: namesFile?.readAsLinesSync(),
        progress: (count, end) {
          if (count % 1000 == 0) {
            progressBar.update('Loaded $count DSO records successfully');
          }

          if (end) {
            progressBar.update('Loaded $count DSO records successfully');
            progressBar.end();
          }
        },
      ))
      .fold<List<Nebula>>([], (a, b) => a..addAll(b));

  final imageDsoFile = File('$photoOutput/dso.jpg');

  try {
    if (!onlyPhotos) {
      print('Generating catalog file...');
      final bytes = utf8.encode(encoder.convert(data));
      outputFile.writeAsBytesSync(zipped ? gzip.encode(bytes) : bytes);
      print('Generated catalog file at ${outputFile.absolute}');
    }

    if (photos) {
      print('Generating photos...');

      const v = [
        // 'poss2ukstu_red',
        'poss2ukstu_blue',
        // 'poss2ukstu_ir',
        // 'poss1_red',
        // 'poss1_blue',
        // 'quickv',
        'phase2_gsc2',
        // 'phase2_gsc1',
      ];

      // http://archive.stsci.edu/cgi-bin/dss_form
      // http://archive.stsci.edu/cgi-bin/dss_search?v=phase2_gsc2&r=00+07+15.86&d=%2B27+42+29.0&e=J2000&h=10&w=10&f=gif&c=none&fov=NONE&v3=
      final imageUrl = 'http://archive.stsci.edu/cgi-bin/dss_search';
      final dssQueryBuilder = QueriesBuilder()
        // ..add('v', v[0])
        ..add('e', 'J2000')
        ..add('f', 'gif')
        ..add('c', 'none')
        ..add('fov', 'NONE')
        ..add('v3', null);

      Directory(photoOutput).createSync(recursive: true);
      final photoMetadataFile = File('$photoOutput/metadata.json');

      final metadata = photoMetadataFile.existsSync()
          ? json.decode(photoMetadataFile.readAsStringSync())
          : <String, dynamic>{};
      final metaDataEncoder = JsonEncoder.withIndent('  ');
      var totalPhotoLength = 0;
      var photoAmount = 0;

      for (final nebula in reverse ? data.reversed : data) {
        final id = nebula.id;
        final imageName = '$id'.padLeft(5, '0');
        final imageWebpFile = File('$photoOutput/$imageName.webp');
        final imageJpgFile = File('$photoOutput/$imageName.jpg');
        final imageFile = webp ? imageWebpFile : imageJpgFile;

        if (!force && imageFile.existsSync() && imageFile.lengthSync() > 0) {
          continue;
        }

        final raHms = nebula.ra.raToHms();
        final decHms = nebula.dec.decToHms();

        dssQueryBuilder.set('r', raHms);
        dssQueryBuilder.set('d', decHms);
        dssQueryBuilder.set('w', 60);
        dssQueryBuilder.set('h', 60);

        progressBar.prefix = 'Nebula $id: ';
        var failed = false;

        for (var i = 0; i < v.length; i++) {
          dssQueryBuilder.set('v', v[i]);
          final request =
              Request.get(imageUrl, queries: dssQueryBuilder.build());
          final call = restio.newCall(request);

          Response response;
          List<int> bytes;
          var attempts = 0;

          for (attempts; attempts < 10; attempts++) {
            try {
              response = await call.execute();
            } catch (e) {
              print('Error: $e attempt #$attempts');
              continue;
            }

            try {
              bytes = await response.body.decompressed();
              break;
            } catch (e) {
              print('Error: $e attempt #$attempts');

              try {
                await response.close();
              } catch (e) {
                // nada.
              }
            }
          }

          if (attempts == 10) {
            failed = true;
            print('Nebula $i failed!');
            break;
          }

          try {
            if (bytes != null &&
                bytes.isNotEmpty &&
                response.headers.first('content-type').value == 'image/gif') {
              final image = decodeGif(bytes);
              final resizedImage =
                  copyResize(image, width: width, height: height);
              final jpgQuality = webp ? 100 : quality;
              final jpg = encodeJpg(resizedImage, quality: jpgQuality);

              if (webp) {
                imageDsoFile.writeAsBytesSync(jpg);

                // cwebp -q 50 00001.jpg -o 00001.70.webp
                await Process.run('cwebp', [
                  '-q',
                  '$quality',
                  '${imageDsoFile.path}',
                  '-o',
                  '${imageFile.path}'
                ]);
              } else {
                imageFile.writeAsBytesSync(jpg);
              }

              metadata[imageName] = {
                'height': image.height,
                'size': bytes.length,
                'url': request.uri.toUriString(),
                'width': image.width,
              };

              photoMetadataFile
                  .writeAsStringSync(metaDataEncoder.convert(metadata));

              break;
            }
          } catch (e) {
            final message = '$e';
            print('ERROR: Nebula ${nebula.id} $raHms $decHms - $message');
          } finally {
            try {
              await response.close();
            } catch (e) {
              // nada.
            }
          }
        }

        if (!failed) {
          photoAmount++;
          totalPhotoLength += await imageFile.length();
          print('Total photos length: $totalPhotoLength B,'
              ' ${totalPhotoLength ~/ photoAmount} B/photo');
        }
      }
    }
  } catch (e) {
    return print('Error: $e');
  } finally {
    await restio.close();

    if (imageDsoFile.existsSync()) {
      imageDsoFile.deleteSync();
    }
  }
}
