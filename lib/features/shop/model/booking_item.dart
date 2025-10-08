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

  // Calculate total price based on quantity
  double get totalPrice => price * petQuantity;

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'serviceDetailId': serviceDetailId,
      'serviceDetailName': serviceDetailName,
      'price': price,
      'durationTime': durationTime,
      'petQuantity': petQuantity,
      'note': note,
    };
  }

  // Create from JSON
  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      serviceDetailId: json['serviceDetailId'] as String,
      serviceDetailName: json['serviceDetailName'] as String,
      price: (json['price'] as num).toDouble(),
      durationTime: json['durationTime'] as int,
      petQuantity: json['petQuantity'] as int,
      note: json['note'] as String,
    );
  }

  // Copy with new values
  BookingItem copyWith({
    String? serviceDetailId,
    String? serviceDetailName,
    double? price,
    int? durationTime,
    int? petQuantity,
    String? note,
  }) {
    return BookingItem(
      serviceDetailId: serviceDetailId ?? this.serviceDetailId,
      serviceDetailName: serviceDetailName ?? this.serviceDetailName,
      price: price ?? this.price,
      durationTime: durationTime ?? this.durationTime,
      petQuantity: petQuantity ?? this.petQuantity,
      note: note ?? this.note,
    );
  }
}
