class MenuItem {
  final String id;
  final String cafeId;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final bool isVeg;
  final String? imageUrl;
  final double discountPercent;
  final String offerLabel;
  final bool isActive;

  MenuItem({
    required this.id,
    required this.cafeId,
    required this.categoryId,
    required this.name,
    required this.price,
    this.description = "",
    this.isVeg = true,
    this.imageUrl,
    this.discountPercent = 0.0,
    this.offerLabel = "",
    this.isActive = true,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      cafeId: json['cafe_id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      isVeg: json['is_veg'] as bool? ?? true,
      imageUrl: json['image_url'] as String?,
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0.0,
      offerLabel: json['offer_label'] ?? '',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cafe_id': cafeId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'is_veg': isVeg,
      'image_url': imageUrl,
      'discount_percent': discountPercent,
      'offer_label': offerLabel,
      'is_active': isActive,
    };
  }
}

class MenuCategory {
  final String id;
  final String cafeId;
  final String name;
  final int sortOrder;
  final List<MenuItem> items; // Not usually stored directly in Supabase categories table, linked dynamically.

  MenuCategory({
    required this.id,
    required this.cafeId,
    required this.name,
    this.sortOrder = 0,
    this.items = const [],
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] as String,
      cafeId: json['cafe_id'] as String,
      name: json['name'] as String,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cafe_id': cafeId,
      'name': name,
      'sort_order': sortOrder,
    };
  }
}
