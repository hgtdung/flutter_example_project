import 'package:flutter_example_project/data/data_provider/api/authentication_api.dart';
import 'package:flutter_example_project/data/repositories/authentication_repository.dart';
import 'package:flutter_example_project/data/repositories/impl/authentication_repository_impl.dart';
import 'package:flutter_example_project/di/service_locator.dart';

setupRepositories() {
  serviceLocator.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(serviceLocator<AuthenticationAPI>()));
}
