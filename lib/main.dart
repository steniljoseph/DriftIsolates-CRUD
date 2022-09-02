import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_crud/database/studentdb.dart';
import 'package:flutter/material.dart';
import 'package:drift_crud/views/student_list.dart';
import 'package:get/get.dart';
import 'package:drift/isolate.dart';

late MyDatabase myDatabase;

DatabaseConnection _backgroundConnection() {
  // Construct the database to use. This example uses a non-persistent in-memory
  // database each time. You can use your existing NativeDatabase with a file as
  // well, or a `LazyDatabase` if you need to construct it asynchronously. When
  // using a Flutter plugin like `path_provider` to determine the path, also see
  // the "Initialization on the main thread" section below!

  final database = NativeDatabase.memory();
  return DatabaseConnection(database);
}

void main() async {
  final isolate = await DriftIsolate.spawn(_backgroundConnection);

  final connection = await isolate.connect();

  final db = MyDatabase.connect(connection);

  myDatabase = db;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drift',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
