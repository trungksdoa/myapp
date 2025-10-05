import 'package:myapp/features/shop/service/interface/shop-interface.dart';

/// Interface định nghĩa các phương thức cho Shop Service.
abstract class IShopService {
  /// Khởi tạo service
  Future<void> initialize();

  /// Lấy danh sách shop (có phân trang và sắp xếp)
  Future<ShopListResponse> getAllShops({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
  });

  /// Lấy chi tiết shop theo id
  Future<ShopResponse> getShopById(String id);

  /// Tạo mới shop
  Future<CreateShopResponse> createShop(CreateShopRequest request);

  /// Cập nhật shop theo id
  Future<ShopResponse> updateShop(String id, UpdateShopRequest request);

  /// Xóa shop theo id
  Future<bool> deleteShop(String id);

  /// Tìm kiếm shop theo từ khóa
  Future<ShopListResponse> searchShops(
    String searchTerm, {
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Lấy các shop đang hoạt động
  Future<ShopListResponse> getActiveShops({
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Lấy shop theo owner id
  Future<ShopListResponse> getShopsByOwner(
    String ownerId, {
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Cập nhật status của shop
  Future<ShopResponse> updateShopStatus(String id, int status);

  /// Lấy thống kê shop
  Future<Map<String, int>> getShopStatistics();
}
