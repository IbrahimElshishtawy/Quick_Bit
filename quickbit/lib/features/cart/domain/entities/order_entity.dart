import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

enum OrderStatus {
  placed,
  preparing,
  readyForPickup,
  completed,
}

class OrderEntity extends Equatable {
  final String orderId;
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double total;
  final OrderStatus status;
  final String pickupCode;
  final DateTime orderTime;

  const OrderEntity({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.pickupCode,
    required this.orderTime,
  });

  @override
  List<Object?> get props => [orderId, items, subtotal, tax, total, status, pickupCode, orderTime];
}
