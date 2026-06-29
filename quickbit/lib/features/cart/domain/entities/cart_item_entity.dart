import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/food_item_entity.dart';

class CartItemEntity extends Equatable {
  final FoodItemEntity foodItem;
  final int quantity;

  const CartItemEntity({
    required this.foodItem,
    required this.quantity,
  });

  double get totalPrice => foodItem.price * quantity;

  CartItemEntity copyWith({
    FoodItemEntity? foodItem,
    int? quantity,
  }) {
    return CartItemEntity(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [foodItem, quantity];
}
