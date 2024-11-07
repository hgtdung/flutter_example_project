import 'package:flutter/material.dart';

import 'platform_method_channel/battery_level_method_channel/battery_level.dart';
import 'platform_method_channel/device_info_basic_message/device_info_basic_message.dart';
import 'platform_method_channel/event_channel/event_channel_demo.dart';

class Page3Screen extends StatefulWidget {
  const Page3Screen({super.key});

  @override
  State<Page3Screen> createState() => _Page3ScreenState();
}

class _Page3ScreenState extends State<Page3Screen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: BatteryLevel()
      ),
    );
  }
}
