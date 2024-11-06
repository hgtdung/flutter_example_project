import 'package:flutter/material.dart';
import 'package:flutter_example_project/utils/utils.dart';

class Page1Screen extends StatefulWidget {
  const Page1Screen({super.key});

  @override
  State<Page1Screen> createState() => _Page1ScreenState();
}

class _Page1ScreenState extends State<Page1Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
            child: Column(
              children: [
                Text("Page 1 "),
                Text(Translator.instance(context).helloWorld)
              ],
            ))
      ),
    );
  }
}
