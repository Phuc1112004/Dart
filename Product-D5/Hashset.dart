import 'dart:collection';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:collection/collection.dart';

class Student {
  int id;
  String name;
  String phone;

  Student(this.id, this.name, this.phone);

  @override
  String toString() {
    return 'ID: $id, Name: $name, Phone: $phone';
  }

  // so sánh xem student có trùng SDT ko
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Student &&
              runtimeType == other.runtimeType &&
              phone == other.phone;

  @override
  int get hashCode => phone.hashCode;
}

void main() async {
  final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    // password: '',
    db: 'school',
  );

  final conn = await MySqlConnection.connect(settings);
  HashSet<Student> students = HashSet<Student>();

  while (true) {
    print('''
    Menu:
    1. Them sinh vien
    2. Sua sinh vien
    3. Xoa sinh vien
    4. Hien thi danh sach sinh vien
    5. Thoat
    Lua chon cua ban:
    ''');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        await addStudent(conn, students);
        break;
      case '2':
        await updateStudent(conn, students);
        break;
      case '3':
        await deleteStudent(conn, students);
        break;
      case '4':
        await displayStudents(conn, students);
        break;
      case '5':
        await conn.close();
        print('Thoat chuong trinh');
        exit(0);
      default:
        print('Ban chon sai. Vui long chon lai');
    }
  }
}

Future<void> addStudent(MySqlConnection conn, HashSet<Student> students) async {
  print('Nhap ten sinh vien:');
  String? name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print('Ten khong dung dinh dang');
    return;
  }

  print('Nhap so dt:');
  String? phone = stdin.readLineSync();
  if (phone == null || phone.isEmpty) {
    print('SDT khong dung dinh dang');
    return;
  }

  // Kiểm tra xem số điện thoại đã tồn tại trong HashSet hay chưa
  if (students.any((student) => student.phone == phone)) {
    print('SDT da ton tai');
    return;
  }

  var result = await conn.query('INSERT INTO student (name, phone) VALUES (?, ?)', [name, phone]);
  var id = result.insertId;
  if (id != null) {
    students.add(Student(id, name, phone));
    print('Sinh vien da duoc them');
  } else {
    print('Them sinh vien loi!!!');
  }
}

Future<void> displayStudents(MySqlConnection conn, HashSet<Student> students) async {
  var results = await conn.query('SELECT id, name, phone FROM student');

  students.clear();

  for (var row in results) {
    students.add(Student(row['id'], row['name'], row['phone']));
  }

  if (students.isEmpty) {
    print('Danh sach sinh vien trong');
  } else {
    print('Danh sach sinh vien la:');
    for (var student in students) {
      print(student);
    }
  }
}

Future<void> deleteStudent(MySqlConnection conn, HashSet<Student> students) async {
  print('Nhap ID cua sinh vien can xoa:');
  String? idStr = stdin.readLineSync();
  int? id = int.tryParse(idStr ?? '');

  if (id == null) {
    print('ID khong dung dinh dang');
    return;
  }

  var result = await conn.query('DELETE FROM student WHERE id = ?', [id]);
  if (result.affectedRows! > 0) {
    students.removeWhere((student) => student.id == id);
    print('Sinh vien da duoc xoa');
  } else {
    print('Xoa sinh vien loi!!!');
  }
}

Future<void> updateStudent(MySqlConnection conn, HashSet<Student> students) async {
  print('Nhap ID cua sinh vien can sua:');
  String? idStr = stdin.readLineSync();
  int? id = int.tryParse(idStr ?? '');

  if (id == null) {
    print('ID khong dung dinh dang');
    return;
  }

  Student? student = students.firstWhereOrNull((s) => s.id == id);
  if (student == null) {
    print('Sinh vien khong ton tai');
    return;
  }

  print('Nhap ten moi cua sinh vien (bo trong neu khong thay doi):');
  String? name = stdin.readLineSync();
  if (name != null && name.isNotEmpty) {
    student.name = name;
  }

  print('Nhap so dt moi cua sinh vien (bo trong neu khong thay doi):');
  String? phone = stdin.readLineSync();
  if (phone != null && phone.isNotEmpty) {
    student.phone = phone;
  }

  var result = await conn.query('UPDATE student SET name = ?, phone = ? WHERE id = ?', [student.name, student.phone, student.id]);
  if (result.affectedRows! > 0) {
    print('Sinh vien da duoc sua');
  } else {
    print('Sua sinh vien loi!!!');
  }
}
