import '../../domain/entities/cafe_entity.dart';

class CafeModel extends CafeEntity {
  const CafeModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.distance,
    required super.deliveryTime,
    required super.description,
    required super.tags,
  });

  factory CafeModel.fromJson(Map<String, dynamic> json) {
    return CafeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      distance: json['distance'] as String,
      deliveryTime: json['deliveryTime'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'distance': distance,
      'deliveryTime': deliveryTime,
      'description': description,
      'tags': tags,
    };
  }
}
