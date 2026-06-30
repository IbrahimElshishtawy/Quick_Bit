import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/home/domain/entities/cafe_entity.dart';

class CafeInfoBanner extends StatelessWidget {
  final CafeEntity cafe;

  const CafeInfoBanner({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cafe.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      cafe.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Row(
                children: [
                  const Icon(Icons.directions_walk, size: 18, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 2),
                  Text(cafe.distance),
                ],
              ),
              const SizedBox(width: AppDimensions.md),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 2),
                  Text(cafe.deliveryTime),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            cafe.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            children: cafe.tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: AppColors.surfaceContainerLow,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              );
            }).toList(),
          ),
          const Divider(height: AppDimensions.xl),
          Text(
            'Menu',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
