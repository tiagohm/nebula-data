import 'dart:math';

import 'package:test/test.dart';
import 'package:nebula/src/helper.dart';

void main() {
  test('RA to HMS', () {
    expect(0.06498457491397858.raToHms(), '+00 14 53.60');
    expect((2 * pi).raToHms(), '+24 00 00.00');
    expect((pi).raToHms(), '+12 00 00.00');
  });

  test('DEC to HMS', () {
    expect((-0.6841102242469788).decToHms(), '-39 11 47.86');
    expect((0.6841102242469788).decToHms(), '+39 11 47.86');
    expect((pi / 2).decToHms(), '+90 00 00.00');
    expect((-pi / 2).decToHms(), '-90 00 00.00');
  });
}
