//
// {{APP_NAME}}
// {{APP_NAME}}.dart
//
// Create by hoangdung 29/10/2024
//

import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_project/routes.dart';
import 'package:flutter_example_project/utils/themes/app_theme.dart';

import 'data/data_provider/api/network/exceptions/network_exceptions.dart';
import 'di/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return  MaterialApp(
      locale: const Locale("es"),
      onGenerateRoute: Routes.onGenerateRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: TAppTheme.lightTheme,
    );
  }
}
