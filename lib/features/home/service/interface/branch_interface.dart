import 'package:myapp/features/home/service/interface/branch.dart';

abstract class IBranchService {
  /// Khởi tạo service
  Future<void> initialize();

  /// Lấy tất cả branches
  Future<BranchListResponse> getAllBranches({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn,
    String sortDirection = 'asc',
  });

  /// Lấy branches theo shop ID
  Future<BranchListResponse> getBranchesByShop(
    String shopId, {
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Tìm kiếm branches theo từ khóa
  Future<BranchListResponse> searchBranches(
    String searchTerm, {
    int pageIndex = 1,
    int pageSize = 10,
  });
}
