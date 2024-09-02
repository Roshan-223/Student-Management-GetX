import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_students_details/model/student.dart';

class Controller extends GetxController {
  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final placeController = TextEditingController();

  final mobilenumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final studentList = [].obs;

  var query = ''.obs;
  StudentModel? model;
  var selectedImage = Rx<File?>(null);

  void updateQuery(String value) {
    query.value = value;
  }

  void updateSelectedImage(File imagefile) {
    selectedImage.value = imagefile;
  }
}
