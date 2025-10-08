import 'package:myapp/features/shop/service/interface/service-interface.dart';

/// Interface định nghĩa các phương thức cho Service Service (chỉ GET).
abstract class IServiceService {
  /// Khởi tạo service
  Future<void> initialize();

  /// Lấy danh sách service (có phân trang và sắp xếp)
  Future<ServiceListResponse> getAllServices({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
    String serviceCategoryId = '',
  });

  /// Lấy chi tiết service theo id
  Future<ServiceResponse> getServiceById(String id);

  /// Tìm kiếm service theo từ khóa
  Future<ServiceListResponse> searchServices(
    String searchTerm, {
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Lấy các service đang hoạt động
  Future<ServiceListResponse> getActiveServices({
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Lấy service theo shop id
  Future<ServiceListResponse> getServicesByShop(
    String shopId, {
    int pageIndex = 1,
    int pageSize = 10,
  });
}
