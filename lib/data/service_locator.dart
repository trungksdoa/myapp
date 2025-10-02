// Service Locator for dependency injection
import 'package:myapp/data/repositories/interfaces/i_product_service.dart';
import 'package:myapp/data/repositories/interfaces/i_shop_service.dart';
import 'package:myapp/data/repositories/interfaces/i_service_category_service.dart';
import 'package:myapp/data/repositories/interfaces/i_pet_service.dart';
import 'package:myapp/data/repositories/interfaces/i_appointment_service.dart';
import 'package:myapp/data/repositories/interfaces/i_notification_service.dart';
import 'package:myapp/data/repositories/interfaces/i_account_service.dart';
import 'package:myapp/data/repositories/product_service.dart';
import 'package:myapp/data/repositories/shop_service.dart';
import 'package:myapp/data/repositories/service_category_service.dart';
import 'package:myapp/data/repositories/pet_service.dart';
import 'package:myapp/data/repositories/appointment_service.dart';
import 'package:myapp/data/repositories/personal_notification_service.dart';
import 'package:myapp/data/repositories/account_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Service instances
  late final IProductService _productService;
  late final IShopService _shopService;
  late final IServiceCategoryService _serviceCategoryService;
  late final IPetService _petService;
  late final IAppointmentService _appointmentService;
  late final IPersonalNotificationService _notificationService;
  late final IAccountService _accountService;

  /// Initialize all services
  void initialize() {
    // TODO: When switching to real API, replace these implementations
    // with API-based services
    _productService = ProductService();
    _shopService = ShopService();
    _serviceCategoryService = ServiceCategoryService();
    _petService = PetService();
    _appointmentService = AppointmentService();
    _notificationService = PersonalNotificationService();
    _accountService = AccountService();
  }

  // Getters for services
  IProductService get productService => _productService;
  IShopService get shopService => _shopService;
  IServiceCategoryService get serviceCategoryService => _serviceCategoryService;
  IPetService get petService => _petService;
  IAppointmentService get appointmentService => _appointmentService;
  IPersonalNotificationService get notificationService => _notificationService;
  IAccountService get accountService => _accountService;
}
