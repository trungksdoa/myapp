import 'package:myapp/features/shop/service/interface/service_category.dart';

/// Interface định nghĩa các phương thức cho Service Category Service (chỉ GET).
abstract class IServiceCategoryService {
  /// Khởi tạo service
  Future<void> initialize();

  /// Lấy danh sách service category (có phân trang và sắp xếp)
  Future<ServiceCategoryListResponse> getAllServiceCategories({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
  });

  /// Lấy chi tiết service category theo id
  Future<ServiceCategoryResponse> getServiceCategoryById(String id);

  /// Tìm kiếm service category theo từ khóa
  Future<ServiceCategoryListResponse> searchServiceCategories(
    String searchTerm, {
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Lấy service category theo shop id
  Future<ServiceCategoryListResponse> getServiceCategoriesByShop(
    String shopId, {
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Lấy service category theo shop name
  Future<ServiceCategoryListResponse> getServiceCategoriesByShopName(
    String shopName, {
    int pageIndex = 1,
    int pageSize = 10,
  });
}
