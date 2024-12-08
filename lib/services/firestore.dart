import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  Future<void> addUser(String name, String email) async {
    try {
      // Lấy uid của người dùng sau khi đăng ký
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Lấy đối tượng Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Tạo dữ liệu người dùng
        Map<String, dynamic> userData = {
          'name': name,
          'email': email,
          'created_at': FieldValue.serverTimestamp(), // Thời gian tạo tài khoản
          // Thêm bất kỳ trường nào bạn muốn
        };

        // Thêm người dùng vào collection 'users'
        await firestore.collection('users').doc(user.uid).set(userData);

        print("User added successfully to Firestore!");
      } else {
        print("No user is logged in.");
      }
    } catch (e) {
      print("Error adding user: $e");
    }
  }
}
