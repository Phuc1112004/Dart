import 'dart:io';

class Student {
  int id;
  String name;
  String phoneNumber;

  Student(this.id, this.name, this.phoneNumber);

  @override
  String toString() {
    return 'ID: $id, Name: $name , Phone Number: $phoneNumber';
  }
}

void main() {
  List<Student> students = [];
  while (true) {
    print('''
    Menu:
    1. Thêm sinh viên 
    2. Hiển thị danh sách sinh viên
    3. Tìm sinh viên theo ID
    4. Tìm sinh viên theo tên
    5. Tìm sinh viên theo số điện thoại
    6. Sửa thông tin sinh viên
    7. Xóa sinh viên
    8. Thoát 
    ''');
    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        addStudent(students);
        break;
      case '2':
        displayStudents(students);
        break;
      case '3':
        findStudentById(students);
        break;
      case '4':
        findStudentByName(students);
        break;
      case '5':
        findStudentByPhoneNumber(students);
        break;
      case '6':
        updateStudent(students);
        break;
      case '7':
        deleteStudent(students);
        break;
      case '8':
        print('Thoát chương trình');
        exit(0);
      default:
        print('Chọn sai. Vui lòng chọn lại.');
    }
  }
}

void addStudent(List<Student> students) {
  print('Nhập ID sinh viên: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không hợp lệ');
    return;
  }
  print('Nhập tên sinh viên: ');
  String? name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print('Tên không hợp lệ');
    return;
  }
  print('Nhập số điện thoại: ');
  String? phoneNumber = stdin.readLineSync();
  if (phoneNumber == null || phoneNumber.isEmpty) {
    print('Số điện thoại không hợp lệ');
    return;
  }

  students.add(Student(id, name, phoneNumber));
  print('Sinh viên đã được thêm.');
}

void displayStudents(List<Student> students) {
  if (students.isEmpty) {
    print('Danh sách sinh viên trống.');
  } else {
    print('Danh sách sinh viên: ');
    for (var student in students) {
      print(student);
    }
  }
}

void findStudentById(List<Student> students) {
  print('Nhập ID sinh viên cần tìm: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không hợp lệ');
    return;
  }
  var student = students.firstWhere((student) => student.id == id, orElse: () => Student(0, '', ''));
  if (student.id == 0) {
    print('Không tìm thấy sinh viên với ID: $id');
  } else {
    print('Thông tin sinh viên: $student');
  }
}

void findStudentByName(List<Student> students) {
  print('Nhập tên sinh viên cần tìm: ');
  String? name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print('Tên không hợp lệ');
    return;
  }

  // toLowerCase() được sử dụng để chuyển đổi cả tên sinh viên và chuỗi nhập vào thành chữ thường trước khi so sánh
  var foundStudents = students.where((student) => student.name.toLowerCase().contains(name.toLowerCase())).toList();
  if (foundStudents.isEmpty) {
    print('Không tìm thấy sinh viên với tên: $name');
  } else {
    print('Danh sách sinh viên tìm thấy: ');
    for (var student in foundStudents) {
      print(student);
    }
  }
}

void findStudentByPhoneNumber(List<Student> students) {
  print('Nhập số điện thoại cần tìm: ');
  String? phoneNumber = stdin.readLineSync();
  if (phoneNumber == null || phoneNumber.isEmpty) {
    print('Số điện thoại không hợp lệ');
    return;
  }
  // contains(phoneNumber) kiểm tra xem số điện thoại của sinh viên có chứa chuỗi số điện thoại nhập vào hay không.
  // Kết quả lọc được chuyển đổi thành danh sách (toList()).
  var foundStudents = students.where((student) => student.phoneNumber.contains(phoneNumber)).toList();
  if (foundStudents.isEmpty) {
    print('Không tìm thấy sinh viên với số điện thoại: $phoneNumber');
  } else {
    print('Danh sách sinh viên tìm thấy: ');
    for (var student in foundStudents) {
      print(student);
    }
  }
}

void updateStudent(List<Student> students) {
  print('Nhập ID sinh viên cần sửa: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không hợp lệ');
    return;
  }

  // Nếu không tìm thấy sinh viên nào,
  // phương thức orElse sẽ tạo ra một đối tượng Student mới với các thuộc tính mặc định (ID = 0, tên rỗng, số điện thoại rỗng).
  var student = students.firstWhere((student) => student.id == id, orElse: () => Student(0, '', ''));
  if (student.id == 0) {
    print('Không tìm thấy sinh viên với ID: $id');
    return;
  }
  print('Nhập tên mới cho sinh viên (nhấn Enter để giữ nguyên): ');
  String? name = stdin.readLineSync();
  if (name != null && name.isNotEmpty) {
    student.name = name;
  }
  print('Nhập số điện thoại mới cho sinh viên (nhấn Enter để giữ nguyên): ');
  String? phoneNumber = stdin.readLineSync();
  if (phoneNumber != null && phoneNumber.isNotEmpty) {
    student.phoneNumber = phoneNumber;
  }
  print('Thông tin sinh viên đã được cập nhật: $student');
}

void deleteStudent(List<Student> students) {
  print('Nhập ID sinh viên cần xóa: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('ID không hợp lệ');
    return;
  }
  var student = students.firstWhere((student) => student.id == id, orElse: () => Student(0, '', ''));
  if (student.id == 0) {
    print('Không tìm thấy sinh viên với ID: $id');
    return;
  }
  students.remove(student);
  print('Sinh viên đã được xóa.');
}
