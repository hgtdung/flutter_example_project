import 'package:flutter/material.dart';
import 'package:flutter_example_project/di/service_locator.dart';
import 'package:flutter_example_project/features/page1_screen/page1_vm.dart';
import 'package:flutter_example_project/utils/utils.dart';
import 'package:provider/provider.dart';

class Page1Screen extends StatefulWidget {
  const Page1Screen({super.key});

  @override
  State<Page1Screen> createState() => _Page1ScreenState();
}

class _Page1ScreenState extends State<Page1Screen> {
  final page1ScreenVM = serviceLocator<Page1VM>();

  @override
  void initState() {
    // page1ScreenVM.changeText(2000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider.value(
      value: page1ScreenVM,
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: 200,
              child: Column(
                children: [
                  Text("Page 1 "),
                  Text(Translator.instance(context).helloWorld),
                  Consumer<Page1VM>(builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        Text(viewModel.randomText),
                      ],
                    );
                  }, child: Text("Child of consumer"),)
                ],
              ))
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    page1ScreenVM.dispose();
    super.dispose();
  }
}
