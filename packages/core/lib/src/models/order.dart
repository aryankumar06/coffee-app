class Order {
  final String id;
  final String cafeId;
  final int tableNumber;
  final String status; // New, Preparing, Served, Done
  final String paymentMethod; // Cash, Online
  final String paymentStatus; // Pending, Paid
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.cafeId,
    required this.tableNumber,
    this.status = 'New',
    this.paymentMethod = 'Cash',
    this.paymentStatus = 'Pending',
    required this.totalAmount,
    required this.createdAt,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      cafeId: json['cafe_id'] as String,
      tableNumber: json['table_number'] as int,
      status: json['status'] ?? 'New',
      paymentMethod: json['payment_method'] ?? 'Cash',
      paymentStatus: json['payment_status'] ?? 'Pending',
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      items: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((itemJson) => OrderItem.fromJson(itemJson as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cafe_id': cafeId,
      'table_number': tableNumber,
      'status': status,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'total_amount': totalAmount,
    };
  }
}

class OrderItem {
  final String id;
  final String orderId;
  final String itemId;
  final String itemName; // For ui ease, not usually in DB directly normalized.
  final int quantity;
  final double lockedPrice;
  final String? note;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.itemId,
    this.itemName = "",
    required this.quantity,
    required this.lockedPrice,
    this.note,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      itemId: json['item_id'] as String,
      quantity: json['quantity'] as int,
      lockedPrice: (json['locked_price'] as num).toDouble(),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'item_id': itemId,
      'quantity': quantity,
      'locked_price': lockedPrice,
      'note': note,
    };
  }
}
