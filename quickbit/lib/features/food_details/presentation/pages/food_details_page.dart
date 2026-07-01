import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/features/home/domain/entities/food_item_entity.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_event.dart';
import 'package:quickbit/features/cart/presentation/bloc/cart_state.dart';
import 'package:quickbit/features/food_details/domain/entities/customization_option.dart';
import 'package:quickbit/features/food_details/presentation/widgets/style_selector.dart';
import 'package:quickbit/features/food_details/presentation/widgets/extras_selector.dart';
import 'package:quickbit/injection_container.dart';

class FoodDetailsPage extends StatefulWidget {
  final FoodItemEntity item;

  const FoodDetailsPage({super.key, required this.item});

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int _quantity = 1;
  String? _selectedStyle;
  final List<CustomizationOption> _selectedExtras = [];

  late final _StyleOptionGroup _styleGroup;
  late final List<CustomizationOption> _extraOptions;

  @override
  void initState() {
    super.initState();
    _initializeOptions();
  }

  void _initializeOptions() {
    // Customize options dynamically based on the item id or name
    if (widget.item.id == 'food_1') {
      // Caramel Macchiato
      _styleGroup = _StyleOptionGroup(
        title: 'Milk Option',
        options: const [
          CustomizationOption(id: 'whole_milk', name: 'Whole Milk', price: 0.0),
          CustomizationOption(id: 'oat_milk', name: 'Oat Milk', price: 0.75),
          CustomizationOption(id: 'almond_milk', name: 'Almond Milk', price: 0.75),
        ],
      );
      _extraOptions = const [
        CustomizationOption(id: 'extra_shot', name: 'Extra Espresso Shot', price: 1.00),
        CustomizationOption(id: 'caramel_drizzle', name: 'Extra Caramel Drizzle', price: 0.50),
      ];
    } else if (widget.item.id == 'food_6') {
      // Double Cheeseburger
      _styleGroup = _StyleOptionGroup(
        title: 'Patty Style',
        options: const [
          CustomizationOption(id: 'medium_well', name: 'Medium Well', price: 0.0),
          CustomizationOption(id: 'well_done', name: 'Well Done', price: 0.0),
        ],
      );
      _extraOptions = const [
        CustomizationOption(id: 'extra_bacon', name: 'Add Smoked Bacon', price: 1.50),
        CustomizationOption(id: 'extra_cheese', name: 'Extra Cheddar Cheese', price: 1.00),
      ];
    } else {
      // Default: Avocado Toast and general breakfast items
      _styleGroup = _StyleOptionGroup(
        title: 'Egg Style',
        options: const [
          CustomizationOption(id: 'poached', name: 'Poached', price: 0.0),
          CustomizationOption(id: 'scrambled', name: 'Scrambled', price: 0.0),
          CustomizationOption(id: 'fried', name: 'Fried Egg', price: 0.0),
        ],
      );
      _extraOptions = const [
        CustomizationOption(id: 'extra_avocado', name: 'Extra Avocado', price: 2.50),
        CustomizationOption(id: 'smoked_salmon', name: 'Smoked Salmon', price: 4.00),
      ];
    }

    _selectedStyle = _styleGroup.options.first.name;
  }

  double get _singleItemPrice {
    double extrasPrice = _selectedExtras.fold(0.0, (sum, opt) => sum + opt.price);
    // Add additional price if style option has a price
    final selectedStyleOpt = _styleGroup.options.firstWhere(
      (opt) => opt.name == _selectedStyle,
      orElse: () => const CustomizationOption(id: '', name: '', price: 0.0),
    );
    return widget.item.price + extrasPrice + selectedStyleOpt.price;
  }

  double get _totalPrice => _singleItemPrice * _quantity;

  void _toggleExtra(CustomizationOption option) {
    setState(() {
      final index = _selectedExtras.indexWhere((opt) => opt.id == option.id);
      if (index >= 0) {
        _selectedExtras.removeAt(index);
      } else {
        _selectedExtras.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<CartBloc>(),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item added to cart successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                // Scrollable Content
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Top Image Banner
                      SliverAppBar(
                        expandedHeight: 280,
                        pinned: true,
                        backgroundColor: AppColors.primary,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                widget.item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                color: Colors.black.withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Details and customization container
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Price Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.item.name,
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.amber, size: 16),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${widget.item.rating} (120+ reviews)',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${widget.item.price.toStringAsFixed(2)}',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.md),

                              // Description
                              Text(
                                'Description',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: AppDimensions.xs),
                              Text(
                                widget.item.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.md),

                              // Ingredients
                              if (widget.item.ingredients.isNotEmpty) ...[
                                Text(
                                  'Ingredients',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: AppDimensions.sm),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 3.5,
                                  ),
                                  itemCount: widget.item.ingredients.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainerLow,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 18),
                                          const SizedBox(width: 8),
                                          Text(
                                            widget.item.ingredients[index],
                                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: AppDimensions.md),
                              ],

                              // Required Style Option Group (e.g. Milk or Egg Style)
                              StyleSelector(
                                title: _styleGroup.title,
                                options: _styleGroup.options,
                                selectedStyle: _selectedStyle,
                                onSelectedStyleChanged: (val) {
                                  setState(() {
                                    _selectedStyle = val;
                                  });
                                },
                              ),
                              const SizedBox(height: AppDimensions.md),

                              // Extras Group
                              ExtrasSelector(
                                extraOptions: _extraOptions,
                                selectedExtras: _selectedExtras,
                                onToggleExtra: _toggleExtra,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Action Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Quantity Stepper
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                            ),
                            SizedBox(
                              width: 24,
                              child: Text(
                                _quantity.toString(),
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.md),

                      // Add to Cart Button
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.primary.withValues(alpha: 0.2),
                            ),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    AddCartItemEvent(
                                      foodItem: widget.item,
                                      quantity: _quantity,
                                      eggStyle: _selectedStyle,
                                      selectedExtras: List.from(_selectedExtras),
                                    ),
                                  );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  const Icon(Icons.shopping_bag_outlined, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Add to Cart  •  \$${_totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }
}

class _StyleOptionGroup {
  final String title;
  final List<CustomizationOption> options;

  _StyleOptionGroup({required this.title, required this.options});
}
