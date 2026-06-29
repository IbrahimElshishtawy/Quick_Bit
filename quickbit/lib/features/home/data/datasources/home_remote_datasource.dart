import '../../../../core/network/api_client.dart';
import '../models/cafe_model.dart';
import '../models/food_item_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CafeModel>> getCafes();
  Future<List<FoodItemModel>> getMenu(String cafeId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);

  // High quality food image URLs from Unsplash for realistic design
  static const String _coffeeImg = 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=600&auto=format&fit=crop';
  static const String _pastryImg = 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=600&auto=format&fit=crop';
  static const String _burgerImg = 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=600&auto=format&fit=crop';
  static const String _healthyImg = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=600&auto=format&fit=crop';

  final List<CafeModel> _mockCafes = [
    const CafeModel(
      id: 'cafe_1',
      name: 'The Daily Grind',
      imageUrl: _coffeeImg,
      rating: 4.8,
      distance: '0.2 miles',
      deliveryTime: '5-10 min',
      description: 'Artisanal coffee and fresh pastries located in the Student Union.',
      tags: ['Coffee', 'Bakery', 'Breakfast'],
    ),
    const CafeModel(
      id: 'cafe_2',
      name: 'Bite-Sized Bistro',
      imageUrl: _healthyImg,
      rating: 4.5,
      distance: '0.4 miles',
      deliveryTime: '10-15 min',
      description: 'Healthy sandwiches, gourmet salads, and fresh smoothies.',
      tags: ['Salads', 'Sandwiches', 'Healthy'],
    ),
    const CafeModel(
      id: 'cafe_3',
      name: 'Varsity Burgers',
      imageUrl: _burgerImg,
      rating: 4.6,
      distance: '0.5 miles',
      deliveryTime: '12-18 min',
      description: 'Flame-grilled burgers and crispy fries for the ultimate game day fuel.',
      tags: ['Burgers', 'Fries', 'Fast Food'],
    ),
    const CafeModel(
      id: 'cafe_4',
      name: 'Green & Lean',
      imageUrl: _pastryImg,
      rating: 4.7,
      distance: '0.3 miles',
      deliveryTime: '8-12 min',
      description: 'A dedicated clean eating cafe offering organic and vegan-friendly meals.',
      tags: ['Vegan', 'Organic', 'Bowls'],
    ),
  ];

  final List<FoodItemModel> _mockFoodItems = [
    // Cafe 1 items
    const FoodItemModel(
      id: 'food_1',
      name: 'Caramel Macchiato',
      description: 'Rich espresso, steamed milk, and sweet vanilla syrup topped with buttery caramel drizzle.',
      price: 4.75,
      imageUrl: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?q=80&w=500&auto=format&fit=crop',
      cafeId: 'cafe_1',
      rating: 4.9,
      ingredients: ['Espresso', 'Whole Milk', 'Caramel Drizzle', 'Vanilla Syrup'],
    ),
    const FoodItemModel(
      id: 'food_2',
      name: 'Chocolate Croissant',
      description: 'Flaky, buttery puff pastry filled with rich, semi-sweet dark chocolate.',
      price: 3.50,
      imageUrl: 'https://images.unsplash.com/photo-1549778399-f94fd24d68f5?q=80&w=500&auto=format&fit=crop',
      cafeId: 'cafe_1',
      rating: 4.7,
      ingredients: ['Butter', 'Flour', 'Dark Chocolate'],
    ),
    const FoodItemModel(
      id: 'food_3',
      name: 'Avocado Toast Extra',
      description: 'Fresh mashed avocado on toasted sourdough with cherry tomatoes and feta cheese.',
      price: 6.80,
      imageUrl: 'https://images.unsplash.com/photo-1541532713592-79a0317b6b77?q=80&w=500&auto=format&fit=crop',
      cafeId: 'cafe_1',
      rating: 4.5,
      ingredients: ['Sourdough', 'Avocado', 'Cherry Tomatoes', 'Feta Cheese'],
    ),

    // Cafe 2 items
    const FoodItemModel(
      id: 'food_4',
      name: 'Quinoa Buddha Bowl',
      description: 'Warm organic quinoa, roasted sweet potatoes, avocado, spinach, and tahini dressing.',
      price: 9.50,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop',
      cafeId: 'cafe_2',
      rating: 4.8,
      ingredients: ['Organic Quinoa', 'Sweet Potato', 'Avocado', 'Spinach', 'Tahini'],
    ),
    const FoodItemModel(
      id: 'food_5',
      name: 'Gourmet Caesar Salad',
      description: 'Crisp romaine lettuce, garlic croutons, parmesan flakes, and grilled chicken breast.',
      price: 8.50,
      imageUrl: 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?q=80&w=500&auto=format&fit=crop',
      cafeId: 'cafe_2',
      rating: 4.6,
      ingredients: ['Romaine Lettuce', 'Grilled Chicken', 'Parmesan', 'Croutons', 'Caesar Dressing'],
    ),

    // Cafe 3 items
    const FoodItemModel(
      id: 'food_6',
      name: 'Double Cheeseburger',
      description: 'Two smashed beef patties, cheddar cheese, pickles, and Varsity special sauce on a brioche bun.',
      price: 10.50,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500&auto=format&fit=crop',
      cafeId: 'cafe_3',
      rating: 4.8,
      ingredients: ['Double Beef Patty', 'Cheddar Cheese', 'Pickles', 'Brioche Bun', 'Varsity Sauce'],
    ),
    const FoodItemModel(
      id: 'food_7',
      name: 'Sweet Potato Fries',
      description: 'Crispy sweet potato fries seasoned with sea salt and served with spicy chipotle mayo.',
      price: 4.25,
      imageUrl: 'https://images.unsplash.com/photo-1585109649139-366815a0d713?q=80&w=500&auto=format&fit=crop',
      cafeId: 'cafe_3',
      rating: 4.6,
      ingredients: ['Sweet Potatoes', 'Sea Salt', 'Chipotle Mayo'],
    ),
  ];

  @override
  Future<List<CafeModel>> getCafes() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate delay
    return _mockCafes;
  }

  @override
  Future<List<FoodItemModel>> getMenu(String cafeId) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate delay
    return _mockFoodItems.where((item) => item.cafeId == cafeId).toList();
  }
}
