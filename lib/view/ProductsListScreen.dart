import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_2/model/Product_service.dart';

class ProductsListScreen extends StatefulWidget {
  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  // Khởi tạo dịch vụ Firebase
  final ProductService firebaseService = ProductService();
  // Bộ điều khiển nhập ID sản phẩm
  final TextEditingController idSanPhamController = TextEditingController();
  // Bộ điều khiển nhập loại sản phẩm
  final TextEditingController loaiSpController = TextEditingController();
  // Bộ điều khiển nhập giá sản phẩm
  final TextEditingController giaController = TextEditingController();

  // Hiển thị hộp thoại thêm/chỉnh sửa sản phẩm
  void _showProductDialog(
      {String? productId, String? idSanPham, String? loaiSp, String? gia}) {
    idSanPhamController.text =
        idSanPham ?? ""; // Gán giá trị ID sản phẩm nếu có
    loaiSpController.text = loaiSp ?? ""; // Gán giá trị loại sản phẩm nếu có
    giaController.text = gia ?? ""; // Gán giá trị giá sản phẩm nếu có
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(productId == null ? "Thêm Sản Phẩm" : "Chỉnh Sửa Sản Phẩm"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idSanPhamController,
                decoration: InputDecoration(labelText: "ID Sản Phẩm"),
              ),
              TextField(
                controller: loaiSpController,
                decoration: InputDecoration(labelText: "Loại Sản Phẩm"),
              ),
              TextField(
                controller: giaController,
                decoration: InputDecoration(labelText: "Giá"),
                keyboardType: TextInputType.number, // Chỉ cho phép nhập số
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng hộp thoại
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                String idSanPham = idSanPhamController.text;
                String loaiSp = loaiSpController.text;
                double gia = double.tryParse(giaController.text) ?? 0.0;
                if (productId == null) {
                  // Nếu không có productId -> Thêm sản phẩm mới
                  await firebaseService.addProduct(idSanPham, loaiSp, gia);
                } else {
                  // Nếu có productId -> Chỉnh sửa sản phẩm
                  await firebaseService.updateProduct(
                      productId, idSanPham, loaiSp, gia);
                }
                Navigator.pop(context); // Đóng hộp thoại sau khi hoàn tất
              },
              child: Text(productId == null ? "Thêm" : "Lưu"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh Sách Sản Phẩm")), // Thanh tiêu đề
      body: StreamBuilder(
        stream: firebaseService
            .listenToProducts(), // Lắng nghe dữ liệu sản phẩm từ Firebase
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
                child: Text(
                    "Không có sản phẩm nào")); // Hiển thị nếu danh sách trống
          }

          Map<dynamic, dynamic> products =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          return ListView(
            children: products.entries.map((entry) {
              String productId = entry.key;
              dynamic productData = entry.value;
              String idSanPham = productData["idsanpham"] ?? "";
              String loaiSp = productData["loaisp"] ?? "";
              String gia = productData["gia"]?.toString() ?? "";

              return ListTile(
                title: Text(
                    "$idSanPham - $loaiSp ($gia VNĐ)"), // Hiển thị thông tin sản phẩm
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.edit, color: Colors.blue), // Nút chỉnh sửa
                      onPressed: () => _showProductDialog(
                        productId: productId,
                        idSanPham: idSanPham,
                        loaiSp: loaiSp,
                        gia: gia,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red), // Nút xóa
                      onPressed: () => firebaseService.deleteProduct(productId),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), // Nút thêm sản phẩm mới
        onPressed: () => _showProductDialog(), // Mở hộp thoại thêm sản phẩm
      ),
    );
  }
}
