import 'dart:math';

extension NumExtension on double {
  double dp(int places) {
    final mod = pow(10.0, places);
    return (this * mod).round() / mod;
  }

  String degToHms(int a) {
    final d = (abs()).floor();
    final m = ((abs() - d) * 60).floor();
    final s = ((((abs() - d) * 60) - m) * 6000).floor();

    final res = StringBuffer();

    res.write(isNegative ? '-' : '+');

    if (d < 9) res.write('0');
    res.write('$d ');

    if (m < 9) res.write('0');
    res.write('$m ');

    final sa = s ~/ 100;
    final sb = s % 100;

    if (sa < 9) res.write('0');
    res.write('$sa.');

    if (sb < 9) res.write('0');
    res.write('$sb');

    return res.toString();
  }

  String raToHms() {
    return ((this * 12) / pi).degToHms(24);
  }

  String decToHms() {
    return ((this * 180) / pi).degToHms(90);
  }
}
