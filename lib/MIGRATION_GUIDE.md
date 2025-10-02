# Migration Guide: From Mock Data to Real API

Đây là hướng dẫn để chuyển đổi từ mock data sang API thực tế trong ứng dụng CareNest.

## 📋 Tổng quan về kiến trúc mới

### Cấu trúc thư mục đã được tái tổ chức:

```
lib/
├── data/
│   ├── service_locator.dart          # Dependency injection
│   ├── mock/                         # Mock data được tách riêng
│   │   ├── services_mock.dart
│   │   ├── shops_mock.dart
│   │   └── products/
│   │       ├── products_mock.dart
│   │       ├── care_products_mock.dart
│   │       ├── health_products_mock.dart
│   │       ├── food_products_mock.dart
│   │       ├── accessory_products_mock.dart
│   │       ├── medical_products_mock.dart
│   │       └── other_products_mock.dart
│   └── repositories/
│       ├── interfaces/               # Service interfaces
│       │   ├── i_product_service.dart
│       │   ├── i_shop_service.dart
│       │   └── i_service_category_service.dart
│       ├── product_service.dart      # Product service implementation
│       ├── shop_service.dart         # Shop service implementation
│       └── service_category_service.dart
└── features/                         # Đã cập nhật sử dụng services
    └── shop/
        └── screen/
            ├── shop_screen.dart      ✅ Updated
            ├── shop_detail_screen.dart ✅ Updated
            ├── service_order_screen.dart ✅ Updated
            └── detail_product.dart   ✅ Updated
```

## 🔄 Khi có API thực tế

### Bước 1: Tạo API Service classes

Tạo các API service implementations trong `lib/data/repositories/`:

```dart
// lib/data/repositories/api_product_service.dart
class ApiProductService implements IProductService {
  final HttpClient _httpClient;

  ApiProductService(this._httpClient);

  @override
  Future<List<Product>> getAllProducts() async {
    final response = await _httpClient.get('/api/products');
    return response.data.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _httpClient.get('/api/products?category=$category');
    return response.data.map((json) => Product.fromJson(json)).toList();
  }

  // ... implement other methods
}
```

### Bước 2: Cập nhật ServiceLocator

Trong `lib/data/service_locator.dart`, thay đổi implementation:

```dart
void initialize() {
  // OLD: Mock implementations
  // _productService = ProductService();
  // _shopService = ShopService();
  // _serviceCategoryService = ServiceCategoryService();

  // NEW: API implementations
  final httpClient = HttpClient(baseUrl: 'https://your-api.com');
  _productService = ApiProductService(httpClient);
  _shopService = ApiShopService(httpClient);
  _serviceCategoryService = ApiServiceCategoryService(httpClient);
}
```

### Bước 3: Xóa mock data imports

Tìm và xóa các dòng comment TODO trong các files sau:

#### Files cần cập nhật:

- `lib/features/shop/screen/shop_screen.dart`
- `lib/features/shop/screen/shop_detail_screen.dart`
- `lib/features/shop/screen/service_order_screen.dart`
- `lib/features/shop/screen/detail_product.dart`
- `lib/features/shop/widgets/shop_service_list_widget.dart`

#### Ví dụ thay đổi:

```dart
// BEFORE:
// TODO: Comment out when API is ready
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/data/service_locator.dart';

// AFTER:
import 'package:myapp/data/service_locator.dart';
```

### Bước 4: Loại bỏ fallback logic

Xóa các fallback logic đến mock data:

```dart
// BEFORE:
try {
  final products = await productService.getAllProducts();
  // use products
} catch (e) {
  // Fallback to mock data if service fails
  final products = mockProducts;
  // use products
}

// AFTER:
final products = await productService.getAllProducts();
// use products
```

## 📝 Checklist Migration

- [ ] Implement API service classes
- [ ] Update ServiceLocator with API implementations
- [ ] Remove mock data imports from features
- [ ] Remove fallback logic to mock data
- [ ] Remove mock data files (optional)
- [ ] Update error handling for API calls
- [ ] Add loading states for async operations
- [ ] Test all features with real API

## 🚀 Ưu điểm của kiến trúc mới

1. **Tách biệt rõ ràng**: Mock data và logic business tách biệt
2. **Dễ dàng chuyển đổi**: Interface pattern giúp swap implementations dễ dàng
3. **Testable**: Có thể easily mock services cho unit tests
4. **Maintainable**: Code được tổ chức rõ ràng theo layers
5. **Scalable**: Dễ dàng thêm caching, error handling, retry logic

## ⚠️ Lưu ý quan trọng

- Tất cả features hiện tại vẫn hoạt động với mock data
- ServiceLocator đã được khởi tạo trong main.dart
- Interface pattern đảm bảo không breaking changes khi chuyển sang API
- Mock data vẫn được giữ làm fallback trong trường hợp API fails

## 📚 Service Interfaces Available

### IProductService

- `getAllProducts()` - Get all products
- `getProductsByCategory(category)` - Filter by category
- `getProductById(productId)` - Get single product
- `getProductsByShop(shopId)` - Filter by shop
- `searchProducts(query)` - Search products
- `getFeaturedProducts()` - Get featured items
- `getDiscountedProducts()` - Get discounted items

### IShopService

- `getAllShops()` - Get all shops
- `getShopById(shopId)` - Get single shop
- `getActiveShops()` - Filter active shops
- `searchShops(query)` - Search shops
- `getShopsByOwner(ownerEmail)` - Filter by owner

### IServiceCategoryService

- `getAllServices()` - Get service categories
- `getServiceByKey(key)` - Get single service category

Tất cả đã sẵn sàng để chuyển sang API thực tế! 🎉
