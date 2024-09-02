import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_students_details/database/db_function.dart';
import 'package:getx_students_details/model/controller.dart';
import 'package:getx_students_details/model/student.dart';
import 'package:image_picker/image_picker.dart';

final Controller controller = Get.find<Controller>();

class Addstudent extends StatefulWidget {
  const Addstudent({super.key, this.model});
  final StudentModel? model;

  @override
  State<Addstudent> createState() => _AddstudentState();
}

class _AddstudentState extends State<Addstudent> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    showData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Add Student',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Obx(() {
                return CircleAvatar(
                  backgroundColor: Colors.black,
                  maxRadius: 70,
                  child: GestureDetector(
                    onTap: () async {
                      File? pickedImage = await pickImageFomCamera();
                      if (pickedImage != null) {
                        controller.updateSelectedImage(pickedImage);
                      }
                    },
                    child: controller.selectedImage.value != null
                        ? ClipOval(
                            child: Image.file(
                              controller.selectedImage.value!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                              // color: Colors.black87,
                            ),
                          )
                        : const Icon(
                            Icons.add_a_photo_rounded,
                            // color: Colors.black87,
                          ),
                  ),
                );
              }),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Colors.black45),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'name is empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Age',
                        hintStyle: const TextStyle(color: Colors.black45),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'age is empty';
                        } else if (value.length > 2) {
                          return 'Enter correct age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.placeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Place',
                        hintStyle: const TextStyle(color: Colors.black45),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'place is empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.mobilenumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Mobile number',
                        hintStyle: const TextStyle(color: Colors.black45),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'mobile number is empty';
                        } else if (value.length > 10) {
                          return 'invalid number';
                        } else if (value.length < 10) {
                          return 'invalid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          onAddStudentButtonClicked(context);
                          // Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: const Text('Add Students'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onAddStudentButtonClicked(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      final student = StudentModel(
        name: controller.nameController.text,
        age: controller.ageController.text,
        place: controller.placeController.text,
        mobile: controller.mobilenumberController.text,
        imageurl: controller.selectedImage.value?.path,
      );
      if (widget.model == null) {
        await addStudent(student);
      } else {
        student.id = widget.model!.id;
        await updateStudent(student);
      }
      controller.nameController.clear();
      controller.ageController.clear();
      controller.placeController.clear();
      controller.mobilenumberController.clear();
      controller.selectedImage.value = null;

      Get.back();

      Get.snackbar('SUCCESS', "Student added successfully",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          snackStyle: SnackStyle.FLOATING);
    }
  }

  Future<File?> pickImageFomCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  void showData() {
    if (widget.model != null) {
      controller.nameController.text = widget.model!.name!;
      controller.ageController.text = widget.model!.age!;
      controller.placeController.text = widget.model!.place!;
      controller.mobilenumberController.text = widget.model!.mobile!;
      if (widget.model!.imageurl != null) {
        controller.selectedImage.value = File(widget.model!.imageurl!);
      }
    }
  }
}
