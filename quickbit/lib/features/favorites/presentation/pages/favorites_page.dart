import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/home/presentation/cubit/home_cubit.dart';
import 'package:quickbit/features/home/presentation/cubit/home_state.dart';
import 'package:quickbit/features/favorites/presentation/widgets/favorite_cafe_tile.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          final favorites = cubit.getFavoriteCafes();

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'No favorites yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap the heart icon on any café to add it here.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.lg),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final cafe = favorites[index];
              return FavoriteCafeTile(cafe: cafe);
            },
          );
        },
      ),
    );
  }
}
