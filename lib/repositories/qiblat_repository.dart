// Ganti yang '../models/qiblat_model.dart' jadi begini:
import 'package:muslim_app/models/qiblat_model.dart';
import 'package:muslim_app/services/qiblat_service.dart';

class QiblatRepository {
  final QiblatService service;

  QiblatRepository(this.service);

  Future<bool> checkSensorAvailability() => service.isSensorAvailable;

  Future<bool> requestPermissions() => service.requestLocationPermission();

  Stream<QiblatModel> get qiblahStream {
    return service.qiblahStream.map((data) => QiblatModel.fromPackage(data));
  }
}
