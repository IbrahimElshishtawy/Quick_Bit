import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/cart/domain/entities/order_entity.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_event.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_state.dart';
import 'package:quickbit/features/order_tracking/presentation/widgets/order_status_stepper.dart';

class OrderTrackingPage extends StatefulWidget {
  final OrderEntity order;

  const OrderTrackingPage({super.key, required this.order});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  Timer? _statusTimer;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // Simulate order progress status transitions
    _startStatusSimulation();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  void _startStatusSimulation() {
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });

        OrderStatus newStatus;
        if (_currentStep == 1) {
          newStatus = OrderStatus.preparing;
        } else {
          newStatus = OrderStatus.readyForPickup;
        }

        context.read<CartBloc>().add(UpdateOrderStatusEvent(status: newStatus));
      } else {
        _statusTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.onSurface),
          onPressed: () {
            context.read<CartBloc>().add(ClearCartEvent());
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final activeOrder = state.activeOrder ?? widget.order;
          final status = activeOrder.status;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order ID & Estimate Card
                Container(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Estimated Ready Time',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status == OrderStatus.readyForPickup ? 'Ready Now!' : '10-15 Minutes',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: AppDimensions.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order ID',
                                style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6), fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(activeOrder.orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Pickup Code',
                                style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6), fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                activeOrder.pickupCode,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // Pickup Code QR Code Simulation
                if (status == OrderStatus.readyForPickup)
                  Container(
                    margin: const EdgeInsets.only(bottom: AppDimensions.xl),
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.primaryContainer, width: 1),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.qr_code_2, size: 120, color: AppColors.primary),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          'Scan QR at pickup locker',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Locker #B-04',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Timeline Status Track
                Text(
                  'Order Progress',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.md),
                OrderStatusStepper(currentStep: _currentStep),
                const SizedBox(height: AppDimensions.xxl),

                // Got it Button
                SizedBox(
                  height: AppDimensions.buttonHeight,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      context.read<CartBloc>().add(ClearCartEvent());
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
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
