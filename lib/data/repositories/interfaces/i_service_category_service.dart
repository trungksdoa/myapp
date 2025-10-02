// Interface for Service Category Service
abstract class IServiceCategoryService {
  /// Get all service categories
  Future<List<Map<String, dynamic>>> getAllServices();

  /// Get service by key
  Future<Map<String, dynamic>?> getServiceByKey(String key);
}
