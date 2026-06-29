import 'package:equatable/equatable.dart';

class FoodItemEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String cafeId;
  final double rating;
  final List<String> ingredients;

  const FoodItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.cafeId,
    required this.rating,
    required this.ingredients,
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, cafeId, rating, ingredients];
}
