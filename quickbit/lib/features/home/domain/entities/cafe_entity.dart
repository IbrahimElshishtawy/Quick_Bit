import 'package:equatable/equatable.dart';

class CafeEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String distance;
  final String deliveryTime;
  final String description;
  final List<String> tags;

  const CafeEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.deliveryTime,
    required this.description,
    required this.tags,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, rating, distance, deliveryTime, description, tags];
}
