import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_state.dart';
import 'package:quickbit/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:quickbit/features/cart/presentation/widgets/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final items = state.items;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined, size: 80, color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'Your cart is empty',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Go grab some delicious foods!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Cart items list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CartItemTile(item: item);
                  },
                ),
              ),

              // Summary card
              CartSummary(state: state),
            ],
          );
        },
      ),
    );
  }
}
