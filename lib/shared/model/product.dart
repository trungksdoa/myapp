import 'package:myapp/shared/model/product_detail.dart';

class Product {
  final String? _productId;
  final String? _shopId;
  final String? _productName;
  final String? _description;
  final bool? _status;
  final ProductDetail? _productDetail;

  Product({
    ProductDetail? productDetail,
    String? productId,
    String? shopId,
    String? productName,
    String? description,
    bool? status,
  }) : _productDetail = productDetail,
       _productId = productId,
       _shopId = shopId,
       _productName = productName,
       _description = description,
       _status = status;

  ProductDetail? get productDetail => _productDetail;

  String get productId {
    if (_productId == null) throw Exception('productId not set');
    return _productId;
  }

  String get shopId {
    if (_shopId == null) throw Exception('shopId not set');
    return _shopId;
  }

  String get productName {
    if (_productName == null) throw Exception('productName not set');
    return _productName;
  }

  String get description {
    if (_description == null) throw Exception('description not set');
    return _description;
  }

  bool get status {
    if (_status == null) throw Exception('status not set');
    return _status;
  }

  // Nullable getters
  String? get productIdNullable => _productId;
  String? get shopIdNullable => _shopId;
  String? get productNameNullable => _productName;
  String? get descriptionNullable => _description;
  bool? get statusNullable => _status;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productDetail: json['productDetail'] != null
          ? ProductDetail.fromJson(json['productDetail'])
          : null,
      productId: json['productId'],
      shopId: json['shopId'],
      productName: json['productName'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productIdNullable,
      'shopId': shopIdNullable,
      'productName': productNameNullable,
      'description': descriptionNullable,
      'status': statusNullable,
    };
  }
}
