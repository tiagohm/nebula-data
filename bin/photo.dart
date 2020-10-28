import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:image/image.dart';
import 'package:nebula/src/helper.dart';
import 'package:nebula/src/nebula.dart';
import 'package:restio/restio.dart';

import 'common.dart';

const versions = [
  // 'poss2ukstu_red',
  'poss2ukstu_blue',
  // 'poss2ukstu_ir',
  // 'poss1_red',
  // 'poss1_blue',
  // 'quickv',
  'phase2_gsc2',
  // 'phase2_gsc1',
];

const altVersions = [
  'poss1_blue',
  'phase2_gsc1',
];

final coordInputRegex = RegExp(r'^(\d+):([\d.]+):([\d.]+)$');

Future<void> handlePhoto(ArgResults result) async {
  final input = result['input'] as String;
  // final zipped = result['zipped'] as bool;
  final force = result['force'] as bool;
  final output = result['output'] as String;
  final version = result['version'] as String;
  final quality = double.tryParse(result['quality'])?.toInt() ?? defaultQuality;
  final width = double.tryParse(result['width'])?.toInt() ?? defaultWidth;
  final height = double.tryParse(result['height'])?.toInt() ?? defaultHeight;
  final webp = result['webp'] as bool;
  final reverse = result['reverse'] as bool;
  final imageDsoFile = File('$output/dso.jpg');

  try {
    print('Generating photos...');

    Directory(output).createSync(recursive: true);

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

    var totalPhotoLength = 0;
    var photoAmount = 0;

    final data = <Nebula>[];

    if (input == null || input.isEmpty) {
      print('Incorrect input');
      return;
    }
    // HTTP
    else if (input.startsWith('http')) {
      print('Fetching catalog from $input...');

      final request = Request.get(input);
      final call = restio.newCall(request);
      final response = await call.execute();
      final json = await response.body.json();

      for (final item in json['data']) {
        data.add(Nebula.fromJson(item));
      }

      await response.close();
    }
    // id:ra:dec
    else if (coordInputRegex.hasMatch(input)) {
      final m = coordInputRegex.firstMatch(input);
      final id = int.parse(m.group(1));
      final ra = double.parse(m.group(2));
      final dec = double.parse(m.group(3));

      data.add(Nebula(id: id, ra: ra, dec: dec));
    }
    // File
    else {
      print('Opening catalog at $input...');
      final json = jsonDecode(File(input).readAsStringSync());

      for (final item in json) {
        data.add(Nebula.fromJson(item));
      }
    }

    print('Found ${data.length} DSOs');

    final v = version == null || version.isEmpty
        ? versions
        : version == 'alt'
            ? altVersions
            : version.split(':');

    for (final nebula in reverse ? data.reversed : data) {
      final id = nebula.id;

      final imageName = '$id'.padLeft(5, '0');
      final imageWebpFile = File('$output/$imageName.webp');
      final imageJpgFile = File('$output/$imageName.jpg');
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
        final request = Request.get(imageUrl, queries: dssQueryBuilder.build());
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
          print('Nebula $id failed with version $v');
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

              // cwebp -q 50 00001.jpg -o 00001.webp
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

            failed = false;
            break;
          } else {
            failed = true;
          }
        } catch (e) {
          print('ERROR: Nebula ${nebula.id} $raHms $decHms - $e');
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
      } else {
        print('Nebula $id failed');
      }
    }
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  } finally {
    await restio.close();

    if (imageDsoFile.existsSync()) {
      imageDsoFile.deleteSync();
    }
  }

  print('Finished!');
}
