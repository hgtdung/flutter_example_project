import 'package:flutter_example_project/di/service_locator.dart';
import 'package:flutter_example_project/features/page1_screen/page1_vm.dart';

setupViews() {
  serviceLocator.registerFactory<Page1VM>(() => Page1VM());
}