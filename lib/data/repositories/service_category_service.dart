// Service Category Service Implementation (Mock)
import 'package:myapp/data/repositories/interfaces/i_service_category_service.dart';
import 'package:myapp/data/mock/services_mock.dart';

class ServiceCategoryService implements IServiceCategoryService {
  // TODO: Replace with actual API calls when backend is ready
  // Currently using mock data

  @override
  Future<List<Map<String, dynamic>>> getAllServices() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/service-categories');
    // return List<Map<String, dynamic>>.from(response.data);

    return List<Map<String, dynamic>>.from(services);
  }

  @override
  Future<Map<String, dynamic>?> getServiceByKey(String key) async {
    await Future.delayed(const Duration(milliseconds: 150));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/service-categories/\$key');
    // return Map<String, dynamic>.from(response.data);

    try {
      return services.firstWhere((service) => service['key'] == key);
    } catch (e) {
      return null;
    }
  }
}
