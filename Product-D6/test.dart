import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

class Student {
  int id;
  String name;
  String phone;

  Student(this.id, this.name, this.phone);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  static Student fromJson(Map<String, dynamic> json) {
    return Student(json['id'], json['name'], json['phone']);
  }

  @override
  String toString() {
    return 'ID: $id, Name: $name, Phone: $phone';
  }
}

void main() async {
  const String fileName = 'Students.json';
  final String directoryPath = p.join(Directory.current.path, 'data');
  final Directory directory = Directory(directoryPath);

  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final String filePath = p.join(directoryPath, fileName);
  List<Student> studentList = await loadStudents(filePath);

  while (true) {
    print('''
      Menu:
      1. Them sinh vien
      2. Hien thi thong tin sinh vien
      3. Sua thong tin sinh vien
      4. Xoa sinh vien
      5. Thoat
      Moi ban chon nha:
      ''');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        await addStudent(filePath, studentList);
        break;
      case '2':
        displayStudents(studentList);
        break;
      case '3':
        await editStudent(filePath, studentList);
        break;
      case '4':
        await deleteStudent(filePath, studentList);
        break;
      case '5':
        print('Thoat chuong trinh');
        exit(0);
      default:
        print('Vui long chon lai');
    }
  }
}

Future<List<Student>> loadStudents(String filePath) async {
  if (!File(filePath).existsSync()) {
    await File(filePath).create();
    await File(filePath).writeAsString(jsonEncode([]));
    return [];
  }
  String content = await File(filePath).readAsString();
  List<dynamic> jsonData = jsonDecode(content);
  return jsonData.map((json) => Student.fromJson(json)).toList();
}

Future<void> addStudent(String filePath, List<Student> studentList) async {
  print('Nhap ten sinh vien:');
  String? name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print('Ten khong hop le');
    return;
  }
  print('Nhap SDT sinh vien:');
  String? phone = stdin.readLineSync();
  if (phone == null || phone.isEmpty) {
    print('SDT khong hop le');
    return;
  }

  int id = studentList.isEmpty ? 1 : studentList.last.id + 1;
  Student student = Student(id, name, phone);
  studentList.add(student);
  await saveStudents(filePath, studentList);
}

Future<void> saveStudents(String filePath, List<Student> studentList) async {
  String jsonContent = jsonEncode(studentList.map((s) => s.toJson()).toList());
  await File(filePath).writeAsString(jsonContent);
}

void displayStudents(List<Student> studentList) {
  if (studentList.isEmpty) {
    print('Danh sach sinh vien trong');
  } else {
    print('Danh sach sinh vien');
    for (var student in studentList) {
      print(student);
    }
  }
}

Future<void> editStudent(String filePath, List<Student> studentList) async {
  print('Nhap ID sinh vien can sua:');
  String? idInput = stdin.readLineSync();
  if (idInput == null || idInput.isEmpty) {
    print('ID khong hop le');
    return;
  }

  int id = int.parse(idInput);
  Student? student = studentList.firstWhere((s) => s.id == id, orElse: () => Student(-1, '', ''));

  if (student.id == -1) {
    print('Khong tim thay sinh vien voi ID: $id');
    return;
  }

  print('Nhap ten moi (de trong neu khong thay doi):');
  String? newName = stdin.readLineSync();
  if (newName != null && newName.isNotEmpty) {
    student.name = newName;
  }

  print('Nhap SDT moi (de trong neu khong thay doi):');
  String? newPhone = stdin.readLineSync();
  if (newPhone != null && newPhone.isNotEmpty) {
    student.phone = newPhone;
  }

  await saveStudents(filePath, studentList);
  print('Cap nhat thong tin sinh vien thanh cong');
}

Future<void> deleteStudent(String filePath, List<Student> studentList) async {
  print('Nhap ID sinh vien can xoa:');
  String? idInput = stdin.readLineSync();
  if (idInput == null || idInput.isEmpty) {
    print('ID khong hop le');
    return;
  }

  int id = int.parse(idInput);
  studentList.removeWhere((s) => s.id == id);
  await saveStudents(filePath, studentList);
  print('Xoa sinh vien thanh cong');
}
