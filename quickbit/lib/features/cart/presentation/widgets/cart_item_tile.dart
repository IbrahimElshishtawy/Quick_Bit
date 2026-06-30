import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/cart/domain/entities/cart_item_entity.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_event.dart';

class CartItemTile extends StatelessWidget {
  final CartItemEntity item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.foodItem.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodItem.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (item.eggStyle != null)
                  Text(
                    'Style: ${item.eggStyle}',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                if (item.selectedExtras.isNotEmpty)
                  Text(
                    'Extras: ${item.selectedExtras.map((e) => e.name).join(", ")}',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.singleItemPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Quantity selectors
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 22),
                onPressed: () {
                  context.read<CartBloc>().add(
                        UpdateCartItemQuantityEvent(
                          cartItem: item,
                          quantity: item.quantity - 1,
                        ),
                      );
                },
              ),
              Text(
                item.quantity.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 22),
                onPressed: () {
                  context.read<CartBloc>().add(
                        UpdateCartItemQuantityEvent(
                          cartItem: item,
                          quantity: item.quantity + 1,
                        ),
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
