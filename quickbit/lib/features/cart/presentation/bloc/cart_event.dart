import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/food_item_entity.dart';
import '../../../food_details/domain/entities/customization_option.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddCartItemEvent extends CartEvent {
  final FoodItemEntity foodItem;
  final int quantity;
  final String? eggStyle;
  final List<CustomizationOption> selectedExtras;

  const AddCartItemEvent({
    required this.foodItem,
    required this.quantity,
    this.eggStyle,
    this.selectedExtras = const [],
  });

  @override
  List<Object?> get props => [foodItem, quantity, eggStyle, selectedExtras];
}

class RemoveCartItemEvent extends CartEvent {
  final CartItemEntity cartItem;

  const RemoveCartItemEvent({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class UpdateCartItemQuantityEvent extends CartEvent {
  final CartItemEntity cartItem;
  final int quantity;

  const UpdateCartItemQuantityEvent({required this.cartItem, required this.quantity});

  @override
  List<Object?> get props => [cartItem, quantity];
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
