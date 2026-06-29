import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../injection_container.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../entities/cafe_entity.dart';
import '../entities/food_item_entity.dart';
import 'food_details_page.dart';

class CafeDetailsPage extends StatefulWidget {
  final CafeEntity cafe;

  const CafeDetailsPage({super.key, required this.cafe});

  @override
  State<CafeDetailsPage> createState() => _CafeDetailsPageState();
}

class _CafeDetailsPageState extends State<CafeDetailsPage> {
  late HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<HomeCubit>()..fetchMenu(widget.cafe);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final isFav = context.read<HomeCubit>().isFavorite(widget.cafe.id);

            return CustomScrollView(
              slivers: [
                // Silver Header with cover image
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        context.read<HomeCubit>().toggleFavorite(widget.cafe.id);
                        setState(() {}); // Re-render action button state
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.cafe.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        // Dark overlay for visibility
                        Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),

                // Info Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cafe.name,
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
                                    widget.cafe.rating.toString(),
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
                                Text(widget.cafe.distance),
                              ],
                            ),
                            const SizedBox(width: AppDimensions.md),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 18, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 2),
                                Text(widget.cafe.deliveryTime),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          widget.cafe.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Wrap(
                          spacing: AppDimensions.sm,
                          children: widget.cafe.tags.map((tag) {
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
                  ),
                ),

                // Menu Items List
                _buildMenuList(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuList(HomeState state) {
    if (state is HomeMenuLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    } else if (state is HomeMenuLoaded) {
      final items = state.menuItems;
      if (items.isEmpty) {
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.lg),
            child: Center(child: Text('No food items available.')),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
            return _MenuFoodListItem(item: item);
          },
          childCount: items.length,
        ),
      );
    } else if (state is HomeError) {
      return SliverFillRemaining(
        child: Center(child: Text(state.message)),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}

class _MenuFoodListItem extends StatelessWidget {
  final FoodItemEntity item;

  const _MenuFoodListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FoodDetailsPage(item: item),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.sm,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x04000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              // Image Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fastfood, size: 40, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: AppDimensions.md),

              // Title and Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant.withOpacity(0.7),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.outlineVariant),
            ],
          ),
        ),
      ),
    );
  }
}
