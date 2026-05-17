import 'package:get_it/get_it.dart';
import 'package:tintin_money/features/shipper/data/Repositories/shipper_profile_repository.dart';
import 'package:tintin_money/features/shipper/services/shipper_data_service.dart';
import 'package:tintin_money/features/shipper/services/shipper_profile_service.dart';
import 'package:tintin_money/features/transaction/data/Repositories/daily_transaction_repository.dart';
import 'package:tintin_money/features/transaction/services/daily_transaction_service.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Đăng ký các services, repositories, usecases ở đây
  serviceLocator.registerLazySingleton<ShipperProfileService>(
    () => ShipperProfileService(),
  );

  serviceLocator.registerLazySingleton<DailyTransactionService>(
    () => DailyTransactionService(),
  );

  serviceLocator.registerLazySingleton<ShipperDataService>(
    () => ShipperDataService(
      ShipperProfileRepository(),
      DailyTransactionRepository(),
    ),
  );
}
