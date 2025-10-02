// Shop Service Implementation (Mock)
import 'package:myapp/data/repositories/interfaces/i_shop_service.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/data/mock/shops_mock.dart';

class ShopService implements IShopService {
  // TODO: Replace with actual API calls when backend is ready
  // Currently using mock data

  @override
  Future<List<Shop>> getAllShops() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/shops');
    // return response.data.map((json) => Shop.fromJson(json)).toList();

    return mockShops;
  }

  @override
  Future<Shop?> getShopById(String shopId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/shops/\$shopId');
    // return Shop.fromJson(response.data);

    try {
      return mockShops.firstWhere((shop) => shop.shopId == shopId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Shop>> getActiveShops() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/shops?status=active');
    // return response.data.map((json) => Shop.fromJson(json)).toList();

    return mockShops.where((shop) => shop.status == true).toList();
  }

  @override
  Future<List<Shop>> searchShops(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // TODO: Replace with actual API call with full-text search
    // Example: final response = await httpClient.get('/api/shops/search?q=\$query');
    // return response.data.map((json) => Shop.fromJson(json)).toList();

    final lowerQuery = query.toLowerCase();
    return mockShops
        .where(
          (shop) =>
              shop.shopName.toLowerCase().contains(lowerQuery) ||
              shop.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  @override
  Future<List<Shop>> getShopsByOwner(String ownerEmail) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/shops?owner=\$ownerEmail');
    // return response.data.map((json) => Shop.fromJson(json)).toList();

    return mockShops.where((shop) => shop.owner == ownerEmail).toList();
  }
}
