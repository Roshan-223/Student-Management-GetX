

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_students_details/database/db_function.dart';
import 'package:getx_students_details/model/controller.dart';
import 'package:getx_students_details/screens/home.dart';

Future<void> main() async {
  Get.put(Controller());
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDataBase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'sampleApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Myhomepage(),
    );
  }
}
 