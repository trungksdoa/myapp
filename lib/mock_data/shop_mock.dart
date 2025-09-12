// Mock data for shops and products
import 'package:myapp/shared/model/product_detail.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/model/product.dart';

final services = [
  {'icon': "assets/images/Home1.png", 'label': 'Dịch vụ chăm sóc thú cưng'},
  {'icon': "assets/images/Home2.png", 'label': 'Sức khỏe và vệ sinh'},
  {'icon': "assets/images/Home3.png", 'label': 'Thức ăn và dinh dưỡng'},
  {'icon': "assets/images/Home4.png", 'label': 'Phụ kiện và đồ dùng'},
  {'icon': "assets/images/Home5.png", 'label': 'Y tế thú y'},
  {'icon': "assets/images/Home6.png", 'label': 'Khác'},
];
final mockShops = [
  Shop(
    shopId: 'shop_001',
    owner: 'owner_001@example.com',
    shopName: 'Pet Food Store',
    description: 'Premium pet food and accessories',
    status: true,
    workingDays: 'Mon-Sat',
  ),
  Shop(
    shopId: 'shop_002',
    owner: 'owner_002@example.com',
    shopName: 'Pet Grooming Center',
    description: 'Professional grooming services',
    status: true,
    workingDays: 'Tue-Sun',
  ),
  Shop(
    shopId: 'shop_003',
    owner: 'owner_002@example.com',
    shopName: 'Pet Grooming Center',
    description: 'Professional grooming services',
    status: true,
    workingDays: 'Tue-Sun',
  ),
];

final mockProducts = [
  Product(
    productId: 'prod_001',
    shopId: 'shop_001',
    productName: 'Premium Dog Food',
    description: 'High-quality nutrition for adult dogs',
    status: true,
    productDetail: ProductDetail(
      id: "1",
      productId: 'prod_001',
      price: 50000,
      discount: true,
      isDefault: true,
      quantityInStock: 100,
    ),
  ),
  Product(
    productId: 'prod_002',
    shopId: 'shop_001',
    productName: 'Cat Litter',
    description: 'Natural clumping litter',
    status: true,
    productDetail: ProductDetail(
      id: "2",
      productId: 'prod_002',
      price: 30000,
      discount: false,
      isDefault: true,
      quantityInStock: 200,
    ),
  ),
  Product(
    productId: 'prod_003',
    shopId: 'shop_002',
    productName: 'Full Grooming Package',
    description: 'Bath, haircut and nail trimming',
    status: true,
    productDetail: ProductDetail(
      id: "3",
      productId: 'prod_003',
      price: 150000,
      discount: true,
      isDefault: true,
      quantityInStock: 50,
    ),
  ),
];
