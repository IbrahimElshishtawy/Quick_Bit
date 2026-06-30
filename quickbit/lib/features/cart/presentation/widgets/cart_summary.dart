import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_state.dart';
import 'package:quickbit/features/checkout/presentation/pages/checkout_page.dart';

class CartSummary extends StatelessWidget {
  final CartState state;

  const CartSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 15,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.8)),
              ),
              Text(
                '\$${state.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax (8%)',
                style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.8)),
              ),
              Text(
                '\$${state.tax.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(
                '\$${state.total.toStringAsFixed(2)}',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CheckoutPage(),
                  ),
                );
              },
              child: const Text('Go to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
