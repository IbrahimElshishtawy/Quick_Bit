import '../../domain/entities/food_item_entity.dart';

class FoodItemModel extends FoodItemEntity {
  const FoodItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.cafeId,
    required super.rating,
    required super.ingredients,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      cafeId: json['cafeId'] as String,
      rating: (json['rating'] as num).toDouble(),
      ingredients: List<String>.from(json['ingredients'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'cafeId': cafeId,
      'rating': rating,
      'ingredients': ingredients,
    };
  }
}
