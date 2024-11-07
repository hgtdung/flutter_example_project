import 'package:flutter_example_project/data/data_provider/api/api_impl/authentication_api_impl.dart';
import 'package:flutter_example_project/data/data_provider/api/authentication_api.dart';
import 'package:flutter_example_project/di/service_locator.dart';

setupAPIs() {
  serviceLocator
      .registerLazySingleton<AuthenticationAPI>(() => AuthenticationAPIImpl());
}
