import 'package:args/args.dart';
import 'package:nebula/src/tool/common.dart';
import 'package:nebula/src/tool/data.dart';
import 'package:nebula/src/tool/photo.dart';

void main(List<String> args) async {
  final dataParser = ArgParser()
    ..addOption('input', abbr: 'i')
    ..addOption('names', abbr: 'n')
    ..addOption('output', abbr: 'o')
    ..addFlag('extended', abbr: 'x')
    ..addFlag('minify', abbr: 'm')
    ..addFlag('zipped', abbr: 'z')
    ..addFlag('force', abbr: 'f');

  final photoParser = ArgParser()
    ..addOption('input', abbr: 'i')
    ..addOption('output', abbr: 'o', defaultsTo: './photos')
    ..addOption('quality', abbr: 'q', defaultsTo: '$defaultQuality')
    ..addOption('width', abbr: 'w', defaultsTo: '$defaultWidth')
    ..addOption('height', abbr: 'h', defaultsTo: '$defaultHeight')
    ..addOption('version')
    ..addFlag('zipped', abbr: 'z')
    ..addFlag('force', abbr: 'f')
    ..addFlag('webp', negatable: false)
    ..addFlag('reverse', abbr: 'r');

  final parser = ArgParser()
    ..addCommand('data', dataParser)
    ..addCommand('photo', photoParser);

  final result = parser.parse(args);

  if (result.command == null) {
    print('Invalid command');
  } else if (result.command.name == 'data') {
    await handleData(result.command);
  } else if (result.command.name == 'photo') {
    await handlePhoto(result.command);
  }
}
