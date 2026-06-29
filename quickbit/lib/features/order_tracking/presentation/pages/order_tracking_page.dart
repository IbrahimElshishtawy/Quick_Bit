import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/cart/domain/entities/order_entity.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_event.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_state.dart';

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
                          color: AppColors.onSurfaceVariant.withOpacity(0.6),
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
                                style: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.6), fontSize: 12),
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
                                style: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.6), fontSize: 12),
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
                      color: AppColors.primaryContainer.withOpacity(0.1),
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
                _buildTimelineStep(
                  stepNumber: 0,
                  title: 'Order Placed',
                  subtitle: 'We have received your order.',
                  isActive: _currentStep >= 0,
                  isCompleted: _currentStep > 0,
                ),
                _buildTimelineStep(
                  stepNumber: 1,
                  title: 'Preparing Food',
                  subtitle: 'The kitchen is preparing your meals.',
                  isActive: _currentStep >= 1,
                  isCompleted: _currentStep > 1,
                ),
                _buildTimelineStep(
                  stepNumber: 2,
                  title: 'Ready for Pickup',
                  subtitle: 'Collect at student union locker station.',
                  isActive: _currentStep >= 2,
                  isCompleted: _currentStep > 2,
                  isLast: true,
                ),
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

  Widget _buildTimelineStep({
    required int stepNumber,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left side indicators
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppColors.primary
                      : (isActive ? AppColors.primaryContainer : AppColors.surfaceContainerHigh),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          (stepNumber + 1).toString(),
                          style: TextStyle(
                            color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: VerticalDivider(
                    color: isCompleted ? AppColors.primary : AppColors.outlineVariant,
                    thickness: 2,
                    indent: 4,
                    endIndent: 4,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.md),

          // Right side details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariant.withOpacity(0.4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
