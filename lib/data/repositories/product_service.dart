// Product Service Implementation (Mock)
import 'package:myapp/data/repositories/interfaces/i_product_service.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/data/mock/products/products_mock.dart';

class ProductService implements IProductService {
  // TODO: Replace with actual API calls when backend is ready
  // Currently using mock data

  @override
  Future<List<Product>> getAllProducts() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 2));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/products');
    // return response.data.map((json) => Product.fromJson(json)).toList();

    return mockProducts;
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 2));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/products?category=\$category');
    // return response.data.map((json) => Product.fromJson(json)).toList();

    return mockProducts
        .where((product) => product.category == category)
        .toList();
  }

  @override
  Future<Product?> getProductById(String productId) async {
    await Future.delayed(const Duration(milliseconds: 2));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/products/\$productId');
    // return Product.fromJson(response.data);

    try {
      return mockProducts.firstWhere(
        (product) => product.productId == productId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProductsByShop(String shopId) async {
    await Future.delayed(const Duration(milliseconds: 2));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/shops/\$shopId/products');
    // return response.data.map((json) => Product.fromJson(json)).toList();

    return mockProducts.where((product) => product.shopId == shopId).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 2));

    // TODO: Replace with actual API call with full-text search
    // Example: final response = await httpClient.get('/api/products/search?q=\$query');
    // return response.data.map((json) => Product.fromJson(json)).toList();

    final lowerQuery = query.toLowerCase();
    return mockProducts
        .where(
          (product) =>
              product.productName.toLowerCase().contains(lowerQuery) ||
              product.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 2));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/products/featured');
    // return response.data.map((json) => Product.fromJson(json)).toList();

    // For now, return first 10 products as featured
    return mockProducts.take(10).toList();
  }

  @override
  Future<List<Product>> getDiscountedProducts() async {
    await Future.delayed(const Duration(milliseconds: 2));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/products/discounted');
    // return response.data.map((json) => Product.fromJson(json)).toList();

    return mockProducts
        .where((product) => product.productDetail?.discount == true)
        .toList();
  }
}
