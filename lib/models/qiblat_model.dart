import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblatModel {
  final double direction;
  final double qiblah;
  final double offset;

  QiblatModel({
    required this.direction,
    required this.qiblah,
    required this.offset,
  });

  factory QiblatModel.fromPackage(QiblahDirection data) {
    return QiblatModel(
      direction: data.direction,
      qiblah: data.qiblah,
      offset: data.offset,
    );
  }

  double get normalizedOffset {
    var off = offset;
    while (off > 180) {
      off -= 360;
    }
    while (off < -180) {
      off += 360;
    }
    return off;
  }
}
