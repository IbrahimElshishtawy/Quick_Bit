import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/food_details/domain/entities/customization_option.dart';

class ExtrasSelector extends StatelessWidget {
  final List<CustomizationOption> extraOptions;
  final List<CustomizationOption> selectedExtras;
  final ValueChanged<CustomizationOption> onToggleExtra;

  const ExtrasSelector({
    super.key,
    required this.extraOptions,
    required this.selectedExtras,
    required this.onToggleExtra,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Extras',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimensions.sm),
        ...extraOptions.map((option) {
          final isSelected = selectedExtras.any((opt) => opt.id == option.id);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CheckboxListTile(
              title: Text(
                option.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '+\$${option.price.toStringAsFixed(2)}',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              value: isSelected,
              activeColor: AppColors.primary,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (_) => onToggleExtra(option),
            ),
          );
        }),
      ],
    );
  }
}
