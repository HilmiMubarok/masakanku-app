class Ingredient {
  final String id;
  final String name;
  final String category;
  final String icon;
  final String color;

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.color,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'Lainnya',
      icon: json['icon'] as String? ?? 'eco_rounded',
      color: json['color'] as String? ?? '#FFF8F4',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'icon': icon,
      'color': color,
    };
  }
}
