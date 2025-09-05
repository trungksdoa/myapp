import 'package:myapp/model/account.dart';
import 'package:myapp/model/pet.dart';

class Blog {
  final int? _id;
  final String? _description;
  final List<ImgUrl>? _imgUrls;
  final Account? _account;
  final Pet? _pets;

  Blog({
    int? id,
    String? description,
    List<ImgUrl>? imgUrls,
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

  List<ImgUrl> get imgUrls {
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
  List<ImgUrl>? get imgUrlsNullable => _imgUrls;
  Account? get accountNullable => _account;
  Pet? get petsNullable => _pets;
}

class ImgUrl {
  final int fileId;
  final String url;

  ImgUrl({required this.fileId, required this.url});

  factory ImgUrl.fromJson(Map<String, dynamic> json) {
    return ImgUrl(fileId: json['fileId'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'fileId': fileId, 'url': url};
  }
}
