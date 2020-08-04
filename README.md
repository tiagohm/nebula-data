# Nebula

A command-line utility for extract Stellarium DSO Catalog to JSON.

## Features
* Over 94000 objects from Standard Edition and over one million objects from Extended Edition.
* Messier Catalogue (M), Caldwell Catalogue (C), Barnard Catalogue (B), Sharpless Catalogue (Sh2), van den Bergh Catalogue (VdB), RCW Catalogue, Collinder Catalogue (Cr), Melotte Catalogue (Mel), New General Catalogue (NGC), Index Catalogue (IC), Lynds' Catalogue of Bright Nebulae (LBN), Lynds' Catalogue of Dark Nebulae (LDN), Cederblad Catalog (Ced), Atlas of Peculiar Galaxies (Arp), The Catalogue of Interacting Galaxies by Vorontsov-Velyaminov (VV), Catalogue of Galactic Planetary Nebulae (PK), Strasbourg-ESO Catalogue of Galactic Planetary Nebulae by Acker et. al. (PN G), A catalogue of Galactic supernova remnants by Green (SNR G), A Catalog of Rich Clusters of Galaxies by Abell et. al. (Abell (ACO)), Hickson Compact Group by Hickson et. al. (HCG), ESO/Uppsala Survey of the ESO(B) Atlas (ESO), Catalogue of southern stars embedded in nebulosity (vdBH), Catalogue and distances of optically visible H II regions (DWB), Trumpler Catalogue (Tr), Stock Catalogue (St), Ruprecht Catalogue (Ru), van den Bergh-Hagen Catalogue (VdB-Ha), Herschel 400 Catalogue, Jack Bennett's deep sky catalogue, James Dunlop's deep sky catalogue.
* V and B Magnitude, Morphological type, Major axis size, Minor axis size, Orientation angle, Distance, Parallax, Redshift, Surface Brightness.

## Instructions for Linux

1. Install Dart SDK: https://dart.dev/get-dart.

2. Activate the package:

```
pub global activate -sgit https://gitlab.com/tiagohm/nebula-data
```

3. Run the script:

```shell
nebula -i <path> -n <path> -x -c -f -o <path>
```

* If `-i` option is present, defines the Stellarium DSO catalog file path. Otherwise, will be downloaded from Stellarium's repository or use the file has been downloaded (`catalog.dat` or `catalog.extended.dat`).
* If `-n` option is present, defines the Stellarium DSO catalog name file path. Otherwise, will be downloaded from Stellarium's repository or use the file has been downloaded (`names.dat`).
* If `-x` option is present, indicates that the Extended Edition should be used.
* If `-m` option is present, generates minified JSON.
* If `-z` option is present, generates zipped JSON named as `catalog.json.gz`.
* If `-f` options is present, the downloaded files will be ignored and a new download will be started to overwrite the ones. This options is ignored for DSO catalog file and DSO names catalog file if `-i` and `n` is present, respectively.
* If `-o` option is present, defines the JSON Catalog file path. The default is `catalog.json`.