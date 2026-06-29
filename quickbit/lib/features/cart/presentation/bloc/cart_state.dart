import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';

abstract class CartState extends Equatable {
  final List<CartItemEntity> items;
  final OrderEntity? activeOrder;

  const CartState({
    this.items = const [],
    this.activeOrder,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.08; // 8% campus food tax
  double get total => subtotal + tax;

  @override
  List<Object?> get props => [items, activeOrder];
}

class CartInitial extends CartState {
  const CartInitial() : super();
}

class CartUpdated extends CartState {
  const CartUpdated({super.items, super.activeOrder});
}

class CartOperationSuccess extends CartState {
  const CartOperationSuccess({super.items, super.activeOrder});
}

class OrderPlacedSuccess extends CartState {
  const OrderPlacedSuccess({super.items, required OrderEntity order}) : super(activeOrder: order);
}

class OrderTrackingState extends CartState {
  const OrderTrackingState({super.items, required OrderEntity order}) : super(activeOrder: order);
}
