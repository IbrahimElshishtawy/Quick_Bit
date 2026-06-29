import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/dimensions.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'cafe_details_page.dart';

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
                  Icon(Icons.favorite_border, size: 80, color: AppColors.onSurfaceVariant.withOpacity(0.3)),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'No favorites yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurfaceVariant.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap the heart icon on any café to add it here.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant.withOpacity(0.4),
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
            },
          );
        },
      ),
    );
  }
}
