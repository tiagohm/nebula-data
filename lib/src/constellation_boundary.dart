// http://djm.cc/constellation.js

import 'dart:math';

class ConstellationBoundary {
  final double raMin, raMax, decMin;
  final String name;

  const ConstellationBoundary(this.raMin, this.raMax, this.decMin, this.name)
      : assert(raMin <= raMax);
}

const boundaries = [
  ConstellationBoundary(0.0000, 24.0000, 88.0000, 'UMi'),
  ConstellationBoundary(8.0000, 14.5000, 86.5000, 'UMi'),
  ConstellationBoundary(21.0000, 23.0000, 86.1667, 'UMi'),
  ConstellationBoundary(18.0000, 21.0000, 86.0000, 'UMi'),
  ConstellationBoundary(0.0000, 8.0000, 85.0000, 'Cep'),
  ConstellationBoundary(9.1667, 10.6667, 82.0000, 'Cam'),
  ConstellationBoundary(0.0000, 5.0000, 80.0000, 'Cep'),
  ConstellationBoundary(10.6667, 14.5000, 80.0000, 'Cam'),
  ConstellationBoundary(17.5000, 18.0000, 80.0000, 'UMi'),
  ConstellationBoundary(20.1667, 21.0000, 80.0000, 'Dra'),
  ConstellationBoundary(0.0000, 3.5083, 77.0000, 'Cep'),
  ConstellationBoundary(11.5000, 13.5833, 77.0000, 'Cam'),
  ConstellationBoundary(16.5333, 17.5000, 75.0000, 'UMi'),
  ConstellationBoundary(20.1667, 20.6667, 75.0000, 'Cep'),
  ConstellationBoundary(7.9667, 9.1667, 73.5000, 'Cam'),
  ConstellationBoundary(9.1667, 11.3333, 73.5000, 'Dra'),
  ConstellationBoundary(13.0000, 16.5333, 70.0000, 'UMi'),
  ConstellationBoundary(3.1000, 3.4167, 68.0000, 'Cas'),
  ConstellationBoundary(20.4167, 20.6667, 67.0000, 'Dra'),
  ConstellationBoundary(11.3333, 12.0000, 66.5000, 'Dra'),
  ConstellationBoundary(0.0000, 0.3333, 66.0000, 'Cep'),
  ConstellationBoundary(14.0000, 15.6667, 66.0000, 'UMi'),
  ConstellationBoundary(23.5833, 24.0000, 66.0000, 'Cep'),
  ConstellationBoundary(12.0000, 13.5000, 64.0000, 'Dra'),
  ConstellationBoundary(13.5000, 14.4167, 63.0000, 'Dra'),
  ConstellationBoundary(23.1667, 23.5833, 63.0000, 'Cep'),
  ConstellationBoundary(6.1000, 7.0000, 62.0000, 'Cam'),
  ConstellationBoundary(20.0000, 20.4167, 61.5000, 'Dra'),
  ConstellationBoundary(20.5367, 20.6000, 60.9167, 'Cep'),
  ConstellationBoundary(7.0000, 7.9667, 60.0000, 'Cam'),
  ConstellationBoundary(7.9667, 8.4167, 60.0000, 'UMa'),
  ConstellationBoundary(19.7667, 20.0000, 59.5000, 'Dra'),
  ConstellationBoundary(20.0000, 20.5367, 59.5000, 'Cep'),
  ConstellationBoundary(22.8667, 23.1667, 59.0833, 'Cep'),
  ConstellationBoundary(0.0000, 2.4333, 58.5000, 'Cas'),
  ConstellationBoundary(19.4167, 19.7667, 58.0000, 'Dra'),
  ConstellationBoundary(1.7000, 1.9083, 57.5000, 'Cas'),
  ConstellationBoundary(2.4333, 3.1000, 57.0000, 'Cas'),
  ConstellationBoundary(3.1000, 3.1667, 57.0000, 'Cam'),
  ConstellationBoundary(22.3167, 22.8667, 56.2500, 'Cep'),
  ConstellationBoundary(5.0000, 6.1000, 56.0000, 'Cam'),
  ConstellationBoundary(14.0333, 14.4167, 55.5000, 'UMa'),
  ConstellationBoundary(14.4167, 19.4167, 55.5000, 'Dra'),
  ConstellationBoundary(3.1667, 3.3333, 55.0000, 'Cam'),
  ConstellationBoundary(22.1333, 22.3167, 55.0000, 'Cep'),
  ConstellationBoundary(20.6000, 21.9667, 54.8333, 'Cep'),
  ConstellationBoundary(0.0000, 1.7000, 54.0000, 'Cas'),
  ConstellationBoundary(6.1000, 6.5000, 54.0000, 'Lyn'),
  ConstellationBoundary(12.0833, 13.5000, 53.0000, 'UMa'),
  ConstellationBoundary(15.2500, 15.7500, 53.0000, 'Dra'),
  ConstellationBoundary(21.9667, 22.1333, 52.7500, 'Cep'),
  ConstellationBoundary(3.3333, 5.0000, 52.5000, 'Cam'),
  ConstellationBoundary(22.8667, 23.3333, 52.5000, 'Cas'),
  ConstellationBoundary(15.7500, 17.0000, 51.5000, 'Dra'),
  ConstellationBoundary(2.0417, 2.5167, 50.5000, 'Per'),
  ConstellationBoundary(17.0000, 18.2333, 50.5000, 'Dra'),
  ConstellationBoundary(0.0000, 1.3667, 50.0000, 'Cas'),
  ConstellationBoundary(1.3667, 1.6667, 50.0000, 'Per'),
  ConstellationBoundary(6.5000, 6.8000, 50.0000, 'Lyn'),
  ConstellationBoundary(23.3333, 24.0000, 50.0000, 'Cas'),
  ConstellationBoundary(13.5000, 14.0333, 48.5000, 'UMa'),
  ConstellationBoundary(0.0000, 1.1167, 48.0000, 'Cas'),
  ConstellationBoundary(23.5833, 24.0000, 48.0000, 'Cas'),
  ConstellationBoundary(18.1750, 18.2333, 47.5000, 'Her'),
  ConstellationBoundary(18.2333, 19.0833, 47.5000, 'Dra'),
  ConstellationBoundary(19.0833, 19.1667, 47.5000, 'Cyg'),
  ConstellationBoundary(1.6667, 2.0417, 47.0000, 'Per'),
  ConstellationBoundary(8.4167, 9.1667, 47.0000, 'UMa'),
  ConstellationBoundary(0.1667, 0.8667, 46.0000, 'Cas'),
  ConstellationBoundary(12.0000, 12.0833, 45.0000, 'UMa'),
  ConstellationBoundary(6.8000, 7.3667, 44.5000, 'Lyn'),
  ConstellationBoundary(21.9083, 21.9667, 44.0000, 'Cyg'),
  ConstellationBoundary(21.8750, 21.9083, 43.7500, 'Cyg'),
  ConstellationBoundary(19.1667, 19.4000, 43.5000, 'Cyg'),
  ConstellationBoundary(9.1667, 10.1667, 42.0000, 'UMa'),
  ConstellationBoundary(10.1667, 10.7833, 40.0000, 'UMa'),
  ConstellationBoundary(15.4333, 15.7500, 40.0000, 'Boo'),
  ConstellationBoundary(15.7500, 16.3333, 40.0000, 'Her'),
  ConstellationBoundary(9.2500, 9.5833, 39.7500, 'Lyn'),
  ConstellationBoundary(0.0000, 2.5167, 36.7500, 'And'),
  ConstellationBoundary(2.5167, 2.5667, 36.7500, 'Per'),
  ConstellationBoundary(19.3583, 19.4000, 36.5000, 'Lyr'),
  ConstellationBoundary(4.5000, 4.6917, 36.0000, 'Per'),
  ConstellationBoundary(21.7333, 21.8750, 36.0000, 'Cyg'),
  ConstellationBoundary(21.8750, 22.0000, 36.0000, 'Lac'),
  ConstellationBoundary(6.5333, 7.3667, 35.5000, 'Aur'),
  ConstellationBoundary(7.3667, 7.7500, 35.5000, 'Lyn'),
  ConstellationBoundary(0.0000, 2.0000, 35.0000, 'And'),
  ConstellationBoundary(22.0000, 22.8167, 35.0000, 'Lac'),
  ConstellationBoundary(22.8167, 22.8667, 34.5000, 'Lac'),
  ConstellationBoundary(22.8667, 23.5000, 34.5000, 'And'),
  ConstellationBoundary(2.5667, 2.7167, 34.0000, 'Per'),
  ConstellationBoundary(10.7833, 11.0000, 34.0000, 'UMa'),
  ConstellationBoundary(12.0000, 12.3333, 34.0000, 'CVn'),
  ConstellationBoundary(7.7500, 9.2500, 33.5000, 'Lyn'),
  ConstellationBoundary(9.2500, 9.8833, 33.5000, 'LMi'),
  ConstellationBoundary(0.7167, 1.4083, 33.0000, 'And'),
  ConstellationBoundary(15.1833, 15.4333, 33.0000, 'Boo'),
  ConstellationBoundary(23.5000, 23.7500, 32.0833, 'And'),
  ConstellationBoundary(12.3333, 13.2500, 32.0000, 'CVn'),
  ConstellationBoundary(23.7500, 24.0000, 31.3333, 'And'),
  ConstellationBoundary(13.9583, 14.0333, 30.7500, 'CVn'),
  ConstellationBoundary(2.4167, 2.7167, 30.6667, 'Tri'),
  ConstellationBoundary(2.7167, 4.5000, 30.6667, 'Per'),
  ConstellationBoundary(4.5000, 4.7500, 30.0000, 'Aur'),
  ConstellationBoundary(18.1750, 19.3583, 30.0000, 'Lyr'),
  ConstellationBoundary(11.0000, 12.0000, 29.0000, 'UMa'),
  ConstellationBoundary(19.6667, 20.9167, 29.0000, 'Cyg'),
  ConstellationBoundary(4.7500, 5.8833, 28.5000, 'Aur'),
  ConstellationBoundary(9.8833, 10.5000, 28.5000, 'LMi'),
  ConstellationBoundary(13.2500, 13.9583, 28.5000, 'CVn'),
  ConstellationBoundary(0.0000, 0.0667, 28.0000, 'And'),
  ConstellationBoundary(1.4083, 1.6667, 28.0000, 'Tri'),
  ConstellationBoundary(5.8833, 6.5333, 28.0000, 'Aur'),
  ConstellationBoundary(7.8833, 8.0000, 28.0000, 'Gem'),
  ConstellationBoundary(20.9167, 21.7333, 28.0000, 'Cyg'),
  ConstellationBoundary(19.2583, 19.6667, 27.5000, 'Cyg'),
  ConstellationBoundary(1.9167, 2.4167, 27.2500, 'Tri'),
  ConstellationBoundary(16.1667, 16.3333, 27.0000, 'CrB'),
  ConstellationBoundary(15.0833, 15.1833, 26.0000, 'Boo'),
  ConstellationBoundary(15.1833, 16.1667, 26.0000, 'CrB'),
  ConstellationBoundary(18.3667, 18.8667, 26.0000, 'Lyr'),
  ConstellationBoundary(10.7500, 11.0000, 25.5000, 'LMi'),
  ConstellationBoundary(18.8667, 19.2583, 25.5000, 'Lyr'),
  ConstellationBoundary(1.6667, 1.9167, 25.0000, 'Tri'),
  ConstellationBoundary(0.7167, 0.8500, 23.7500, 'Psc'),
  ConstellationBoundary(10.5000, 10.7500, 23.5000, 'LMi'),
  ConstellationBoundary(21.2500, 21.4167, 23.5000, 'Vul'),
  ConstellationBoundary(5.7000, 5.8833, 22.8333, 'Tau'),
  ConstellationBoundary(0.0667, 0.1417, 22.0000, 'And'),
  ConstellationBoundary(15.9167, 16.0333, 22.0000, 'Ser'),
  ConstellationBoundary(5.8833, 6.2167, 21.5000, 'Gem'),
  ConstellationBoundary(19.8333, 20.2500, 21.2500, 'Vul'),
  ConstellationBoundary(18.8667, 19.2500, 21.0833, 'Vul'),
  ConstellationBoundary(0.1417, 0.8500, 21.0000, 'And'),
  ConstellationBoundary(20.2500, 20.5667, 20.5000, 'Vul'),
  ConstellationBoundary(7.8083, 7.8833, 20.0000, 'Gem'),
  ConstellationBoundary(20.5667, 21.2500, 19.5000, 'Vul'),
  ConstellationBoundary(19.2500, 19.8333, 19.1667, 'Vul'),
  ConstellationBoundary(3.2833, 3.3667, 19.0000, 'Ari'),
  ConstellationBoundary(18.8667, 19.0000, 18.5000, 'Sge'),
  ConstellationBoundary(5.7000, 5.7667, 18.0000, 'Ori'),
  ConstellationBoundary(6.2167, 6.3083, 17.5000, 'Gem'),
  ConstellationBoundary(19.0000, 19.8333, 16.1667, 'Sge'),
  ConstellationBoundary(4.9667, 5.3333, 16.0000, 'Tau'),
  ConstellationBoundary(15.9167, 16.0833, 16.0000, 'Her'),
  ConstellationBoundary(19.8333, 20.2500, 15.7500, 'Sge'),
  ConstellationBoundary(4.6167, 4.9667, 15.5000, 'Tau'),
  ConstellationBoundary(5.3333, 5.6000, 15.5000, 'Tau'),
  ConstellationBoundary(12.8333, 13.5000, 15.0000, 'Com'),
  ConstellationBoundary(17.2500, 18.2500, 14.3333, 'Her'),
  ConstellationBoundary(11.8667, 12.8333, 14.0000, 'Com'),
  ConstellationBoundary(7.5000, 7.8083, 13.5000, 'Gem'),
  ConstellationBoundary(16.7500, 17.2500, 12.8333, 'Her'),
  ConstellationBoundary(0.0000, 0.1417, 12.5000, 'Peg'),
  ConstellationBoundary(5.6000, 5.7667, 12.5000, 'Tau'),
  ConstellationBoundary(7.0000, 7.5000, 12.5000, 'Gem'),
  ConstellationBoundary(21.1167, 21.3333, 12.5000, 'Peg'),
  ConstellationBoundary(6.3083, 6.9333, 12.0000, 'Gem'),
  ConstellationBoundary(18.2500, 18.8667, 12.0000, 'Her'),
  ConstellationBoundary(20.8750, 21.0500, 11.8333, 'Del'),
  ConstellationBoundary(21.0500, 21.1167, 11.8333, 'Peg'),
  ConstellationBoundary(11.5167, 11.8667, 11.0000, 'Leo'),
  ConstellationBoundary(6.2417, 6.3083, 10.0000, 'Ori'),
  ConstellationBoundary(6.9333, 7.0000, 10.0000, 'Gem'),
  ConstellationBoundary(7.8083, 7.9250, 10.0000, 'Cnc'),
  ConstellationBoundary(23.8333, 24.0000, 10.0000, 'Peg'),
  ConstellationBoundary(1.6667, 3.2833, 9.9167, 'Ari'),
  ConstellationBoundary(20.1417, 20.3000, 8.5000, 'Del'),
  ConstellationBoundary(13.5000, 15.0833, 8.0000, 'Boo'),
  ConstellationBoundary(22.7500, 23.8333, 7.5000, 'Peg'),
  ConstellationBoundary(7.9250, 9.2500, 7.0000, 'Cnc'),
  ConstellationBoundary(9.2500, 10.7500, 7.0000, 'Leo'),
  ConstellationBoundary(18.2500, 18.6622, 6.2500, 'Oph'),
  ConstellationBoundary(18.6622, 18.8667, 6.2500, 'Aql'),
  ConstellationBoundary(20.8333, 20.8750, 6.0000, 'Del'),
  ConstellationBoundary(7.0000, 7.0167, 5.5000, 'CMi'),
  ConstellationBoundary(18.2500, 18.4250, 4.5000, 'Ser'),
  ConstellationBoundary(16.0833, 16.7500, 4.0000, 'Her'),
  ConstellationBoundary(18.2500, 18.4250, 3.0000, 'Oph'),
  ConstellationBoundary(21.4667, 21.6667, 2.7500, 'Peg'),
  ConstellationBoundary(0.0000, 2.0000, 2.0000, 'Psc'),
  ConstellationBoundary(18.5833, 18.8667, 2.0000, 'Ser'),
  ConstellationBoundary(20.3000, 20.8333, 2.0000, 'Del'),
  ConstellationBoundary(20.8333, 21.3333, 2.0000, 'Equ'),
  ConstellationBoundary(21.3333, 21.4667, 2.0000, 'Peg'),
  ConstellationBoundary(22.0000, 22.7500, 2.0000, 'Peg'),
  ConstellationBoundary(21.6667, 22.0000, 1.7500, 'Peg'),
  ConstellationBoundary(7.0167, 7.2000, 1.5000, 'CMi'),
  ConstellationBoundary(3.5833, 4.6167, 0.0000, 'Tau'),
  ConstellationBoundary(4.6167, 4.6667, 0.0000, 'Ori'),
  ConstellationBoundary(7.2000, 8.0833, 0.0000, 'CMi'),
  ConstellationBoundary(14.6667, 15.0833, 0.0000, 'Vir'),
  ConstellationBoundary(17.8333, 18.2500, 0.0000, 'Oph'),
  ConstellationBoundary(2.6500, 3.2833, -1.7500, 'Cet'),
  ConstellationBoundary(3.2833, 3.5833, -1.7500, 'Tau'),
  ConstellationBoundary(15.0833, 16.2667, -3.2500, 'Ser'),
  ConstellationBoundary(4.6667, 5.0833, -4.0000, 'Ori'),
  ConstellationBoundary(5.8333, 6.2417, -4.0000, 'Ori'),
  ConstellationBoundary(17.8333, 17.9667, -4.0000, 'Ser'),
  ConstellationBoundary(18.2500, 18.5833, -4.0000, 'Ser'),
  ConstellationBoundary(18.5833, 18.8667, -4.0000, 'Aql'),
  ConstellationBoundary(22.7500, 23.8333, -4.0000, 'Psc'),
  ConstellationBoundary(10.7500, 11.5167, -6.0000, 'Leo'),
  ConstellationBoundary(11.5167, 11.8333, -6.0000, 'Vir'),
  ConstellationBoundary(0.0000, 0.3333, -7.0000, 'Psc'),
  ConstellationBoundary(23.8333, 24.0000, -7.0000, 'Psc'),
  ConstellationBoundary(14.2500, 14.6667, -8.0000, 'Vir'),
  ConstellationBoundary(15.9167, 16.2667, -8.0000, 'Oph'),
  ConstellationBoundary(20.0000, 20.5333, -9.0000, 'Aql'),
  ConstellationBoundary(21.3333, 21.8667, -9.0000, 'Aqr'),
  ConstellationBoundary(17.1667, 17.9667, -10.0000, 'Oph'),
  ConstellationBoundary(5.8333, 8.0833, -11.0000, 'Mon'),
  ConstellationBoundary(4.9167, 5.0833, -11.0000, 'Eri'),
  ConstellationBoundary(5.0833, 5.8333, -11.0000, 'Ori'),
  ConstellationBoundary(8.0833, 8.3667, -11.0000, 'Hya'),
  ConstellationBoundary(9.5833, 10.7500, -11.0000, 'Sex'),
  ConstellationBoundary(11.8333, 12.8333, -11.0000, 'Vir'),
  ConstellationBoundary(17.5833, 17.6667, -11.6667, 'Oph'),
  ConstellationBoundary(18.8667, 20.0000, -12.0333, 'Aql'),
  ConstellationBoundary(4.8333, 4.9167, -14.5000, 'Eri'),
  ConstellationBoundary(20.5333, 21.3333, -15.0000, 'Aqr'),
  ConstellationBoundary(17.1667, 18.2500, -16.0000, 'Ser'),
  ConstellationBoundary(18.2500, 18.8667, -16.0000, 'Sct'),
  ConstellationBoundary(8.3667, 8.5833, -17.0000, 'Hya'),
  ConstellationBoundary(16.2667, 16.3750, -18.2500, 'Oph'),
  ConstellationBoundary(8.5833, 9.0833, -19.0000, 'Hya'),
  ConstellationBoundary(10.7500, 10.8333, -19.0000, 'Crt'),
  ConstellationBoundary(16.2667, 16.3750, -19.2500, 'Sco'),
  ConstellationBoundary(15.6667, 15.9167, -20.0000, 'Lib'),
  ConstellationBoundary(12.5833, 12.8333, -22.0000, 'Crv'),
  ConstellationBoundary(12.8333, 14.2500, -22.0000, 'Vir'),
  ConstellationBoundary(9.0833, 9.7500, -24.0000, 'Hya'),
  ConstellationBoundary(1.6667, 2.6500, -24.3833, 'Cet'),
  ConstellationBoundary(2.6500, 3.7500, -24.3833, 'Eri'),
  ConstellationBoundary(10.8333, 11.8333, -24.5000, 'Crt'),
  ConstellationBoundary(11.8333, 12.5833, -24.5000, 'Crv'),
  ConstellationBoundary(14.2500, 14.9167, -24.5000, 'Lib'),
  ConstellationBoundary(16.2667, 16.7500, -24.5833, 'Oph'),
  ConstellationBoundary(0.0000, 1.6667, -25.5000, 'Cet'),
  ConstellationBoundary(21.3333, 21.8667, -25.5000, 'Cap'),
  ConstellationBoundary(21.8667, 23.8333, -25.5000, 'Aqr'),
  ConstellationBoundary(23.8333, 24.0000, -25.5000, 'Cet'),
  ConstellationBoundary(9.7500, 10.2500, -26.5000, 'Hya'),
  ConstellationBoundary(4.7000, 4.8333, -27.2500, 'Eri'),
  ConstellationBoundary(4.8333, 6.1167, -27.2500, 'Lep'),
  ConstellationBoundary(20.0000, 21.3333, -28.0000, 'Cap'),
  ConstellationBoundary(10.2500, 10.5833, -29.1667, 'Hya'),
  ConstellationBoundary(12.5833, 14.9167, -29.5000, 'Hya'),
  ConstellationBoundary(14.9167, 15.6667, -29.5000, 'Lib'),
  ConstellationBoundary(15.6667, 16.0000, -29.5000, 'Sco'),
  ConstellationBoundary(4.5833, 4.7000, -30.0000, 'Eri'),
  ConstellationBoundary(16.7500, 17.6000, -30.0000, 'Oph'),
  ConstellationBoundary(17.6000, 17.8333, -30.0000, 'Sgr'),
  ConstellationBoundary(10.5833, 10.8333, -31.1667, 'Hya'),
  ConstellationBoundary(6.1167, 7.3667, -33.0000, 'CMa'),
  ConstellationBoundary(12.2500, 12.5833, -33.0000, 'Hya'),
  ConstellationBoundary(10.8333, 12.2500, -35.0000, 'Hya'),
  ConstellationBoundary(3.5000, 3.7500, -36.0000, 'For'),
  ConstellationBoundary(8.3667, 9.3667, -36.7500, 'Pyx'),
  ConstellationBoundary(4.2667, 4.5833, -37.0000, 'Eri'),
  ConstellationBoundary(17.8333, 19.1667, -37.0000, 'Sgr'),
  ConstellationBoundary(21.3333, 23.0000, -37.0000, 'PsA'),
  ConstellationBoundary(23.0000, 23.3333, -37.0000, 'Scl'),
  ConstellationBoundary(3.0000, 3.5000, -39.5833, 'For'),
  ConstellationBoundary(9.3667, 11.0000, -39.7500, 'Ant'),
  ConstellationBoundary(0.0000, 1.6667, -40.0000, 'Scl'),
  ConstellationBoundary(1.6667, 3.0000, -40.0000, 'For'),
  ConstellationBoundary(3.8667, 4.2667, -40.0000, 'Eri'),
  ConstellationBoundary(23.3333, 24.0000, -40.0000, 'Scl'),
  ConstellationBoundary(14.1667, 14.9167, -42.0000, 'Cen'),
  ConstellationBoundary(15.6667, 16.0000, -42.0000, 'Lup'),
  ConstellationBoundary(16.0000, 16.4208, -42.0000, 'Sco'),
  ConstellationBoundary(4.8333, 5.0000, -43.0000, 'Cae'),
  ConstellationBoundary(5.0000, 6.5833, -43.0000, 'Col'),
  ConstellationBoundary(8.0000, 8.3667, -43.0000, 'Pup'),
  ConstellationBoundary(3.4167, 3.8667, -44.0000, 'Eri'),
  ConstellationBoundary(16.4208, 17.8333, -45.5000, 'Sco'),
  ConstellationBoundary(17.8333, 19.1667, -45.5000, 'CrA'),
  ConstellationBoundary(19.1667, 20.3333, -45.5000, 'Sgr'),
  ConstellationBoundary(20.3333, 21.3333, -45.5000, 'Mic'),
  ConstellationBoundary(3.0000, 3.4167, -46.0000, 'Eri'),
  ConstellationBoundary(4.5000, 4.8333, -46.5000, 'Cae'),
  ConstellationBoundary(15.3333, 15.6667, -48.0000, 'Lup'),
  ConstellationBoundary(0.0000, 2.3333, -48.1667, 'Phe'),
  ConstellationBoundary(2.6667, 3.0000, -49.0000, 'Eri'),
  ConstellationBoundary(4.0833, 4.2667, -49.0000, 'Hor'),
  ConstellationBoundary(4.2667, 4.5000, -49.0000, 'Cae'),
  ConstellationBoundary(21.3333, 22.0000, -50.0000, 'Gru'),
  ConstellationBoundary(6.0000, 8.0000, -50.7500, 'Pup'),
  ConstellationBoundary(8.0000, 8.1667, -50.7500, 'Vel'),
  ConstellationBoundary(2.4167, 2.6667, -51.0000, 'Eri'),
  ConstellationBoundary(3.8333, 4.0833, -51.0000, 'Hor'),
  ConstellationBoundary(0.0000, 1.8333, -51.5000, 'Phe'),
  ConstellationBoundary(6.0000, 6.1667, -52.5000, 'Car'),
  ConstellationBoundary(8.1667, 8.4500, -53.0000, 'Vel'),
  ConstellationBoundary(3.5000, 3.8333, -53.1667, 'Hor'),
  ConstellationBoundary(3.8333, 4.0000, -53.1667, 'Dor'),
  ConstellationBoundary(0.0000, 1.5833, -53.5000, 'Phe'),
  ConstellationBoundary(2.1667, 2.4167, -54.0000, 'Eri'),
  ConstellationBoundary(4.5000, 5.0000, -54.0000, 'Pic'),
  ConstellationBoundary(15.0500, 15.3333, -54.0000, 'Lup'),
  ConstellationBoundary(8.4500, 8.8333, -54.5000, 'Vel'),
  ConstellationBoundary(6.1667, 6.5000, -55.0000, 'Car'),
  ConstellationBoundary(11.8333, 12.8333, -55.0000, 'Cen'),
  ConstellationBoundary(14.1667, 15.0500, -55.0000, 'Lup'),
  ConstellationBoundary(15.0500, 15.3333, -55.0000, 'Nor'),
  ConstellationBoundary(4.0000, 4.3333, -56.5000, 'Dor'),
  ConstellationBoundary(8.8333, 11.0000, -56.5000, 'Vel'),
  ConstellationBoundary(11.0000, 11.2500, -56.5000, 'Cen'),
  ConstellationBoundary(17.5000, 18.0000, -57.0000, 'Ara'),
  ConstellationBoundary(18.0000, 20.3333, -57.0000, 'Tel'),
  ConstellationBoundary(22.0000, 23.3333, -57.0000, 'Gru'),
  ConstellationBoundary(3.2000, 3.5000, -57.5000, 'Hor'),
  ConstellationBoundary(5.0000, 5.5000, -57.5000, 'Pic'),
  ConstellationBoundary(6.5000, 6.8333, -58.0000, 'Car'),
  ConstellationBoundary(0.0000, 1.3333, -58.5000, 'Phe'),
  ConstellationBoundary(1.3333, 2.1667, -58.5000, 'Eri'),
  ConstellationBoundary(23.3333, 24.0000, -58.5000, 'Phe'),
  ConstellationBoundary(4.3333, 4.5833, -59.0000, 'Dor'),
  ConstellationBoundary(15.3333, 16.4208, -60.0000, 'Nor'),
  ConstellationBoundary(20.3333, 21.3333, -60.0000, 'Ind'),
  ConstellationBoundary(5.5000, 6.0000, -61.0000, 'Pic'),
  ConstellationBoundary(15.1667, 15.3333, -61.0000, 'Cir'),
  ConstellationBoundary(16.4208, 16.5833, -61.0000, 'Ara'),
  ConstellationBoundary(14.9167, 15.1667, -63.5833, 'Cir'),
  ConstellationBoundary(16.5833, 16.7500, -63.5833, 'Ara'),
  ConstellationBoundary(6.0000, 6.8333, -64.0000, 'Pic'),
  ConstellationBoundary(6.8333, 9.0333, -64.0000, 'Car'),
  ConstellationBoundary(11.2500, 11.8333, -64.0000, 'Cen'),
  ConstellationBoundary(11.8333, 12.8333, -64.0000, 'Cru'),
  ConstellationBoundary(12.8333, 14.5333, -64.0000, 'Cen'),
  ConstellationBoundary(13.5000, 13.6667, -65.0000, 'Cir'),
  ConstellationBoundary(16.7500, 16.8333, -65.0000, 'Ara'),
  ConstellationBoundary(2.1667, 3.2000, -67.5000, 'Hor'),
  ConstellationBoundary(3.2000, 4.5833, -67.5000, 'Ret'),
  ConstellationBoundary(14.7500, 14.9167, -67.5000, 'Cir'),
  ConstellationBoundary(16.8333, 17.5000, -67.5000, 'Ara'),
  ConstellationBoundary(17.5000, 18.0000, -67.5000, 'Pav'),
  ConstellationBoundary(22.0000, 23.3333, -67.5000, 'Tuc'),
  ConstellationBoundary(4.5833, 6.5833, -70.0000, 'Dor'),
  ConstellationBoundary(13.6667, 14.7500, -70.0000, 'Cir'),
  ConstellationBoundary(14.7500, 17.0000, -70.0000, 'TrA'),
  ConstellationBoundary(0.0000, 1.3333, -75.0000, 'Tuc'),
  ConstellationBoundary(3.5000, 4.5833, -75.0000, 'Hyi'),
  ConstellationBoundary(6.5833, 9.0333, -75.0000, 'Vol'),
  ConstellationBoundary(9.0333, 11.2500, -75.0000, 'Car'),
  ConstellationBoundary(11.2500, 13.6667, -75.0000, 'Mus'),
  ConstellationBoundary(18.0000, 21.3333, -75.0000, 'Pav'),
  ConstellationBoundary(21.3333, 23.3333, -75.0000, 'Ind'),
  ConstellationBoundary(23.3333, 24.0000, -75.0000, 'Tuc'),
  ConstellationBoundary(0.7500, 1.3333, -76.0000, 'Tuc'),
  ConstellationBoundary(0.0000, 3.5000, -82.5000, 'Hyi'),
  ConstellationBoundary(7.6667, 13.6667, -82.5000, 'Cha'),
  ConstellationBoundary(13.6667, 18.0000, -82.5000, 'Aps'),
  ConstellationBoundary(3.5000, 7.6667, -85.0000, 'Men'),
  ConstellationBoundary(0.0000, 24.0000, -90.0000, 'Oct'),
];

List<double> precess(
  double ra,
  double dec,
  double epoch1,
  double epoch2,
) {
  final r = [
    [0.0, 0.0, 0.0],
    [0.0, 0.0, 0.0],
    [0.0, 0.0, 0.0]
  ];
  final x1 = [0.0, 0.0, 0.0];
  final x2 = [0.0, 0.0, 0.0];

  final cdr = pi / 180.0;
  final csr = cdr / 3600.0;
  var a = cos(dec);
  x1[0] = a * cos(ra);
  x1[1] = a * sin(ra);
  x1[2] = sin(dec);
  final t = 0.001 * (epoch2 - epoch1);
  final st = 0.001 * (epoch1 - 1900.0);
  a = csr *
      t *
      (23042.53 +
          st * (139.75 + 0.06 * st) +
          t * (30.23 - 0.27 * st + 18.0 * t));
  final b = csr * t * t * (79.27 + 0.66 * st + 0.32 * t) + a;
  final c = csr *
      t *
      (20046.85 -
          st * (85.33 + 0.37 * st) +
          t * (-42.67 - 0.37 * st - 41.8 * t));

  final sina = sin(a);
  final sinb = sin(b);
  final sinc = sin(c);
  final cosa = cos(a);
  final cosb = cos(b);
  final cosc = cos(c);

  r[0][0] = cosa * cosb * cosc - sina * sinb;
  r[0][1] = -cosa * sinb - sina * cosb * cosc;
  r[0][2] = -cosb * sinc;
  r[1][0] = sina * cosb + cosa * sinb * cosc;
  r[1][1] = cosa * cosb - sina * sinb * cosc;
  r[1][2] = -sinb * sinc;
  r[2][0] = cosa * sinc;
  r[2][1] = -sina * sinc;
  r[2][2] = cosc;

  for (var i = 0; i < 3; i++) {
    x2[i] = r[i][0] * x1[0] + r[i][1] * x1[1] + r[i][2] * x1[2];
  }

  var ra0 = atan2(x2[1], x2[0]);

  if (ra0 < 0.0) {
    ra0 += 2.0 * pi;
  }

  final dec0 = asin(x2[2]);

  return [ra0, dec0];
}

String findConstellation(
  double ra,
  double dec,
) {
  final coords = precess(ra, dec, 2000.0, 1875.0);

  final ra0 = (coords[0] * 12) / pi;
  final dec0 = (coords[1] * 180) / pi;

  for (final boundary in boundaries) {
    if (dec0 >= boundary.decMin &&
        ra0 >= boundary.raMin &&
        ra0 < boundary.raMax) {
      return boundary.name;
    }
  }

  return null;
}
