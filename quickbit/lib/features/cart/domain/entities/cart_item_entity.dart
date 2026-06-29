import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/food_item_entity.dart';
import '../../../food_details/domain/entities/customization_option.dart';

class CartItemEntity extends Equatable {
  final FoodItemEntity foodItem;
  final int quantity;
  final String? eggStyle;
  final List<CustomizationOption> selectedExtras;

  const CartItemEntity({
    required this.foodItem,
    required this.quantity,
    this.eggStyle,
    this.selectedExtras = const [],
  });

  double get singleItemPrice {
    double extrasPrice = selectedExtras.fold(0.0, (sum, option) => sum + option.price);
    return foodItem.price + extrasPrice;
  }

  double get totalPrice => singleItemPrice * quantity;

  CartItemEntity copyWith({
    FoodItemEntity? foodItem,
    int? quantity,
    String? eggStyle,
    List<CustomizationOption>? selectedExtras,
  }) {
    return CartItemEntity(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      eggStyle: eggStyle ?? this.eggStyle,
      selectedExtras: selectedExtras ?? this.selectedExtras,
    );
  }

  @override
  List<Object?> get props => [foodItem, quantity, eggStyle, selectedExtras];
}
