import 'package:get/get.dart';
import 'package:getx_students_details/model/student.dart';
import 'package:sqflite/sqflite.dart';

// ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);
final studentList = [].obs;

late Database _db;

Future<void> initializeDataBase() async {
  _db = await openDatabase(
    'student.db',
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT, age TEXT, place TEXT, mobile TEXT,image TEXT)');
    },
  );
  await getAllStudent();
}

Future<void> addStudent(StudentModel value) async {
  // print(value.toString());
  String image = value.imageurl ?? '';
  await _db.rawInsert(
      'INSERT INTO student(name,age,place,mobile,image) VALUES(?, ?, ?, ?, ?)',
      [value.name, value.age, value.place, value.mobile, image]);
  // StudentListNotifier.notifyListeners();
  await getAllStudent();
}

Future<void> getAllStudent() async {
  final values = await _db.rawQuery('SELECT * FROM student');
  studentList.clear();
  for (var map in values) {
    final user = StudentModel.fromMap(map);
    studentList.add(user);
  }
  // print(StudentListNotifier.value.length);

  // studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int id) async {
  await _db.rawDelete('DELETE FROM student WHERE id = ?', [id]);
  // StudentListNotifier.notifyListeners();
  await getAllStudent();
}

Future<void> updateStudent(StudentModel value) async {
  await _db.rawUpdate(
      'UPDATE student SET name = ?, age = ?, place = ?, mobile = ?, image = ? WHERE id = ?',
      [
        value.name,
        value.age,
        value.place,
        value.mobile,
        value.imageurl,
        value.id
      ]);
  // StudentListNotifier.notifyListeners();
  await getAllStudent();
}

// Future<String>fetchdata(){
//   return Future.delayed(Duration(seconds: 2),){

//   });
// }