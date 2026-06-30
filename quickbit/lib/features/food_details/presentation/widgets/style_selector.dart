import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/food_details/domain/entities/customization_option.dart';

class StyleSelector extends StatelessWidget {
  final String title;
  final List<CustomizationOption> options;
  final String? selectedStyle;
  final ValueChanged<String?> onSelectedStyleChanged;

  const StyleSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selectedStyle,
    required this.onSelectedStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Required',
                style: TextStyle(
                  color: AppColors.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        ...options.map((option) {
          final isSelected = selectedStyle == option.name;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: RadioListTile<String>(
              title: Text(
                option.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              value: option.name,
              groupValue: selectedStyle,
              activeColor: AppColors.primary,
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: onSelectedStyleChanged,
            ),
          );
        }),
      ],
    );
  }
}
