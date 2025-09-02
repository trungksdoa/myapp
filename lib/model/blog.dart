class Blog {
  final int id;
  final String description;
  final String imgUrls;
  final String accountId;
  final List<int> petIds;

  Blog({
    required this.id,
    required this.description,
    required this.imgUrls,
    required this.accountId,
    this.petIds = const [],
  });
}
