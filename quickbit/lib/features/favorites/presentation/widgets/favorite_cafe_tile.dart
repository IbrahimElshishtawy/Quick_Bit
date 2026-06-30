import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/home/domain/entities/cafe_entity.dart';
import 'package:quickbit/features/cafe_details/presentation/pages/cafe_details_page.dart';

class FavoriteCafeTile extends StatelessWidget {
  final CafeEntity cafe;

  const FavoriteCafeTile({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      color: AppColors.surfaceContainerLow,
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.sm),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            cafe.imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          cafe.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${cafe.distance} • ${cafe.deliveryTime}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CafeDetailsPage(cafe: cafe),
            ),
          );
        },
      ),
    );
  }
}
