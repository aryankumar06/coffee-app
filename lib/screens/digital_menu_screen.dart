import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final bool isPopular;
  final String category;
  int quantity;

  MenuItem({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.isPopular = false,
    required this.category,
    this.quantity = 0,
  });
}

class DigitalMenuScreen extends StatefulWidget {
  const DigitalMenuScreen({super.key});

  @override
  State<DigitalMenuScreen> createState() => _DigitalMenuScreenState();
}

class _DigitalMenuScreenState extends State<DigitalMenuScreen> {
  String _activeCategory = 'Appetizers';

  final List<String> _categories = ['Appetizers', 'Mains', 'Drinks', 'Desserts'];

  final List<MenuItem> _allMenuItems = [
    MenuItem(
      title: 'Truffle Fries',
      price: 12.0,
      description: 'Golden crispy fries drizzled with authentic Italian truffle oil and parmesan flakes.',
      imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=500&q=80',
      isPopular: true,
      category: 'Appetizers',
    ),
    MenuItem(
      title: 'Bruschetta',
      price: 10.0,
      description: 'Toasted sourdough topped with diced vine-ripened tomatoes, fresh basil, and balsamic glaze.',
      imageUrl: 'https://images.unsplash.com/photo-1572695157366-5e585e505504?w=500&q=80',
      category: 'Appetizers',
    ),
    MenuItem(
      title: 'Calamari Fritti',
      price: 15.0,
      description: 'Lightly battered sustainable squid rings served with spicy house-made marinara sauce.',
      imageUrl: 'https://images.unsplash.com/photo-1599487405270-b088e5d0f1eb?w=500&q=80',
      category: 'Appetizers',
    ),
    MenuItem(
      title: 'Ribeye Steak',
      price: 32.0,
      description: 'Juicy 12oz ribeye grilled to perfection, served with asparagus.',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80',
      isPopular: true,
      category: 'Mains',
    ),
    MenuItem(
      title: 'Coca Cola',
      price: 4.0,
      description: 'Classic chilled cola with ice.',
      imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500&q=80',
      category: 'Drinks',
    ),
  ];

  int get _totalItems => _allMenuItems.fold(0, (sum, item) => sum + item.quantity);
  double get _totalPrice => _allMenuItems.fold(0, (sum, item) => sum + (item.quantity * item.price));

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF24A0D);
    const bgLight = Color(0xFFF8F6F5);

    List<MenuItem> currentItems = _allMenuItems.where((item) => item.category == _activeCategory).toList();

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight.withOpacity(0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text('Table 12', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Ordering Live', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Categories
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeCategory = cat;
                        });
                      },
                      child: _buildTab(cat, cat == _activeCategory, primaryColor),
                    );
                  },
                ),
              ),
              
              // Menu Items List
              Expanded(
                child: currentItems.isEmpty 
                    ? const Center(child: Text('No items in this category yet.', style: TextStyle(color: Colors.grey)))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120), // extra padding for FAB
                        itemCount: currentItems.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = currentItems[index];
                          return _buildMenuItem(
                            item: item,
                            primaryColor: primaryColor,
                          );
                        },
                      ),
              ),
            ],
          ),

          // Floating Action Button
          if (_totalItems > 0)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Proceeding to checkout with $_totalItems items!')),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shopping_cart, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('View Cart ($_totalItems items)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('\$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? primaryColor : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 40,
            color: isActive ? primaryColor : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required MenuItem item,
    required Color primaryColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 96,
                  height: 96,
                  color: Colors.grey[300],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                    ),
                    Text('\$${item.price.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item.isPopular)
                      Row(
                        children: [
                          Icon(Icons.workspace_premium, color: primaryColor, size: 16),
                          const SizedBox(width: 4),
                          Text('POPULAR', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    
                    if (item.quantity > 0)
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.quantity--;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                child: Icon(Icons.remove, size: 20, color: primaryColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.quantity++;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(6)),
                                child: const Icon(Icons.add, size: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            item.quantity++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Add to Cart', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
