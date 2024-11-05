//
// {{APP_NAME}}
// {{APP_NAME}}.dart
//
// Create by hoangdung 29/10/2024
//

import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_project/environment_config.dart';
import 'package:flutter_example_project/routes.dart';

import 'data/data_provider/api/network/exceptions/network_exceptions.dart';
import 'di/service_locator.dart';

void initApplication() {
  setupServiceLocator();

  runZonedGuarded((){
    runApp(const FlutterApp());

  }, (error, stackTrace) {
    /// Report crashlytics
    if ((error is NetworkExceptions)) {
      error.maybeWhen(orElse: () {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      }, unauthorisedRequest: () {

      });
    } else {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Routes.onGenerateRoute,

      // home: Scaffold(
      //   body: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       const SizedBox(height: 50,),
      //       Center(child: Text("Welcome to ${EnvironmentConfig.instance.values.appName}"))
      //     ],
      //   ),
      // ),
    );
  }
}
