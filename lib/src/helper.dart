import 'dart:math';

extension NumExtension on double {
  double dp(int places) {
    final mod = pow(10.0, places);
    return (this * mod).round() / mod;
  }
}
