# Nebula

A command-line utility for extract the Stellarium DSO Catalog to JSON and generate photos.

## Features
* Over 94000 objects from Standard Edition and over one million objects from Extended Edition.
* Messier Catalogue (M), Caldwell Catalogue (C), Barnard Catalogue (B), Sharpless Catalogue (Sh2), van den Bergh Catalogue (VdB), RCW Catalogue, Collinder Catalogue (Cr), Melotte Catalogue (Mel), New General Catalogue (NGC), Index Catalogue (IC), Lynds' Catalogue of Bright Nebulae (LBN), Lynds' Catalogue of Dark Nebulae (LDN), Cederblad Catalog (Ced), Atlas of Peculiar Galaxies (Arp), The Catalogue of Interacting Galaxies by Vorontsov-Velyaminov (VV), Catalogue of Galactic Planetary Nebulae (PK), Strasbourg-ESO Catalogue of Galactic Planetary Nebulae by Acker et. al. (PN G), A catalogue of Galactic supernova remnants by Green (SNR G), A Catalog of Rich Clusters of Galaxies by Abell et. al. (Abell (ACO)), Hickson Compact Group by Hickson et. al. (HCG), ESO/Uppsala Survey of the ESO(B) Atlas (ESO), Catalogue of southern stars embedded in nebulosity (vdBH), Catalogue and distances of optically visible H II regions (DWB), Trumpler Catalogue. Tr), Stock Catalogue (St), Ruprecht Catalogue (Ru), van den Bergh-Hagen Catalogue (VdB-Ha), Herschel 400 Catalogue, Jack Bennett's deep sky catalogue, James Dunlop's deep sky catalogue.
* V and B Magnitude, Morphological type, Major axis size, Minor axis size, Orientation angle, Distance, Parallax, Redshift, Surface Brightness.

## Instructions for Linux

1. Install Dart SDK: https://dart.dev/get-dart.

2. Activate the package:

```
pub global activate -sgit https://github.com/tiagohm/nebula-tool
```

## Data

Use this tool to extract the Stellarium DSO Catalog to JSON.

```shell
# downloads the catalog from Stellarium's repository or reuse the downloaded one and generates the minified JSON.
nebula data -m

# updates the downloaded catalogs and generates the JSON.
nebula data -f
```

* If `-i` or `--input` option is present, sets the Stellarium DSO catalog file path. Otherwise, will be downloaded from Stellarium's repository or reuse the file has been downloaded (`catalog.dat` or `catalog.extended.dat`).
* If `-n` or `--names` option is present, sets the Stellarium DSO catalog name file path. Otherwise, will be downloaded from Stellarium's repository or reuse the file has been downloaded (`names.dat`).
* If `-x` or `--extended` flag is present, indicates that the Extended Edition should be used.
* If `-m` or `--minify` flag is present, generates a minified JSON.
* If `-z` or `--zipped` flag is present, generates a zipped JSON named as `catalog.json.gz`.
* If `-f` or `--force` flag is present, the downloaded files will be ignored and a new download will be started to overwrite the ones. This options is ignored for DSO catalog file and DSO names catalog file if `-i` and `-n` is present, respectively.
* If `-o` or `--output` option is present, sets the JSON Catalog file path. The default is `catalog.json`.

## Photo

Use this tool to generate photos from `archive.stsci.edu` for each Stellarium DSO Catalog's object.

```shell
# generates photos for each DSO from catalog.json with quality=70 and webp format.
nebula photo -i catalog.json -q 70 --webp
```

* `-i` or `--input` option sets the Stellarium DSO catalog file path. Can be an `filepath`, `URL` or the following syntax `id:ra:dec`.
* If `-o` or `--output` option is present, sets the output directory of photos. The default is `./photos`.
* If `--webp` flag is present, generates the photos in WebP format. First, you need to run `sudo apt install webp`;
* If `-q` or `--quality` option is present, sets the photo quality (0-100). The default is 90;
* If `-w` or `--width` option is present, sets the photo width. The default is 512;
* If `-h` or `--height` option is present, sets the photo height. The default is 512;
* If `-r` or `--reverse` option is present, the photos will be generated from last catalog entry;
* `--version` option is present, sets the photo version. The default is `poss2ukstu_blue` (main) or `phase2_gsc2` (fallback). The available versions are: `poss2ukstu_red`, `poss2ukstu_blue`, `poss2ukstu_ir`, `poss1_red`, `poss1_blue`, `quickv`, `phase2_gsc2` and `phase2_gsc1'`. Some versions may not exist for certain coordinates. Multiple versions are accepted using the following syntax `main:fallback0:fallback1`. Using `alt`, sets the main and fallback version to `poss1_blue` and `phase2_gsc1`, respectively;
