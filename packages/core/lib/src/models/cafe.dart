class Cafe {
  final String id;
  final String name;
  final String? logoUrl;
  final String? address;
  final int seatCount;
  final String subscriptionPlan;
  final DateTime createdAt;

  Cafe({
    required this.id,
    required this.name,
    this.logoUrl,
    this.address,
    required this.seatCount,
    this.subscriptionPlan = 'Free',
    required this.createdAt,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      address: json['address'] as String?,
      seatCount: json['seat_count'] as int? ?? 0,
      subscriptionPlan: json['subscription_plan'] ?? 'Free',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'address': address,
      'seat_count': seatCount,
      'subscription_plan': subscriptionPlan,
    };
  }
}
