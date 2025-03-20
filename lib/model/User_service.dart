import 'package:firebase_database/firebase_database.dart';

class UserService {
  // Tham chiếu đến nút "users" trong Firebase Realtime Database
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref("users");

  // Các phương thức liên quan đến người dùng

  // Thêm người dùng mới vào Firebase
  Future<void> addUser(String name, String password) async {
    // Tạo một ID mới cho người dùng
    String newUserId = _usersRef.push().key!;
    // Lưu thông tin người dùng vào database
    await _usersRef.child(newUserId).set({
      "name": name, // Tên người dùng
      "password": password, // Mật khẩu người dùng
    });
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(
      String userId, String newName, String newPassword) async {
    await _usersRef.child(userId).set({
      "name": newName, // Tên mới
      "password": newPassword, // Mật khẩu mới
    });
  }

  // Xóa người dùng khỏi Firebase
  Future<void> deleteUser(String userId) async {
    await _usersRef.child(userId).remove();
  }

  // Lắng nghe sự thay đổi dữ liệu của danh sách người dùng
  Stream<DatabaseEvent> listenToUsers() {
    return _usersRef.onValue;
  }

  // Phương thức kiểm tra đăng nhập của người dùng
  Future<bool> checkUserLogin(String username, String password) async {
    // Truy vấn người dùng có tên giống với `username`
    final snapshot =
        await _usersRef.orderByChild("name").equalTo(username).once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    // Kiểm tra nếu có dữ liệu hợp lệ
    if (data != null) {
      for (var userId in data.keys) {
        final userData = data[userId] as Map<dynamic, dynamic>;
        if (userData["password"] == password) {
          return true; // Đăng nhập thành công
        }
      }
    }
    return false; // Đăng nhập thất bại
  }
}
