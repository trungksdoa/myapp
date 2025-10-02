// Centralized mock products export
import 'package:myapp/shared/model/product.dart';
import 'care_products_mock.dart';
import 'health_products_mock.dart';
import 'food_products_mock.dart';
import 'accessory_products_mock.dart';
import 'medical_products_mock.dart';
import 'other_products_mock.dart';

/// Combined list of all mock products from different categories
final mockProducts = [
  ...mockCareProducts,
  ...mockHealthProducts,
  ...mockFoodProducts,
  ...mockAccessoryProducts,
  ...mockMedicalProducts,
  ...mockOtherProducts,
];
