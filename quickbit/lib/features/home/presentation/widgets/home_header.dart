import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/home/presentation/cubit/home_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Header: Location & Profile
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Student Union',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 18),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Campus Dining Hall',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_none, color: AppColors.primary),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for cafes or food...',
                prefixIcon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6)),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),

        // Categories list
        const _CategoryChipsList(),
      ],
    );
  }
}

class _CategoryChipsList extends StatefulWidget {
  const _CategoryChipsList();

  @override
  State<_CategoryChipsList> createState() => _CategoryChipsListState();
}

class _CategoryChipsListState extends State<_CategoryChipsList> {
  final List<String> _categories = ['All', 'Coffee', 'Healthy', 'Burgers', 'Bakery'];
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.sm),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                context.read<HomeCubit>().filterByTag(category);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
