class OrderEntity {
  final String orderNumber;
  final String date;
  final String status;
  final String price;
  final String id;
  final String objectType;
  final String paymentMethodType;

  OrderEntity({
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.price,
    required this.id,
    required this.objectType,
    required this.paymentMethodType,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    final inPayments = json['inPayments'] as List?;
    String paymentDescription = "Cash on Delivery";
    if (inPayments?.isNotEmpty ?? false) {
      paymentDescription = inPayments?[0]['paymentMethod']['description'];
    }
    return OrderEntity(
      orderNumber: json['number'],
      paymentMethodType: paymentDescription,
      date: json['createdDate'],
      objectType: json['objectType'],
      id: json['id'],
      status: json['status'],
      price: json['total']['formattedAmount'],
    );
  }
}