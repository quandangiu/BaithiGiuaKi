import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_2/model/User_service.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final UserService firebaseService = UserService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showUserDialog({String? userId, String? currentName}) {
    nameController.text = currentName ?? "";
    passwordController.clear(); // Không điền lại mật khẩu cũ để tăng bảo mật

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(userId == null ? "Thêm Người Dùng" : "Chỉnh Sửa Người Dùng"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Tên"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Mật khẩu"),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                String name = nameController.text;
                String password = passwordController.text;

                if (name.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
                  );
                  return;
                }

                if (userId == null) {
                  await firebaseService.addUser(name, password);
                } else {
                  await firebaseService.updateUser(userId, name, password);
                }
                Navigator.pop(context);
              },
              child: Text(userId == null ? "Thêm" : "Lưu"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh Sách Người Dùng")),
      body: StreamBuilder(
        stream: firebaseService.listenToUsers(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text("Không có người dùng nào"));
          }

          Map<dynamic, dynamic> users =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          return ListView(
            children: users.entries.map((entry) {
              String userId = entry.key;
              dynamic userData = entry.value;
              String name = userData["name"] ?? "";

              return ListTile(
                title: Text(name),
                subtitle: Text("Mật khẩu: ***"), // Ẩn mật khẩu
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showUserDialog(
                        userId: userId,
                        currentName: name,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => firebaseService.deleteUser(userId),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showUserDialog(),
      ),
    );
  }
}
