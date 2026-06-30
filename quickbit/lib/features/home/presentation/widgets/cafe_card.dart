import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/home/domain/entities/cafe_entity.dart';
import 'package:quickbit/features/cafe_details/presentation/pages/cafe_details_page.dart';

class CafeCard extends StatelessWidget {
  final CafeEntity cafe;

  const CafeCard({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 15,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CafeDetailsPage(cafe: cafe),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cafe Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
              child: Stack(
                children: [
                  Image.network(
                    cafe.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: AppDimensions.md,
                    right: AppDimensions.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            cafe.rating.toString(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cafe details text
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.directions_walk, size: 16, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Text(
                        cafe.distance,
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      const Icon(Icons.access_time, size: 16, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Text(
                        cafe.deliveryTime,
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
