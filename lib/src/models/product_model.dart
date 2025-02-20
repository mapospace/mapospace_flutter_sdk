import 'dart:convert';

class Product {
  final String productId;
  final String productName;
  final String categoryId;
  final String category;
  final String subcategory;
  final String subcategoryId;
  final String itemValue;
  final String itemCount;
  final String? promotionType;
  final String? promotionId;
  final String? campaignId;

  Product({
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.category,
    required this.subcategory,
    required this.subcategoryId,
    required this.itemValue,
    required this.itemCount,
    this.promotionType,
    this.promotionId,
    this.campaignId,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'category_id': categoryId,
      'category': category,
      'subcategory': subcategory,
      'subcategory_id': subcategoryId,
      'item_value': itemValue,
      'item_count': itemCount,
      'promotion_type': promotionType,
      'promotion_id': promotionId,
      'campaign_id': campaignId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_id'] as String,
      productName: map['product_name'] as String,
      categoryId: map['category_id'] as String,
      category: map['category'] as String,
      subcategory: map['subcategory'] as String,
      subcategoryId: map['subcategory_id'] as String,
      itemValue: map['item_value'] as String,
      itemCount: map['item_count'] as String,
      promotionType: map['promotion_type'] as String?,
      promotionId: map['promotion_id'] as String?,
      campaignId: map['campaign_id'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
