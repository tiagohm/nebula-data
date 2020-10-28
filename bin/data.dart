import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:nebula/src/nebula.dart';
import 'package:nebula/src/nebula_decoder.dart';
import 'package:restio/restio.dart';

import 'common.dart';

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

Future<void> handleData(ArgResults result) async {
  final extended = result['extended'] as bool;
  final minify = result['minify'] as bool;
  final zipped = result['zipped'] as bool;
  final force = result['force'] as bool;
  final input = result['input'] as String;
  final names = result['names'] as String;
  final output = result['output'] as String;

  File inputFile;
  File namesFile;
  File outputFile;

  if (input != null) {
    inputFile = File(input);
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

  if (names != null) {
    namesFile = File(names);
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

  try {
    print('Generating catalog file...');
    final bytes = utf8.encode(encoder.convert(data));
    outputFile.writeAsBytesSync(zipped ? gzip.encode(bytes) : bytes);
    print('Generated catalog file at ${outputFile.absolute}');
  } catch (e) {
    return print('Error: $e');
  } finally {
    await restio.close();
  }
}
