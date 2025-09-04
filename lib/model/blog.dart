import 'package:myapp/model/account.dart';
import 'package:myapp/model/pet.dart';

class Blog {
  final int? _id;
  final String? _description;
  final String? _imgUrls;
  final Account? _account;
  final Pet? _pets;

  Blog({
    int? id,
    String? description,
    String? imgUrls,
    Account? account,
    Pet? pets,
  }) : _id = id,
       _description = description,
       _imgUrls = imgUrls,
       _account = account,
       _pets = pets;

  int get id {
    if (_id == null) throw Exception('id not set');
    return _id;
  }

  String get description {
    if (_description == null) throw Exception('description not set');
    return _description;
  }

  String get imgUrls {
    if (_imgUrls == null) throw Exception('imgUrls not set');
    return _imgUrls;
  }

  Account get account {
    if (_account == null) throw Exception('account not set');
    return _account;
  }

  Pet get pets {
    return _pets ?? Pet();
  }

  // Nullable getters
  int? get idNullable => _id;
  String? get descriptionNullable => _description;
  String? get imgUrlsNullable => _imgUrls;
  Account? get accountNullable => _account;
  Pet? get petsNullable => _pets;
}
