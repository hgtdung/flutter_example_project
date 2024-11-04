import 'package:flutter/material.dart';
import 'package:flutter_example_project/environment_config.dart';
import 'package:flutter_example_project/flutter_app.dart';
import 'package:flutter_example_project/main_stg.dart';

import 'features/main_screen/main_screen.dart';

void main() {
  EnvironmentConfig(
      flavor: Flavor.DEVELOPMENT,
      values: FlavorValues(
          baseUrl: "https://baseUrl",
          androidBundleId: "com.company.foundation_description",
          iosBundleId: "com.company.foundation_description",
          appName: "exampleAppStg",
          /// Using for login by ios
          iosClientId: "iosClientId",
          cdnUrl: "https://xxxURL"),
      enableCrashlytics: true
  );

  initApplication();
}

