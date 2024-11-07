import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class EventChannelDemo extends StatefulWidget {
  const EventChannelDemo({super.key});

  @override
  State<EventChannelDemo> createState() => _EventChannelDemoState();
}

class _EventChannelDemoState extends State<EventChannelDemo> {
  static const stream = EventChannel("stream");
  String data = "Unknown data";

  @override
  void initState() {
    stream.receiveBroadcastStream().listen((data){
      setState(() {
        this.data = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(data));
  }
}
