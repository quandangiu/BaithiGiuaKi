import 'package:firebase_database/firebase_database.dart';

class ProductService {
  
  // Tham chiếu đến nút "products" trong Firebase Realtime Database
  final DatabaseReference _productsRef =
      FirebaseDatabase.instance.ref("products");

  // Các phương thức liên quan đến sản phẩm

  // Thêm sản phẩm mới vào Firebase
  Future<void> addProduct(String idSanPham, String loaiSp, double gia) async {
    // Tạo ID sản phẩm mới
    String newProductId = _productsRef.push().key!;
    // Lưu thông tin sản phẩm vào database
    await _productsRef.child(newProductId).set({
      "idsanpham": idSanPham, // ID của sản phẩm
      "loaisp": loaiSp, // Loại sản phẩm
      "gia": gia, // Giá sản phẩm
    });
  }

  // Cập nhật thông tin sản phẩm
  Future<void> updateProduct(
      String productId, String idSanPham, String loaiSp, double gia) async {
    await _productsRef.child(productId).set({
      "idsanpham": idSanPham, // ID sản phẩm mới
      "loaisp": loaiSp, // Loại sản phẩm mới
      "gia": gia, // Giá sản phẩm mới
    });
  }

  // Xóa sản phẩm khỏi Firebase
  Future<void> deleteProduct(String productId) async {
    await _productsRef.child(productId).remove();
  }

  // Lắng nghe sự thay đổi dữ liệu của danh sách sản phẩm
  Stream<DatabaseEvent> listenToProducts() {
    return _productsRef.onValue;
  }
}
