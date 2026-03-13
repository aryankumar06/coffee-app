import 'package:flutter/material.dart';
import 'cart_screen.dart';

// Color Palette
const Color textPrimary = Color(0xFF4B2E2B); // Dark Chocolate
const Color primaryAccent = Color(0xFF8C5A3C); // Terra Cotta
const Color secondaryAccent = Color(0xFFC08552); // Copper/Tan
const Color backgroundLight = Color(0xFFFFF8F0); // Warm Off-White

class CustomerMenuScreen extends StatefulWidget {
  final String cafeId;
  final int tableNumber;

  const CustomerMenuScreen({
    super.key,
    required this.cafeId,
    required this.tableNumber,
  });

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ["Starters", "Mains", "Desserts", "Beverages"];
  
  // Mock Cart
  Map<String, int> _cart = {};
  
  void _addToCart(String itemId) {
    setState(() {
      _cart[itemId] = (_cart[itemId] ?? 0) + 1;
    });
  }
  
  void _removeFromCart(String itemId) {
    if (_cart.containsKey(itemId) && _cart[itemId]! > 0) {
      setState(() {
        _cart[itemId] = _cart[itemId]! - 1;
        if (_cart[itemId] == 0) {
          _cart.remove(itemId);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "KlubEats Cafe",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: backgroundLight),
            ),
            Text(
              "Table ${widget.tableNumber} • Ordering Menu",
              style: const TextStyle(fontSize: 12, color: primaryAccent),
            ),
          ],
        ),
        backgroundColor: textPrimary,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: backgroundLight),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const CartScreen())
                  );
                },
              ),
              if (_cart.values.fold(0, (a, b) => a + b) > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_cart.values.fold(0, (a, b) => a + b)}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: secondaryAccent,
          indicatorWeight: 4,
          labelColor: backgroundLight,
          unselectedLabelColor: primaryAccent,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: _categories.map((cat) => Tab(text: cat)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((cat) => _buildCategoryList(cat)).toList(),
      ),
      floatingActionButton: _cart.isNotEmpty 
        ? FloatingActionButton.extended(
            backgroundColor: textPrimary,
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const CartScreen())
              );
            },
            icon: const Icon(Icons.shopping_bag, color: backgroundLight),
            label: Text(
              "View Cart (${_cart.values.fold(0, (a, b) => a + b)})", 
              style: const TextStyle(color: backgroundLight, fontWeight: FontWeight.bold)
            ),
          )
        : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCategoryList(String category) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4, // Mock 4 items per category
      itemBuilder: (context, index) {
        String itemId = "${category}_$index";
        bool isVeg = index % 2 == 0;
        int qty = _cart[itemId] ?? 0;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: textPrimary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Stub
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: backgroundLight,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16), 
                      bottomLeft: Radius.circular(16)
                    ),
                    image: const DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/150"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 14,
                              color: isVeg ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "$category Item ${index + 1}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Deliciously cooked to perfection with signature spices.",
                          style: TextStyle(fontSize: 12, color: primaryAccent),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "₹ 250",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textPrimary
                              ),
                            ),
                            
                            // Add/Remove Button
                            qty > 0 
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: secondaryAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 18, color: textPrimary),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => _removeFromCart(itemId),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "$qty", 
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimary)
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 18, color: textPrimary),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => _addToCart(itemId),
                                      ),
                                    ],
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () => _addToCart(itemId),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: backgroundLight,
                                    foregroundColor: textPrimary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: textPrimary.withOpacity(0.5))
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    minimumSize: Size.zero,
                                  ),
                                  child: const Text("ADD"),
                                ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
