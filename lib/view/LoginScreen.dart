import 'package:flutter/material.dart';
import 'package:project_2/model/User_service.dart';
import 'package:project_2/view/MainScreen.dart';
import 'package:project_2/view/ProductsListScreen.dart';
import '../main.dart'; // Import MainScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserService firebaseService =
      UserService(); // Khởi tạo dịch vụ Firebase
  final TextEditingController usernameController =
      TextEditingController(); // Bộ điều khiển nhập liệu cho tên đăng nhập
  final TextEditingController passwordController =
      TextEditingController(); // Bộ điều khiển nhập liệu cho mật khẩu
  bool _isLoading = false; // Biến kiểm soát trạng thái tải khi đăng nhập

  // Hàm xử lý đăng nhập
  void _login() async {
    setState(() {
      _isLoading = true; // Hiển thị trạng thái đang tải
    });

    String username = usernameController.text
        .trim(); // Lấy tên đăng nhập và loại bỏ khoảng trắng
    String password =
        passwordController.text.trim(); // Lấy mật khẩu và loại bỏ khoảng trắng

    // Kiểm tra nếu người dùng đã nhập đầy đủ thông tin
    if (username.isNotEmpty && password.isNotEmpty) {
      bool isValid = await firebaseService.checkUserLogin(
          username, password); // Kiểm tra thông tin đăng nhập với Firebase

      if (isValid) {
        // Nếu thông tin hợp lệ, chuyển sang màn hình danh sách sản phẩm
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductsListScreen()),
        );
      } else {
        // Hiển thị thông báo lỗi nếu đăng nhập thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tên đăng nhập hoặc mật khẩu không đúng")),
        );
      }
    } else {
      // Hiển thị thông báo nếu chưa nhập đầy đủ thông tin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
    }

    setState(() {
      _isLoading = false; // Tắt trạng thái đang tải
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng Nhập")), // Thanh tiêu đề
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ô nhập tên đăng nhập
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Tên đăng nhập"),
            ),
            // Ô nhập mật khẩu
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Mật khẩu"),
              obscureText: true, // Ẩn mật khẩu khi nhập
            ),
            SizedBox(height: 20), // Khoảng cách giữa các phần tử

            // Nút đăng nhập hoặc vòng quay tải khi đang xử lý
            _isLoading
                ? CircularProgressIndicator() // Hiển thị vòng quay tải nếu đang đăng nhập
                : ElevatedButton(
                    onPressed: _login, // Gọi hàm _login khi nhấn nút
                    child: Text("Đăng Nhập"),
                  ),
          ],
        ),
      ),
    );
  }
}
