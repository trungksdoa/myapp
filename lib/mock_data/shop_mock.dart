// Mock data for shops and products
import 'package:myapp/model/product_detail.dart';

import '../model/shop.dart';
import '../model/product.dart';

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
