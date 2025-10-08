class BookingItem {
  final String serviceDetailId;
  final String serviceDetailName;
  final double price;
  final int durationTime;
  final int petQuantity;
  final String note;

  BookingItem({
    required this.serviceDetailId,
    required this.serviceDetailName,
    required this.price,
    required this.durationTime,
    required this.petQuantity,
    required this.note,
  });

  double get totalPrice => price * petQuantity;

  Map<String, dynamic> toJson() {
    return {
      'serviceDetailId': serviceDetailId,
      'serviceDetailName': serviceDetailName,
      'price': price,
      'durationTime': durationTime,
      'petQuantity': petQuantity,
      'note': note,
      'totalPrice': totalPrice,
    };
  }
}
