import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/food_item_entity.dart';
import '../../domain/entities/order_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddCartItemEvent extends CartEvent {
  final FoodItemEntity foodItem;
  final int quantity;

  const AddCartItemEvent({required this.foodItem, required this.quantity});

  @override
  List<Object?> get props => [foodItem, quantity];
}

class RemoveCartItemEvent extends CartEvent {
  final FoodItemEntity foodItem;

  const RemoveCartItemEvent({required this.foodItem});

  @override
  List<Object?> get props => [foodItem];
}

class UpdateCartItemQuantityEvent extends CartEvent {
  final FoodItemEntity foodItem;
  final int quantity;

  const UpdateCartItemQuantityEvent({required this.foodItem, required this.quantity});

  @override
  List<Object?> get props => [foodItem, quantity];
}

class ClearCartEvent extends CartEvent {}

class PlaceOrderEvent extends CartEvent {
  final String paymentMethod;

  const PlaceOrderEvent({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class UpdateOrderStatusEvent extends CartEvent {
  final OrderStatus status;

  const UpdateOrderStatusEvent({required this.status});

  @override
  List<Object?> get props => [status];
}
