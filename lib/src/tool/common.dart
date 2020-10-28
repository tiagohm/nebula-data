import 'package:nebula/src/progress_bar.dart';
import 'package:restio/restio.dart';

const defaultQuality = 90;
const defaultWidth = 512;
const defaultHeight = 512;

final progressBar = ProgressBar();

final restio = Restio(
  onDownloadProgress: (res, length, total, end) {
    final contentLength = res.headers.last('Content-Length')?.asInt ?? -1;

    if (contentLength > 0) {
      final progress = (total * 100 / contentLength).toStringAsFixed(1);
      progressBar.update('Progress: $total/$contentLength ($progress%)');

      if (end) {
        progressBar.end();
      }
    }
  },
);
