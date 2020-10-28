import 'dart:io';

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
