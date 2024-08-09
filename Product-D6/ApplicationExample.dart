import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

class Student{
  int id;
  String name;
  String phone;


  Student(this.id, this.name, this.phone);

  Map<String, dynamic> toJson(){
    return{
      'id':id,
      'name': name,
      'phone':phone,
    };
  }

  static Student fromJson(Map<String, dynamic> json){
    return Student(json['id'],json['name'],json['phone']);
  }

  @override
  String toString() {
    return 'ID: $id, Name: $name, Phone: $phone';
  }
}

void main() async{
  //dn thong tin file json
  const String fileName = 'Students.json';
  final String directoryPath = p.join(Directory.current.path,'data');
  final Directory directory = Directory(directoryPath);

  if(!await directory.exists()){
    await directory.create(recursive: true);     //tao file khi chua co file

  }
  final String filePath = p.join(directoryPath,fileName);
  List<Student> studentList = await loadStudents(filePath);

  while(true){
        print('''
      Menu:
      1. Them sinh vien
      2. Hien thi thong tin sinh vien
      3. Thoat
      Moi ban chon nha:
      ''');

        String? choice = stdin.readLineSync();

        switch(choice){
          case '1':
            await addStudent(filePath, studentList);
            break;
          case '2':
            displayStudent(studentList);
            break;
          case '3':
            print('thoat chuong trinh');
            exit(0);
          default:
            print('Vui long chon lai');
        }
  }
}

Future<List<Student>> loadStudents(String filePath) async{
  if(!File(filePath).existsSync()){
    await File(filePath).create();
    await File(filePath).writeAsString(jsonEncode([]));
    return [];
  }
  String content = await File(filePath).readAsString();
  List<dynamic> jsonData = jsonDecode(content);    //  jsonDecode giai ma thong tin
  return jsonData.map((json) =>Student.fromJson(json)).toList();
}

Future<void> addStudent(String filePath,List<Student> studentList) async{
  // tao dt sinh vien
  // Student student = Student(1,'Phuc', '0987654321');
  print('Nhap ten sinh vien:');
  String? name =stdin.readLineSync();
  if(name == null || name.isEmpty){
    print('ten khong hop le');
    return;
  }
  print('Nhap SDT sinh vien:');
  String? phone =stdin.readLineSync();
  if(phone == null || phone.isEmpty){
    print('SDT khong hop le');
    return;
  }

  int id = studentList.isEmpty ? 1: studentList.last.id +1;
  Student student = Student(id, name, phone);

  // them sinh vien vao list
  studentList.add(student);
  //them list vaof json file
  await saveStudents(filePath, studentList);
}

Future<void> saveStudents(String filePath,List<Student> studentList) async{
  String jsonContent = jsonEncode(studentList.map((s) => s.toJson()).toList());
  await File(filePath).writeAsString(jsonContent); // ghi vaof file json
}


void displayStudent(List<Student> studentList) {
  if(studentList.isEmpty){
    print('Danh sach sinh vien trong');
  }else{
    print('Danh sach sinh vien');
    for(var student in studentList){
      print(student);
    }
  }
}


