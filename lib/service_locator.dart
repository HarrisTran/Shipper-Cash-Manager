import 'package:get_it/get_it.dart';
import 'package:tintin_money/features/shipper/services/shipper_profile_service.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Đăng ký các services, repositories, usecases ở đây
  // Ví dụ:
  // serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  serviceLocator.registerLazySingleton<ShipperProfileService>(
    () => ShipperProfileService(),
  );
}
