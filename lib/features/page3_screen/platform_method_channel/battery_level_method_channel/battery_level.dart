import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryLevel extends StatefulWidget {
  const BatteryLevel({super.key});

  @override
  State<BatteryLevel> createState() => _BatteryLevelState();
}

class _BatteryLevelState extends State<BatteryLevel> {
  static const platform = MethodChannel("BATTERY_CHANNEL");
  String _batteryLevel = 'Unknown battery level.';
  String _batteryLevelJSON = 'Unknown battery level.';
  static const platformJson = MethodChannel("BATTERY_CHANNEL_JSON", JSONMethodCodec());

  @override
  void initState() {
    _getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            Text(_batteryLevel),
            Text(_batteryLevelJSON)
          ],
        ),
      ),
    );
  }


  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    String batteryLevelJson;
    try {
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level at $result';
    } on PlatformException catch (e){
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    try {
      final resultJSON = await platformJson.invokeMethod('getBatteryLevel');
      batteryLevelJson = 'Battery level at ${resultJSON["batteryLevel"]}';
    } on PlatformException catch (e){
      batteryLevelJson = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
      _batteryLevelJSON = batteryLevelJson;
    });
  }
}
