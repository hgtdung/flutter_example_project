import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_example_project/di/service_locator.dart';
import 'package:flutter_example_project/features/page1_screen/page1_vm.dart';
import 'package:flutter_example_project/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';


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
                        ElevatedButton(onPressed: () {
                          initSqlite3();
                        },
                        child: Text("Test Sqlite3"))
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

  void initSqlite3() {
    print('Using sqlite3 ${sqlite3.version}');

    // Create a new in-memory database. To use a database backed by a file, you
    // can replace this with sqlite3.open(yourFilePath).
    final db = sqlite3.openInMemory();

    // Create a table and insert some data
    db.execute('''
    CREATE TABLE artists (
      id INTEGER NOT NULL PRIMARY KEY,
      name TEXT NOT NULL
    );
  ''');

    // Prepare a statement to run it multiple times:
    final stmt = db.prepare('INSERT INTO artists (name) VALUES (?)');
    stmt
      ..execute(['The Beatles'])
      ..execute(['Led Zeppelin'])
      ..execute(['The Who'])
      ..execute(['Nirvana']);

    // Dispose a statement when you don't need it anymore to clean up resources.
    stmt.dispose();

    // You can run select statements with PreparedStatement.select, or directly
    // on the database:
    final ResultSet resultSet =
    db.select('SELECT * FROM artists WHERE name LIKE ?', ['The %']);

    // You can iterate on the result set in multiple ways to retrieve Row objects
    // one by one.
    for (final  row in resultSet) {
      print('Artist[id: ${row['id']}, name: ${row['name']}]');
    }

    // Register a custom function we can invoke from sql:
    db.createFunction(
      functionName: 'dart_version',
      argumentCount: const AllowedArgumentCount(0),
      function: (args) => Platform.version,
    );
    print(db.select('SELECT dart_version()'));

    // Don't forget to dispose the database to avoid memory leaks
    db.dispose();
  }
}
