import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_event.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_state.dart';
import 'package:quickbit/features/checkout/presentation/widgets/payment_method_tile.dart';
import 'package:quickbit/features/order_tracking/presentation/pages/order_tracking_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'Campus Meal Points';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is OrderPlacedSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OrderTrackingPage(order: state.activeOrder!),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order Summary Section
                Text(
                  'Order Summary',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.sm),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.8))),
                          Text('\$${state.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax (8%)', style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.8))),
                          Text('\$${state.tax.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            '\$${state.total.toStringAsFixed(2)}',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // Payment Method Section
                Text(
                  'Select Payment Method',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.sm),
                PaymentMethodTile(
                  icon: Icons.badge,
                  title: 'Campus Meal Points',
                  subtitle: 'Balance: 120.50 Points',
                  isSelected: _selectedPaymentMethod == 'Campus Meal Points',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Campus Meal Points';
                    });
                  },
                ),
                const SizedBox(height: AppDimensions.md),
                PaymentMethodTile(
                  icon: Icons.credit_card,
                  title: 'Credit / Debit Card',
                  subtitle: 'Visa **** 4321',
                  isSelected: _selectedPaymentMethod == 'Credit / Debit Card',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Credit / Debit Card';
                    });
                  },
                ),
                const SizedBox(height: AppDimensions.md),
                PaymentMethodTile(
                  icon: Icons.apple,
                  title: 'Apple Pay',
                  subtitle: 'Quick & secure payment',
                  isSelected: _selectedPaymentMethod == 'Apple Pay',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Apple Pay';
                    });
                  },
                ),
                const SizedBox(height: AppDimensions.xxl),

                // Place Order Button
                SizedBox(
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    onPressed: () {
                      context.read<CartBloc>().add(
                            PlaceOrderEvent(paymentMethod: _selectedPaymentMethod),
                          );
                    },
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
