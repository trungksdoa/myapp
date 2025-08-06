class Review {
  final String id;
  final String customerId;
  final String itemTypeId;
  final int rating;
  final String content;

  Review({
    required this.id,
    required this.customerId,
    required this.itemTypeId,
    required this.rating,
    required this.content,
  });
}