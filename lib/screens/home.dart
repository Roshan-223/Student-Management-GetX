import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_students_details/database/db_function.dart';
import 'package:getx_students_details/model/controller.dart';
import 'package:getx_students_details/model/student.dart';
import 'package:getx_students_details/screens/add_students.dart';

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  @override
  Widget build(BuildContext context) {
    final Controller controller = Get.find<Controller>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                'Students Profile',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    controller.updateQuery(value);
                  },
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.only(bottom: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: Obx(() {
        final list = studentList
            .where((student) => student.name!
                .toLowerCase()
                .contains(controller.query.value.toLowerCase()))
            .toList();

        if (studentList.isEmpty) {
          return const Center(
            child: Text(
              'Add students',
              style: TextStyle(fontSize: 18),
            ),
          );
        } else if (list.isEmpty && controller.query.value.isNotEmpty) {
          return const Center(
            child: Text(
              'Student not found',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.separated(
          itemBuilder: (ctx, index) {
            final student = list[index];
            return ListTile(
              leading: GestureDetector(
                onTap: () => Get.dialog(
                  ImageDialog(
                    student: student,
                  ),
                ),
                child: student.imageurl != null
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: FileImage(File(student.imageurl!)),
                      )
                    : const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                      ),
              ),
              title: Text(student.name!),
              subtitle: Text(student.place!),
              trailing: Wrap(
                children: [
                  IconButton(
                    onPressed: () async {
                      await Get.dialog(
                        AlertDialog(
                          content:
                              const Text('Are you sure you want to delete?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                deleteStudent(student.id!);
                                Get.back();
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('No'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(() => Addstudent(model: student));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: list.length,
        );
      })),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 30,
        child: IconButton(
          onPressed: () {
            Get.to(() => const Addstudent());
          },
          icon: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final StudentModel student;

  const ImageDialog({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 500,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(File(student.imageurl!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Name: ${student.name}',
                  style: const TextStyle(fontSize: 20)),
              Text('Age: ${student.age}', style: const TextStyle(fontSize: 20)),
              Text('Place: ${student.place}',
                  style: const TextStyle(fontSize: 20)),
              Text('Contact: ${student.mobile}',
                  style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
