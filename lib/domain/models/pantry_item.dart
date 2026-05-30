import 'ingredient.dart';

class PantryItem {
  final String id;
  final String userId;
  final String ingredientId;
  final Ingredient? ingredient; // Nullable if not joined
  final double quantity;
  final String unit;
  final DateTime? expiredAt;

  PantryItem({
    required this.id,
    required this.userId,
    required this.ingredientId,
    this.ingredient,
    required this.quantity,
    required this.unit,
    this.expiredAt,
  });

  factory PantryItem.fromJson(Map<String, dynamic> json) {
    return PantryItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      ingredientId: json['ingredient_id'] as String,
      ingredient: json['ingredients'] != null 
          ? Ingredient.fromJson(json['ingredients'] as Map<String, dynamic>) 
          : null,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      expiredAt: json['expired_at'] != null ? DateTime.parse(json['expired_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'ingredient_id': ingredientId,
      'quantity': quantity,
      'unit': unit,
      'expired_at': expiredAt?.toIso8601String(),
    };
  }
}
