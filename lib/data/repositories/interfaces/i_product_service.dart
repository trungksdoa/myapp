// Interface for Product Service
import 'package:myapp/shared/model/product.dart';

abstract class IProductService {
  /// Get all products
  Future<List<Product>> getAllProducts();

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category);

  /// Get product by ID
  Future<Product?> getProductById(String productId);

  /// Get products by shop ID
  Future<List<Product>> getProductsByShop(String shopId);

  /// Search products by name or description
  Future<List<Product>> searchProducts(String query);

  /// Get featured products
  Future<List<Product>> getFeaturedProducts();

  /// Get discounted products
  Future<List<Product>> getDiscountedProducts();
}
