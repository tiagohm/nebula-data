import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:nebula/src/nebula.dart';
import 'package:nebula/src/nebula_decoder.dart';
import 'package:restio/restio.dart';

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

final restio = Restio(onDownloadProgress: (res, length, total, end) {
  final contentLength = res.headers.last('Content-Length')?.asInt ?? -1;
  final progress = (total * 100 / contentLength).toStringAsFixed(1);
  progressBar.update('Progress: $total/$contentLength ($progress%)');

  if (end) {
    progressBar.end();
  }
});

class ProgressBar {
  var _output = '';

  void update(String text) {
    for (var i = 0; i < _output.length; i++) {
      stdout.writeCharCode(8); // Backspace.
    }

    _output = text;
    stdout.write(text);
  }

  void end() {
    stdout.writeln();
  }
}

void main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('input', abbr: 'i')
    ..addOption('names', abbr: 'n')
    ..addOption('output', abbr: 'o')
    ..addFlag('extended', abbr: 'x')
    ..addFlag('minify', abbr: 'm')
    ..addFlag('zipped', abbr: 'z')
    ..addFlag('force', abbr: 'f');

  final argResult = argParser.parse(args);
  final extended = argResult['extended'] == true;
  final minify = argResult['minify'] == true;
  final zipped = argResult['zipped'] == true;
  final force = argResult['force'] == true;

  File inputFile;
  File namesFile;
  File outputFile;

  if (argResult['input'] != null) {
    inputFile = File(argResult['input']);
  } else if (!force && !extended && defaultCatalogFile.existsSync()) {
    inputFile = defaultCatalogFile;
    print('Using the default DSO catalog file at ${inputFile.absolute}');
  } else if (!force && extended && defaultExtendedCatalogFile.existsSync()) {
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

  if (argResult['names'] != null) {
    namesFile = File(argResult['names']);
  } else if (!force && defaultNamesFile.existsSync()) {
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

  if (argResult['output'] != null) {
    outputFile = File(argResult['output']);
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

  print('Generating catalog file...');

  try {
    final bytes = utf8.encode(encoder.convert(data));
    outputFile.writeAsBytesSync(zipped ? gzip.encode(bytes) : bytes);
    print('Generated catalog file at ${outputFile.absolute}');
  } catch (e) {
    return print('Error: $e');
  } finally {
    await restio.close();
  }
}
