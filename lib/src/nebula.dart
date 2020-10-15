import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:nebula/src/helper.dart';
import 'package:nebula/src/nebula_type.dart';

class Nebula extends Equatable {
  final int id;
  final int m; // Messier Catalog number
  final int ngc; // New General Catalog number
  final int ic; // Index Catalog number
  final int c; // Caldwell Catalog number
  final int b; // Barnard Catalog number (Dark Nebulae)
  // Sharpless Catalog number (Catalogue of HII Regions (Sharpless, 1959))
  final int sh2;
  // van den Bergh Catalog number (Catalogue of Reflection Nebulae (van den Bergh, 1966))
  final int vdb;
  // RCW Catalog number (H-α emission regions in Southern Milky Way (Rodgers+, 1960))
  final int rcw;
  // LDN Catalog number (Lynds' Catalogue of Dark Nebulae (Lynds, 1962))
  final int ldn;
  // LBN Catalog number (Lynds' Catalogue of Bright Nebulae (Lynds, 1965))
  final int lbn;
  final int cr; // Collinder Catalog number
  final int mel; // Melotte Catalog number
  final int pgc; // PGC number (Catalog of galaxies)
  final int ugc; // UGC number (The Uppsala General Catalogue of Galaxies)
  final int arp; // Arp number (Atlas of Peculiar Galaxies (Arp, 1966))
  // VV number (The Catalogue of Interacting Galaxies (Vorontsov-Velyaminov+, 2001))
  final int vv;
  // DWB number (Catalogue and distances of optically visible H II regions (Dickel+, 1969))
  final int dwb;
  final int tr; // Tr number (Trumpler Catalogue)
  final int st; // St number (Stock Catalogue)
  final int ru; // Ru number (Ruprecht Catalogue)
  final int vdbha; // vdB-Ha number (van den Bergh-Hagen Catalogue)
  // Ced number (Cederblad Catalog of bright diffuse Galactic nebulae)
  final String ced;
  // PK number (Catalogue of Galactic Planetary Nebulae)
  final String pk;
  // PN G number (Strasbourg-ESO Catalogue of Galactic Planetary Nebulae (Acker+, 1992))
  final String png;
  // SNR G number (A catalogue of Galactic supernova remnants (Green, 2014))
  final String snrg;
  final String aco; // ACO number (Rich Clusters of Galaxies (Abell+, 1989))
  final String hcg; // HCG number (Hickson Compact Group (Hickson, 1989))
  // ESO number (ESO/Uppsala Survey of the ESO(B) Atlas (Lauberts, 1982))
  final String eso;
  // VdBH number (Southern Stars embedded in nebulosity (van den Bergh+, 1975))
  final String vdbh;
  final String mType; // Morphological type of object (as string)
  final double bMag; // B magnitude
  final double vMag; // V magnitude.
  final double majorAxisSize; // Major axis size in degrees
  final double minorAxisSize; // Minor axis size in degrees
  final int orientationAngle; // Orientation angle in degrees
  final double distance; // distance (kpc)
  final double distanceErr; // Error of distance (kpc)
  final double redshift;
  final double redshiftErr;
  final double parallax; // Parallax in milliarcseconds (mas)
  final double parallaxErr;
  final double ra, dec;
  final NebulaType type;
  final List<String> names; // English names
  final double surfaceBrightness; // mag/arcsec²
  final String constellation;
  final bool h400;
  final bool bennett;
  final bool dunlop;

  const Nebula({
    this.id = 0,
    this.m = 0,
    this.ngc = 0,
    this.ic = 0,
    this.c = 0,
    this.b = 0,
    this.sh2 = 0,
    this.vdb = 0,
    this.rcw = 0,
    this.ldn = 0,
    this.lbn = 0,
    this.cr = 0,
    this.mel = 0,
    this.pgc = 0,
    this.ugc = 0,
    this.arp = 0,
    this.vv = 0,
    this.dwb = 0,
    this.tr = 0,
    this.st = 0,
    this.ru = 0,
    this.vdbha = 0,
    this.ced = '',
    this.pk = '',
    this.png = '',
    this.snrg = '',
    this.aco = '',
    this.hcg = '',
    this.eso = '',
    this.vdbh = '',
    this.mType = '',
    this.bMag = 0,
    this.vMag = 0,
    this.majorAxisSize = 0,
    this.minorAxisSize = 0,
    this.orientationAngle = 0,
    this.distance = 0,
    this.distanceErr = 0,
    this.redshift = 0,
    this.redshiftErr = 0,
    this.parallax = 0,
    this.parallaxErr = 0,
    this.ra = 0,
    this.dec = 0,
    this.type,
    this.names = const [],
    this.surfaceBrightness = 0,
    this.constellation,
    this.h400 = false,
    this.bennett = false,
    this.dunlop = false,
  });

  Map<String, dynamic> toJson() {
    final json = SplayTreeMap<String, dynamic>();

    json['id'] = id;
    json['ra'] = ra;
    json['dec'] = dec;
    if (bMag != 99.0) {
      json['bMag'] = bMag.dp(2);
    }
    if (vMag != 99.0 && type != NebulaType.darkNebula) {
      json['vMag'] = vMag.dp(2);
    }
    json['type'] = type.index;
    if (mType.isNotEmpty) {
      json['mType'] = mType;
    }
    if (majorAxisSize != 0) {
      json['majorAxisSize'] = majorAxisSize.dp(8);
    }
    if (minorAxisSize != 0) {
      json['minorAxisSize'] = minorAxisSize.dp(8);
    }
    if (orientationAngle >= 0 && orientationAngle <= 360) {
      json['orientationAngle'] = orientationAngle;
    }
    if (redshift != 99.0) {
      json['redshift'] = redshift.dp(8);
    }
    if (redshiftErr != 0) {
      json['redshiftErr'] = redshiftErr.dp(8);
    }
    if (parallax != 0) {
      json['parallax'] = parallax;
    }
    if (parallaxErr != 0) {
      json['parallaxErr'] = parallaxErr;
    }
    if (distance != 0) {
      json['distance'] = distance.dp(3);
    }
    if (distanceErr != 0) {
      json['distanceErr'] = distanceErr.dp(3);
    }
    if (ngc > 0) {
      json['ngc'] = ngc;
    }
    if (ic > 0) {
      json['ic'] = ic;
    }
    if (m > 0) {
      json['m'] = m;
    }
    if (c > 0) {
      json['c'] = c;
    }
    if (b > 0) {
      json['b'] = b;
    }
    if (sh2 > 0) {
      json['sh2'] = sh2;
    }
    if (vdb > 0) {
      json['vdb'] = vdb;
    }
    if (rcw > 0) {
      json['rcw'] = rcw;
    }
    if (ldn > 0) {
      json['ldn'] = ldn;
    }
    if (lbn > 0) {
      json['lbn'] = lbn;
    }
    if (cr > 0) {
      json['cr'] = cr;
    }
    if (mel > 0) {
      json['mel'] = mel;
    }
    if (pgc > 0) {
      json['pgc'] = pgc;
    }
    if (ugc > 0) {
      json['ugc'] = ugc;
    }
    if (ced.isNotEmpty) {
      json['ced'] = ced;
    }
    if (arp > 0) {
      json['arp'] = arp;
    }
    if (vv > 0) {
      json['vv'] = vv;
    }
    if (pk.isNotEmpty) {
      json['pk'] = pk;
    }
    if (png.isNotEmpty) {
      json['png'] = png;
    }
    if (snrg.isNotEmpty) {
      json['snrg'] = snrg;
    }
    if (aco.isNotEmpty) {
      json['aco'] = aco;
    }
    if (hcg.isNotEmpty) {
      json['hcg'] = hcg;
    }
    if (eso.isNotEmpty) {
      json['eso'] = eso;
    }
    if (vdbh.isNotEmpty) {
      json['vdbh'] = vdbh;
    }
    if (dwb > 0) {
      json['dwb'] = dwb;
    }
    if (tr > 0) {
      json['tr'] = tr;
    }
    if (st > 0) {
      json['st'] = st;
    }
    if (ru > 0) {
      json['ru'] = ru;
    }
    if (vdbha > 0) {
      json['vdbha'] = vdbha;
    }
    if (surfaceBrightness != 99.0) {
      json['surfaceBrightness'] = surfaceBrightness.dp(2);
    }
    if (constellation.isNotEmpty) {
      json['constellation'] = constellation;
    }
    if (h400) {
      json['h400'] = h400;
    }
    if (bennett) {
      json['bennett'] = bennett;
    }
    if (dunlop) {
      json['dunlop'] = dunlop;
    }

    if (names.isNotEmpty) {
      json['names'] = names;
    }

    return json;
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        m,
        ngc,
        ic,
        c,
        b,
        sh2,
        vdb,
        rcw,
        ldn,
        lbn,
        cr,
        mel,
        pgc,
        ugc,
        arp,
        vv,
        dwb,
        tr,
        st,
        ru,
        vdbha,
        ced,
        pk,
        png,
        snrg,
        aco,
        hcg,
        eso,
        vdbh,
        mType,
        bMag,
        vMag,
        majorAxisSize,
        minorAxisSize,
        orientationAngle,
        distance,
        distanceErr,
        redshift,
        redshiftErr,
        parallax,
        parallaxErr,
        ra,
        dec,
        type,
        names,
        surfaceBrightness,
        constellation,
        h400,
        bennett,
        dunlop,
      ];
}
