import 'dart:convert';
import 'dart:math';

import 'package:nebula/src/constellation_boundary.dart';
import 'package:nebula/src/nebula.dart';
import 'package:nebula/src/nebula_type.dart';
import 'package:raw/raw.dart';

const _h400 = [
  40, 129, 136, 157, 185, 205, 225, 246, 247, 253, 278, 288, //
  381, 404, 436, 457, 488, 524, 559, 584, 596, 598, 613, 615, //
  637, 650, 654, 659, 663, 720, 752, 772, 779, 869, 884, 891, //
  908, 936, 1022, 1023, 1027, 1052, 1055, 1084, 1245, 1342, 1407, 1444, //
  1501, 1502, 1513, 1528, 1535, 1545, 1647, 1664, 1788, 1817, 1857, 1907, //
  1931, 1961, 1964, 1980, 1999, 2022, 2024, 2126, 2129, 2158, 2169, 2185, //
  2186, 2194, 2204, 2215, 2232, 2244, 2251, 2264, 2266, 2281, 2286, 2301, //
  2304, 2311, 2324, 2335, 2343, 2353, 2354, 2355, 2360, 2362, 2371, 2372, //
  2392, 2395, 2403, 2419, 2420, 2421, 2422, 2423, 2438, 2440, 2479, 2482, //
  2489, 2506, 2509, 2527, 2539, 2548, 2567, 2571, 2613, 2627, 2655, 2681, //
  2683, 2742, 2768, 2775, 2782, 2787, 2811, 2841, 2859, 2903, 2950, 2964, //
  2974, 2976, 2985, 3034, 3077, 3079, 3115, 3147, 3166, 3169, 3184, 3190, //
  3193, 3198, 3226, 3227, 3242, 3245, 3277, 3294, 3310, 3344, 3377, 3379, //
  3384, 3395, 3412, 3414, 3432, 3486, 3489, 3504, 3521, 3556, 3593, 3607, //
  3608, 3610, 3613, 3619, 3621, 3626, 3628, 3631, 3640, 3655, 3665, 3675, //
  3686, 3726, 3729, 3810, 3813, 3877, 3893, 3898, 3900, 3912, 3938, 3941, //
  3945, 3949, 3953, 3962, 3982, 3992, 3998, 4026, 4027, 4030, 4036, 4039, //
  4041, 4051, 4085, 4088, 4102, 4111, 4143, 4147, 4150, 4151, 4179, 4203, //
  4214, 4216, 4245, 4251, 4258, 4261, 4273, 4274, 4278, 4281, 4293, 4303, //
  4314, 4346, 4350, 4361, 4365, 4371, 4394, 4414, 4419, 4429, 4435, 4438, //
  4442, 4448, 4449, 4450, 4459, 4473, 4477, 4478, 4485, 4490, 4494, 4526, //
  4527, 4535, 4536, 4546, 4548, 4550, 4559, 4565, 4570, 4594, 4596, 4618, //
  4631, 4636, 4643, 4654, 4656, 4660, 4665, 4666, 4689, 4697, 4698, 4699, //
  4725, 4753, 4754, 4762, 4781, 4800, 4845, 4856, 4866, 4900, 4958, 4995, //
  5005, 5033, 5054, 5195, 5248, 5273, 5322, 5363, 5364, 5466, 5473, 5474, //
  5557, 5566, 5576, 5631, 5634, 5676, 5689, 5694, 5746, 5846, 5866, 5897, //
  5907, 5982, 6118, 6144, 6171, 6207, 6217, 6229, 6235, 6284, 6287, 6293, //
  6304, 6316, 6342, 6355, 6356, 6369, 6401, 6426, 6440, 6445, 6451, 6514, //
  6517, 6520, 6522, 6528, 6540, 6543, 6544, 6553, 6568, 6569, 6583, 6624, //
  6629, 6633, 6638, 6642, 6645, 6664, 6712, 6755, 6756, 6781, 6802, 6818, //
  6823, 6826, 6830, 6834, 6866, 6882, 6885, 6905, 6910, 6934, 6939, 6940, //
  6946, 7000, 7006, 7008, 7009, 7044, 7062, 7086, 7128, 7142, 7160, 7209, //
  7217, 7243, 7296, 7331, 7380, 7448, 7479, 7510, 7606, 7662, 7686, 7723, //
  7727, 7789, 7790, 7814,
];

// Details: http://www.docdb.net/tutorials/bennett_catalogue.php
// Esp. for southern observers
// NGC 1291 = NGC 1269
const _bennett = [
  55, 104, 247, 253, 288, 300, 362, 613, 1068, 1097, 1232, 1261, //
  1269, 1313, 1316, 1350, 1360, 1365, 1380, 1387, 1399, 1398, 1404, 1433, //
  1512, 1535, 1549, 1553, 1566, 1617, 1672, 1763, 1783, 1792, 1818, 1808, //
  1851, 1866, 1904, 2070, 2214, 2243, 2298, 2467, 2489, 2506, 2627, 2671, //
  2808, 2972, 2997, 3115, 3132, 3201, 3242, 3621, 3960, 3923, 4372, 4590, //
  4594, 4697, 4699, 4753, 4833, 4945, 4976, 5061, 5068, 5128, 5139, 5189, //
  5236, 5253, 5286, 5617, 5634, 5824, 5897, 5927, 5986, 5999, 6005, 6093, //
  6101, 6121, 6134, 6144, 6139, 6171, 6167, 6192, 6218, 6216, 6235, 6254, //
  6253, 6266, 6273, 6284, 6287, 6293, 6304, 6316, 6318, 6333, 6356, 6352, //
  6362, 6388, 6402, 6397, 6440, 6445, 6441, 6496, 6522, 6528, 6544, 6541, //
  6553, 6569, 6584, 6603, 6618, 6624, 6626, 6638, 6637, 6642, 6652, 6656, //
  6681, 6705, 6712, 6715, 6723, 6744, 6752, 6809, 6818, 6864, 6981, 7009, //
  7089, 7099, 7293, 7410, 7793,
];

// Details: http://www.docdb.net/tutorials/dunlop_catalogue.php
// Esp. for southern observers
// NGC 1291 = NGC 1269
const _dunlop = [
  7590, 7599, 104, 330, 346, 362, 6101, 1795, 1943, 2019, 2058, 2122, //
  1743, 1910, 1928, 1966, 2070, 2069, 2136, 4833, 1755, 1770, 1936, 2159, //
  2164, 2156, 2214, 1313, 1869, 1955, 1974, 2004, 2121, 2035, 6362, 1810, //
  1818, 2029, 2027, 1831, 6744, 2808, 4609, 5281, 5316, 3766, 4103, 4349, //
  6752, 3114, 4755, 5617, 6025, 3372, 4852, 5606, 3532, 6087, 5715, 6005, //
  1261, 5662, 5999, 1515, 3960, 3330, 5749, 5925, 6031, 6067, 6208, 6397, //
  6584, 3228, 5286, 5927, 2972, 6167, 7049, 2547, 4945, 6134, 6193, 6352, //
  6861, 1433, 5460, 1493, 5139, 6204, 3201, 6216, 6259, 6388, 1512, 5643, //
  6541, 625, 1487, 3680, 5128, 6192, 1269, 6231, 55, 1851, 4709, 6124, //
  7410, 6242, 6268, 6318, 2477, 6139, 1317, 1316, 1808, 5986, 6281, 6441, //
  1436, 2546, 2818, 6400, 6723, 1380, 2298, 1350, 2090, 1532, 6652, 2658, //
  6416, 6637, 6681, 3621, 6569, 6809, 5253, 6715, 2489, 6266, 5236,
];

final _commentRx = RegExp(r'^(\s*#.*|\s*)$');
final _transRx = RegExp('_[(]\"(.*)\"[)](\\s*#.*)?');

Map<dynamic, List<String>> _parseNames(List<String> data) {
  if (data == null || data.isEmpty) {
    return const {};
  }

  final names = <dynamic, List<String>>{};

  for (final line in data) {
    if (_commentRx.hasMatch(line)) {
      continue;
    }

    // bytes 1 - 5, designator for catalogue (prefix)
    final ref = line.substring(0, 5).trim().toUpperCase();
    // bytes 6 -20, identificator for object in the catalog
    final cdes = line.substring(5, 15).trim().toUpperCase();
    // bytes 21-80, proper name of the object (translatable)
    // Let gets the name with trimmed whitespaces
    final name = line.substring(21).trim();
    dynamic id;

    switch (ref) {
      case 'CED':
      case 'PK':
      case 'PNG':
      case 'SNRG':
      case 'ACO':
      case 'HCG':
      case 'ESO':
      case 'VDBH':
        id = cdes;
        break;
      default:
        id = int.parse(cdes);
        break;
    }

    final m = _transRx.firstMatch(name);

    if (m != null) {
      names.putIfAbsent('$ref.$id', () => []).add(m.group(1).trim());
    }
  }

  return names;
}

class NebulaDecoder extends Converter<List<int>, List<Nebula>> {
  final List<String> names;
  final int limit;
  final void Function(int count, bool end) progress;

  const NebulaDecoder({
    this.names,
    this.limit,
    this.progress,
  });

  static String _readString(RawReader reader) {
    final sb = StringBuffer();
    final length = reader.readUint32();

    for (var i = 0; i < length; i += 2) {
      final a = reader.readUint8();
      final b = reader.readUint8();
      sb.write(String.fromCharCode((a << 8) | b));
    }

    return sb.toString();
  }

  static int _readInt(RawReader reader) {
    return reader.readUint32();
  }

  static double _readFloat(RawReader reader) {
    return reader.readFloat64();
  }

  @override
  List<Nebula> convert(List<int> input) {
    final reader = RawReader.withBytes(input, isCopyOnRead: false);

    final version = _readString(reader);
    final edition = _readString(reader);

    assert(version == '3.10');
    assert(edition == 'standard' || edition == 'extended');

    final data = <Nebula>[];
    final nameMap = _parseNames(names);
    final namesTotal =
        nameMap?.values?.fold<int>(0, (a, b) => a + b.length) ?? 0;
    var namesCount = 0;

    while (reader.availableLengthInBytes > 0) {
      final id = _readInt(reader);
      final ra = _readFloat(reader);
      final dec = _readFloat(reader);
      final bMag = _readFloat(reader);
      final vMag = _readFloat(reader);
      final type = NebulaType.values[_readInt(reader)];
      final mType = _readString(reader);
      final majorAxisSize = _readFloat(reader);
      final minorAxisSize = _readFloat(reader);
      final orientationAngle = _readInt(reader);
      final redshift = _readFloat(reader);
      final redshiftErr = _readFloat(reader);
      final parallax = _readFloat(reader);
      final parallaxErr = _readFloat(reader);
      var distance = _readFloat(reader);
      var distanceErr = _readFloat(reader);
      final ngc = _readInt(reader);
      final ic = _readInt(reader);
      final m = _readInt(reader);
      final c = _readInt(reader);
      final b = _readInt(reader);
      final sh2 = _readInt(reader);
      final vdb = _readInt(reader);
      final rcw = _readInt(reader);
      final ldn = _readInt(reader);
      final lbn = _readInt(reader);
      final cr = _readInt(reader);
      final mel = _readInt(reader);
      final pgc = _readInt(reader);
      final ugc = _readInt(reader);
      final ced = _readString(reader);
      final arp = _readInt(reader);
      final vv = _readInt(reader);
      final pk = _readString(reader);
      final png = _readString(reader);
      final snrg = _readString(reader);
      final aco = _readString(reader);
      final hcg = _readString(reader);
      final eso = _readString(reader);
      final vdbh = _readString(reader);
      final dwb = _readInt(reader);
      final tr = _readInt(reader);
      final st = _readInt(reader);
      final ru = _readInt(reader);
      final vdbha = _readInt(reader);

      // Compute distance in light years.
      if (parallax.abs() > 0.0) {
        // Distance in light years from parallax.
        distance =
            3.162e-5 / (parallax.abs() * 4.84813681109535993589914102e-9);

        if (parallaxErr > 0.0) {
          distanceErr = (3.162e-5 /
                      ((parallaxErr + parallax).abs() *
                          4.84813681109535993589914102e-9) -
                  distance)
              .abs();
        }
      } else if (distance > 0.0) {
        distance = distance * 3263.79772496001399608531000891288384;
        distanceErr = distanceErr * 3263.79772496001399608531000891288384;
      }

      // Compute the surface brightness.
      // const float sq = 3600.f; // arcmin².
      final sq = 3600.0 * 3600.0; // arcsec².
      final mag = min(vMag, bMag);

      final surfaceArea = minorAxisSize == 0.0
          // S = pi*R^2 = pi*(D/2)^2
          ? pi * (majorAxisSize / 2.0) * (majorAxisSize / 2.0)
          // S = pi*a*b
          : pi * (majorAxisSize / 2.0) * (minorAxisSize / 2.0);

      final surfaceBrightness =
          (mag < 99.0 && majorAxisSize > 0.0 && type != NebulaType.darkNebula)
              ? mag + 2.5 * (log(surfaceArea * sq) / ln10)
              : 99.0;

      // Dunlop Catalogue.
      final dunlop = _dunlop.any((e) => e == ngc);
      // Bennett Catalogue (152 objects).
      final bennett =
          _bennett.any((e) => e == ngc) || mel == 105 || ic == 1459 || tr == 23;
      // Herschel 400 Catalogue (143 objects).
      final h400 = _h400.any((e) => e == ngc);

      // Names.

      List<String> findNames() {
        final references = [
          'IC.$ic',
          'M.$m',
          'C.$c',
          'CR.$cr',
          'MEL.$mel',
          'B.$b',
          'SH2.$sh2',
          'VDB.$vdb',
          'RCW.$rcw',
          'LDN.$ldn',
          'LBN.$lbn',
          'NGC.$ngc',
          'PGC.$pgc',
          'UGC.$ugc',
          'CED.$ced',
          'ARP.$arp',
          'VV.$vv',
          'PK.$pk',
          'PNG.$png',
          'SNRG.$snrg',
          'ACO.$aco',
          'HCG.$hcg',
          'ESO.$eso',
          'VDBH.$vdbh',
          'DWB.$dwb',
          'TR.$tr',
          'ST.$st',
          'RU.$ru',
          'VDBHA.$vdbha',
          '.$id',
        ];

        for (final ref in references) {
          if (nameMap.containsKey(ref)) {
            return nameMap[ref];
          }
        }

        return const [];
      }

      final nebula = Nebula(
        id: id,
        ra: ra,
        dec: dec,
        bMag: bMag,
        vMag: vMag,
        type: type,
        mType: mType,
        majorAxisSize: majorAxisSize,
        minorAxisSize: minorAxisSize,
        orientationAngle: orientationAngle,
        redshift: redshift,
        redshiftErr: redshiftErr,
        parallax: parallax,
        parallaxErr: parallaxErr,
        distance: distance,
        distanceErr: distanceErr,
        ngc: ngc,
        ic: ic,
        m: m,
        c: c,
        b: b,
        sh2: sh2,
        vdb: vdb,
        rcw: rcw,
        ldn: ldn,
        lbn: lbn,
        cr: cr,
        mel: mel,
        pgc: pgc,
        ugc: ugc,
        ced: ced,
        arp: arp,
        vv: vv,
        pk: pk,
        png: png,
        snrg: snrg,
        aco: aco,
        hcg: hcg,
        eso: eso,
        vdbh: vdbh,
        dwb: dwb,
        tr: tr,
        st: st,
        ru: ru,
        vdbha: vdbha,
        constellation: findConstellation(ra, dec),
        surfaceBrightness: surfaceBrightness,
        h400: h400,
        bennett: bennett,
        dunlop: dunlop,
        names: findNames(),
      );

      data.add(nebula);

      progress?.call(data.length, false);

      namesCount += nebula.names.length;

      if (limit != null && data.length == limit) {
        break;
      }
    }

    progress?.call(data.length, true);
    print('Loaded $namesCount/$namesTotal'
        ' DSO name records successfully');

    return data;
  }

  @override
  Sink<List<int>> startChunkedConversion(Sink<List<Nebula>> sink) {
    return ByteConversionSink.withCallback((data) {
      sink.add(convert(data));
      sink.close();
    });
  }
}
