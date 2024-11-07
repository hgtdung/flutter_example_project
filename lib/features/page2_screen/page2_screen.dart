import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_example_project/data/models/user.dart';
import 'package:flutter_example_project/di/service_locator.dart';
import 'package:flutter_example_project/features/page2_screen/bloc/page2_bloc.dart';
import 'package:flutter_example_project/features/page2_screen/bloc/page2_event.dart';
import 'package:flutter_example_project/features/page2_screen/bloc/page2_state.dart';

class Page2Screen extends StatefulWidget {
  const Page2Screen({super.key});

  @override
  State<Page2Screen> createState() => _Page2ScreenState();
}

class _Page2ScreenState extends State<Page2Screen> {
  final _page2Bloc = serviceLocator<Page2Bloc>();
  @override
  void initState() {
    _page2Bloc.add(Page2LoadDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [BlocProvider.value(value: _page2Bloc)],
        child: BlocConsumer<Page2Bloc, Page2State>(
            builder: (context, state) {
              switch(state) {
                case Page2StateDataState(data: User user):
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width,),
                      Text("Name: ${user.name}"),
                      Text("Gender: ${user.gender}"),
                      Text("Age: ${user.age}"),
                      const SizedBox(height: 15,),
                      ElevatedButton(onPressed: () {
                        _page2Bloc.add(Page2IncreaseAgeEvent());
                      }, child: const Text("Increase age"))
                    ],);
                default:
                  return const Text("Error State");
              }
            },
            listener: (context, state) {}),
      ),
    );
  }

  @override
  void dispose() {
    _page2Bloc.close();
    super.dispose();
  }
}
