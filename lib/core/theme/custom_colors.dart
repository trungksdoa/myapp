import 'package:flutter/material.dart';

// Một class chứa các mã màu tùy chỉnh cho ứng dụng của bạn.
// Bạn có thể đặt tên màu theo ý nghĩa hoặc chức năng của chúng.
class CustomColors {
  // Màu sắc chính cho ứng dụng của bạn (ví dụ: màu thương hiệu).
  static const Color primaryColor = Color.fromRGBO(255, 255, 255, 255);

  // Màu nhấn mạnh, thường dùng cho các nút hoặc hành động quan trọng.
  static const Color accentColor = Color.fromRGBO(255, 134, 97, 255);

  // Màu nền cho các thành phần chính hoặc toàn bộ màn hình.
  static const Color backgroundColor = Color(0xFFF8F9FA);

  // Màu chữ cho nội dung chính.
  static const Color textColor = Color(0xFF212529);

  // Màu dùng để biểu thị lỗi hoặc trạng thái tiêu cực.
  static const Color errorColor = Color(0xFFDC3545);

  // Màu dùng để biểu thị cảnh báo.
  static const Color warningColor = Color(0xFFFFC107);

  // Màu dùng để biểu thị thành công hoặc trạng thái tích cực.
  static const Color successColor = Color(0xFF28A745);

  // Thêm các màu tùy chỉnh khác nếu cần.
  // static const Color anotherColor = Color(0xFFABCDEF);
}
