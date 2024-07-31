// import 'dart:io';
//
//
// class Student{
//   int id;
//   String name;
//   String phoneNumber;
//
//   Student(this.id, this.name, this.phoneNumber);
//
//   @override
//   String toString() {
//     return 'ID: $id, Name: $name , Phone Number: $phoneNumber';
//   }
// }
//
//
// void main(){
//   //Ham chinh goi cac ham khac
//   List<Student> students = [];
//   while(true){
//     print('''
//     Menu:
//     1. Thêm sinh viên
//     2. Hiển thị danh sách sinh viên
//     3. Thoát
//         ''');
//     String? choice = stdin.readLineSync();
//     switch(choice){
//       case '1':addStudent(students);break;
//       case '2':displayStudent(students);
//       case '3':print('Thoát chương trình');exit(0);
//       default:print('Chọn sai. Vui lòng chọn lại.');
//     }
//   }
// }
// void addStudent(List<Student> students){
//   print('Nhập ID sinh viên: ');
//   int? id = int.tryParse(stdin.readLineSync() ?? '');
//   if(id == null){
//     print('ID không hợp lê');
//     return;
//   }
//   print('Nhập tên sinh viên');
//   String? name = stdin.readLineSync();
//   if(name ==null ||name.isEmpty){
//     print('Tên không hợp lê');
//     return;
//   }
//
//   print('Nhập số điện thoại');
//   String? phoneNumber = stdin.readLineSync();
//   if(phoneNumber == null || phoneNumber.isEmpty){
//     print('Số điện thoại không hợp lệ');
//     return;
//   }
//
//
//   students.add(Student(id, name, phoneNumber));
//   print('Sinh viên đã được thêm.');
// }
// void displayStudent(List<Student> students){
//   if(students.isEmpty){
//     print('Danh sách sinh viên trống.');
//   }else{
//     print('Danh sách sinh viên: ');
//     for(var student in students){
//       print(student);
//     }
//   }
// }