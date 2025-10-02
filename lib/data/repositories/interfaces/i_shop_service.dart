// Interface for Shop Service
import 'package:myapp/shared/model/shop.dart';

abstract class IShopService {
  /// Get all shops
  Future<List<Shop>> getAllShops();

  /// Get shop by ID
  Future<Shop?> getShopById(String shopId);

  /// Get active shops only
  Future<List<Shop>> getActiveShops();

  /// Search shops by name or description
  Future<List<Shop>> searchShops(String query);

  /// Get shops by owner
  Future<List<Shop>> getShopsByOwner(String ownerEmail);
}
