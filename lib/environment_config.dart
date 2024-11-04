enum Flavor { DEVELOPMENT, STAGING, PRODUCTION }

class FlavorValues {
  final String baseUrl;
  final String androidBundleId;
  final String iosBundleId;
  final String iosClientId;
  final String appName;
  final String cdnUrl;
  final String amplitudeKey;
  final String amplitudeProjectName;
  final String andBuzzBooster;
  final String iosBuzzBooster;

  FlavorValues(
      {required this.baseUrl,
        required this.androidBundleId,
        required this.iosBundleId,
        required this.appName,
        required this.iosClientId,
        required this.cdnUrl,
        this.amplitudeKey = "",
        this.amplitudeProjectName = "",
        this.andBuzzBooster = "",
        this.iosBuzzBooster = ""});
}

class EnvironmentConfig {
  final Flavor flavor;
  final FlavorValues values;
  final bool enableCrashlytics;

  static EnvironmentConfig? _instance;

  factory EnvironmentConfig(
      {required Flavor flavor,
        required FlavorValues values,
        required bool enableCrashlytics}) {
    _instance ??=
        EnvironmentConfig._internal(flavor, values, enableCrashlytics);
    return _instance!;
  }

  EnvironmentConfig._internal(this.flavor, this.values, this.enableCrashlytics);

  static EnvironmentConfig get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.flavor == Flavor.PRODUCTION;

  static bool isDevelopment() => _instance!.flavor == Flavor.DEVELOPMENT;

  static bool isStaging() => _instance!.flavor == Flavor.STAGING;
}
