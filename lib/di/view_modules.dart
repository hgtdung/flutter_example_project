import 'package:flutter_example_project/data/repositories/authentication_repository.dart';
import 'package:flutter_example_project/di/service_locator.dart';
import 'package:flutter_example_project/features/page1_screen/page1_vm.dart';
import 'package:flutter_example_project/features/page2_screen/bloc/page2_bloc.dart';
import 'package:flutter_example_project/features/page2_screen/bloc/page2_state.dart';

setupViews() {
  serviceLocator.registerFactory<Page1VM>(() => Page1VM());

  serviceLocator.registerFactory<Page2Bloc>(() => Page2Bloc(serviceLocator<AuthenticationRepository>()));
}