import 'package:flutter_example_project/di/api_modules.dart';
import 'package:flutter_example_project/di/repository_modules.dart';
import 'package:flutter_example_project/di/view_modules.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  setupAPIs();

  setupRepositories();

  setupViews();
}