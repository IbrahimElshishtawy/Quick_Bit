import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../food_details/domain/entities/customization_option.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItemEntity> _cartItems = [];

  CartBloc() : super(const CartInitial()) {
    on<AddCartItemEvent>(_onAddItem);
    on<RemoveCartItemEvent>(_onRemoveItem);
    on<UpdateCartItemQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  bool _areExtrasEqual(List<CustomizationOption> a, List<CustomizationOption> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toSet();
    final bIds = b.map((e) => e.id).toSet();
    return aIds.length == bIds.length && aIds.containsAll(bIds);
  }

  void _onAddItem(AddCartItemEvent event, Emitter<CartState> emit) {
    final existingIndex = _cartItems.indexWhere((item) =>
        item.foodItem.id == event.foodItem.id &&
        item.eggStyle == event.eggStyle &&
        _areExtrasEqual(item.selectedExtras, event.selectedExtras));

    if (existingIndex >= 0) {
      final oldItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = oldItem.copyWith(quantity: oldItem.quantity + event.quantity);
    } else {
      _cartItems.add(CartItemEntity(
        foodItem: event.foodItem,
        quantity: event.quantity,
        eggStyle: event.eggStyle,
        selectedExtras: event.selectedExtras,
      ));
    }
    emit(CartOperationSuccess(items: List.from(_cartItems), activeOrder: state.activeOrder));
    emit(CartUpdated(items: List.from(_cartItems), activeOrder: state.activeOrder));
  }

  void _onRemoveItem(RemoveCartItemEvent event, Emitter<CartState> emit) {
    _cartItems.removeWhere((item) =>
        item.foodItem.id == event.cartItem.foodItem.id &&
        item.eggStyle == event.cartItem.eggStyle &&
        _areExtrasEqual(item.selectedExtras, event.cartItem.selectedExtras));
    emit(CartUpdated(items: List.from(_cartItems), activeOrder: state.activeOrder));
  }

  void _onUpdateQuantity(UpdateCartItemQuantityEvent event, Emitter<CartState> emit) {
    final index = _cartItems.indexWhere((item) =>
        item.foodItem.id == event.cartItem.foodItem.id &&
        item.eggStyle == event.cartItem.eggStyle &&
        _areExtrasEqual(item.selectedExtras, event.cartItem.selectedExtras));

    if (index >= 0) {
      if (event.quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: event.quantity);
      }
    }
    emit(CartUpdated(items: List.from(_cartItems), activeOrder: state.activeOrder));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    _cartItems.clear();
    emit(const CartInitial());
  }

  void _onPlaceOrder(PlaceOrderEvent event, Emitter<CartState> emit) {
    if (_cartItems.isEmpty) return;

    final subtotal = _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.08;
    final total = subtotal + tax;

    final random = Random();
    final pickupCode = 'QB-${random.nextInt(9000) + 1000}';
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    final newOrder = OrderEntity(
      orderId: orderId,
      items: List.from(_cartItems),
      subtotal: subtotal,
      tax: tax,
      total: total,
      status: OrderStatus.placed,
      pickupCode: pickupCode,
      orderTime: DateTime.now(),
    );

    _cartItems.clear();
    emit(OrderPlacedSuccess(items: const [], order: newOrder));
  }

  void _onUpdateOrderStatus(UpdateOrderStatusEvent event, Emitter<CartState> emit) {
    if (state.activeOrder != null) {
      final updatedOrder = OrderEntity(
        orderId: state.activeOrder!.orderId,
        items: state.activeOrder!.items,
        subtotal: state.activeOrder!.subtotal,
        tax: state.activeOrder!.tax,
        total: state.activeOrder!.total,
        status: event.status,
        pickupCode: state.activeOrder!.pickupCode,
        orderTime: state.activeOrder!.orderTime,
      );
      emit(OrderTrackingState(items: const [], order: updatedOrder));
    }
  }
}
