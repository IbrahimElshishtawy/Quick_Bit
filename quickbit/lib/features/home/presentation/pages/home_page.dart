import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/injection_container.dart';
import 'package:quickbit/features/home/presentation/cubit/home_cubit.dart';
import 'package:quickbit/features/home/presentation/cubit/home_state.dart';
import 'package:quickbit/features/home/presentation/widgets/home_header.dart';
import 'package:quickbit/features/home/presentation/widgets/cafe_card.dart';
import 'package:quickbit/features/cafe_details/presentation/pages/cafe_details_page.dart';
import 'package:quickbit/features/favorites/presentation/pages/favorites_page.dart';
import 'package:quickbit/features/cart/presentation/pages/cart_page.dart';
import 'package:quickbit/features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..fetchCafes(),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const _HomeBodyView(),
            const CartPage(),
            const FavoritesPage(),
            const ProfilePage(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBodyView extends StatelessWidget {
  const _HomeBodyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: AppDimensions.md),

            // Cafe list header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              child: Text(
                'Campus Cafés',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),

            // Cafe Cards List
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  } else if (state is HomeError) {
                    return Center(child: Text(state.message));
                  } else if (state is HomeLoaded) {
                    final cafes = state.filteredCafes;
                    if (cafes.isEmpty) {
                      return const Center(child: Text('No cafes found for this category.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                      itemCount: cafes.length,
                      itemBuilder: (context, index) {
                        return CafeCard(cafe: cafes[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
