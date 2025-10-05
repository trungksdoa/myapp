// lib/features/service_detail/services/interface/i_service_detail_service.dart

import 'package:myapp/features/shop/service/interface/service-detail-interface.dart';

abstract class IServiceDetailService {
  /// Get all service details with pagination and sorting
  Future<ServiceDetailListResponse> getAllServiceDetails({
    int pageIndex = 1,
    int pageSize = 10,
    String? sortColumn, // name, updateat, ownerid
    String sortDirection = 'asc', // asc or desc
  });

  /// Get service detail by ID
  Future<ServiceDetailResponse> getServiceDetailById(String id);

  /// Create new service detail
  Future<CreateServiceDetailResponse> createServiceDetail(
    CreateServiceDetailRequest request,
  );

  /// Update service detail
  Future<ServiceDetailResponse> updateServiceDetail(
    String id,
    UpdateServiceDetailRequest request,
  );

  /// Delete service detail
  Future<bool> deleteServiceDetail(String id);

  /// Get service details by category
  Future<ServiceDetailListResponse> getServiceDetailsByCategory(
    String categoryId, {
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Search service details by name
  Future<ServiceDetailListResponse> searchServiceDetails(
    String searchTerm, {
    int pageIndex = 1,
    int pageSize = 10,
  });

  /// Get active service details only
  Future<ServiceDetailListResponse> getActiveServiceDetails({
    int pageIndex = 1,
    int pageSize = 10,
  });
}
