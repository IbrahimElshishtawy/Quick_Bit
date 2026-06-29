import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/dimensions.dart';
import '../../domain/entities/food_item_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../../injection_container.dart';

class FoodDetailsPage extends StatefulWidget {
  final FoodItemEntity item;

  const FoodDetailsPage({super.key, required this.item});

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int _quantity = 1;
  final List<String> _selectedCustomizations = [];

  void _toggleCustomization(String option) {
    setState(() {
      if (_selectedCustomizations.contains(option)) {
        _selectedCustomizations.remove(option);
      } else {
        _selectedCustomizations.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<CartBloc>(),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item added to cart successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                // Top Cover Image & Header
                Expanded(
                  child: Stack(
                    children: [
                      // Food Image
                      Positioned.fill(
                        child: Image.network(
                          widget.item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Top shadow/overlay
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                                Colors.black26,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // App Bar Buttons
                      Positioned(
                        top: 50,
                        left: AppDimensions.lg,
                        right: AppDimensions.lg,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurface, size: 20),
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              child: const Icon(Icons.favorite_border, color: AppColors.onSurface, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Area
                Container(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 20,
                        offset: Offset(0, -4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Item Name & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.item.name,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 2),
                                Text(
                                  widget.item.rating.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),

                      // Item Description
                      Text(
                        widget.item.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),

                      // Customize Section
                      Text(
                        'Customize',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Wrap(
                        spacing: 8.0,
                        children: ['Extra Cheese', 'Spicy', 'Gluten Free'].map((opt) {
                          final selected = _selectedCustomizations.contains(opt);
                          return ChoiceChip(
                            label: Text(opt),
                            selected: selected,
                            onSelected: (_) => _toggleCustomization(opt),
                            selectedColor: AppColors.primaryContainer.withOpacity(0.2),
                            side: BorderSide(color: selected ? AppColors.primary : AppColors.outlineVariant),
                          );
                        }).toList(),
                      ),
                      const Divider(height: AppDimensions.lg),

                      // Quantity and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: AppColors.onSurfaceVariant.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${(widget.item.price * _quantity).toStringAsFixed(2)}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Quantity selector
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, size: 28),
                                color: _quantity > 1 ? AppColors.primary : AppColors.outlineVariant,
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
                                child: Text(
                                  _quantity.toString(),
                                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, size: 28, color: AppColors.primary),
                                onPressed: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.lg),

                      // Add to Cart Button
                      SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                            ),
                          ),
                          onPressed: () {
                            context.read<CartBloc>().add(
                                  AddCartItemEvent(
                                    foodItem: widget.item,
                                    quantity: _quantity,
                                  ),
                                );
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
