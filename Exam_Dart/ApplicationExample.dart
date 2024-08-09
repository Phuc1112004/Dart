import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;


class Subject {
  String name;
  List<int> scores;

  Subject(this.name, this.scores);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'scores': scores,
    };
  }

  static Subject fromJson(Map<String, dynamic> json) {
    List<int> scores = List<int>.from(json['scores']);
    return Subject(json['name'], scores);
  }

  @override
  String toString() {
    return 'Mon hoc: $name, Diem: ${scores.join(", ")}';
  }
}


class Student {
  int id;
  String name;
  String phone;
  List<Subject> subjects;

  Student(this.id, this.name, this.phone, this.subjects);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }

  static Student fromJson(Map<String, dynamic> json) {
    List<Subject> subjects = (json['subjects'] as List)
        .map((subjectJson) => Subject.fromJson(subjectJson))
        .toList();
    return Student(json['id'], json['name'], json['phone'], subjects);
  }

  @override
  String toString() {
    return 'ID: $id, Name: $name, Phone: $phone, Subjects: $subjects';
  }
}



void main() async {
  const String fileName = 'TestStudent.json';
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
    5. Hien thi sinh vien co diem thi mon cao nhat
    6. Tim sinh vien theo ID, Ten hoac sdt 
    7. Thoat
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
        displayTopStudent(studentList);
        break;
      case '6':
        searchStudent(studentList);
        break;
      case '7':
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

  List<Subject> subjects = [];
  while (true) {
    print('Nhap ten mon hoc (hoac de trong de ket thuc):');
    String? subjectName = stdin.readLineSync();
    if (subjectName == null || subjectName.isEmpty) break;

    print('Nhap diem thi (cach nhau boi dau phay):');
    String? scoresInput = stdin.readLineSync();
    List<int> scores = scoresInput?.split(',').map(int.parse).toList() ?? [];

    subjects.add(Subject(subjectName, scores));
  }

  int id = studentList.isEmpty ? 1 : studentList.last.id + 1;
  Student student = Student(id, name, phone, subjects);
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
  Student? student = studentList.firstWhere((s) => s.id == id, orElse: () => Student(-1, '', '', []));

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

  print('Co muon sua thong tin mon hoc khong? (y/n):');
  String? editSubjectsChoice = stdin.readLineSync();
  if (editSubjectsChoice != null && editSubjectsChoice.toLowerCase() == 'y') {
    List<Subject> subjects = [];
    while (true) {
      print('Nhap ten mon hoc (hoac de trong de ket thuc):');
      String? subjectName = stdin.readLineSync();
      if (subjectName == null || subjectName.isEmpty) break;

      print('Nhap diem thi (cach nhau boi dau phay):');
      String? scoresInput = stdin.readLineSync();
      List<int> scores = scoresInput?.split(',').map(int.parse).toList() ?? [];

      subjects.add(Subject(subjectName, scores));
    }
    student.subjects = subjects;
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


void displayTopStudent(List<Student> studentList) {
  print('Nhap ten mon hoc de tim sinh vien co diem cao nhat:');
  String? subjectName = stdin.readLineSync();
  if (subjectName == null || subjectName.isEmpty) {
    print('Ten mon hoc khong hop le');
    return;
  }

  Student? topStudent;
  int highestScore = -1;

  for (var student in studentList) {
    for (var subject in student.subjects) {
      if (subject.name.toLowerCase() == subjectName.toLowerCase()) {
        for (var score in subject.scores) {
          if (score > highestScore) {
            highestScore = score;
            topStudent = student;
          }
        }
      }
    }
  }

  if (topStudent != null) {
    print('Sinh vien co diem cao nhat mon $subjectName:');
    print(topStudent);
    print('Diem: $highestScore');
  } else {
    print('Khong tim thay sinh vien voi diem cao trong mon $subjectName.');
  }
}

void searchStudent(List<Student> studentList) {
  print('Nhap ID hoac Ten hoac Sdt sinh vien can tim:');
  String? query = stdin.readLineSync();
  if (query == null || query.isEmpty) {
    print('Gia tri tim kiem khong hop le');
    return;
  }

  Student? foundStudent;

  // Tìm kiếm sinh viên theo ID trước
  if (int.tryParse(query) != null) {
    int id = int.parse(query);
    foundStudent = studentList.firstWhere((s) => s.id == id, orElse: () => Student(-1, '', '', []));
  }

  // Nếu không tìm thấy theo ID, thử tìm theo tên
  if (foundStudent == null || foundStudent.id == -1) {
    foundStudent = studentList.firstWhere(
            (s) => s.name.toLowerCase() == query.toLowerCase(),
        orElse: () => Student(-1, '', '', []));
  }

  // Nếu không tìm thấy theo tên, thử tìm theo sđt
  if (foundStudent == null || foundStudent.id == -1) {
    foundStudent = studentList.firstWhere(
            (s) => s.phone.toLowerCase() == query.toLowerCase(),
        orElse: () => Student(-1, '', '', []));
  }

  if (foundStudent.id != -1) {
    print('Da tim thay sinh vien:');
    print(foundStudent);
  } else {
    print('Khong tim thay sinh vien voi Id, Ten hoac Sdt: $query');
  }
}


