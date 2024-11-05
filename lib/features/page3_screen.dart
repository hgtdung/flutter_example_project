import 'package:flutter/material.dart';

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
        child: Text("Page 3"),
      ),
    );
  }
}
