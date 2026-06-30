import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/injection_container.dart';
import 'package:quickbit/features/home/presentation/cubit/home_cubit.dart';
import 'package:quickbit/features/home/presentation/cubit/home_state.dart';
import 'package:quickbit/features/home/domain/entities/cafe_entity.dart';
import 'package:quickbit/features/cafe_details/presentation/widgets/cafe_info_banner.dart';
import 'package:quickbit/features/cafe_details/presentation/widgets/menu_item_card.dart';

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
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final isFav = context.read<HomeCubit>().isFavorite(widget.cafe.id);

            return CustomScrollView(
              slivers: [
                // Sliver Header with cover image
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
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                ),

                // Info Section
                SliverToBoxAdapter(
                  child: CafeInfoBanner(cafe: widget.cafe),
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
            return MenuItemCard(item: item);
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
