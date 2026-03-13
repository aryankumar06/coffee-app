import 'package:flutter/material.dart';

// Color Palette
const Color textPrimary = Color(0xFF4B2E2B); // Dark Chocolate
const Color primaryAccent = Color(0xFF8C5A3C); // Terra Cotta
const Color secondaryAccent = Color(0xFFC08552); // Copper/Tan
const Color backgroundLight = Color(0xFFFFF8F0); // Warm Off-White

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Mock cart items
  List<Map<String, dynamic>> _cartItems = [
    {
      "id": "item_1",
      "name": "Crispy Spring Rolls",
      "price": 120.0,
      "quantity": 2,
      "isVeg": true,
      "note": "",
    },
    {
      "id": "item_2",
      "name": "Chicken Tikka Masala",
      "price": 350.0,
      "quantity": 1,
      "isVeg": false,
      "note": "Extra spicy please",
    }
  ];

  double _getCartSubtotal() {
    return _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      int newQty = _cartItems[index]['quantity'] + delta;
      if (newQty > 0) {
        _cartItems[index]['quantity'] = newQty;
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  void _showAddNoteDialog(int index) {
    TextEditingController _noteController = TextEditingController(text: _cartItems[index]['note']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundLight,
          title: const Text('Add Cooking Note', style: TextStyle(color: textPrimary)),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: "e.g., No onions, extra spicy",
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textPrimary)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: textPrimary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: textPrimary),
              onPressed: () {
                setState(() {
                  _cartItems[index]['note'] = _noteController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: backgroundLight)),
            ),
          ],
        );
      },
    );
  }

  void _checkoutItem(String method) {
    // Show confirmation modal based on method
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: backgroundLight,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Order Placed!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
              ),
              const SizedBox(height: 10),
              Text(
                method == "cash" 
                  ? "We've received your order. You can pay with cash after eating."
                  : "Payment successful via Razorpay. Generating your order.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: textPrimary, fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: textPrimary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to menu
                  // In reality: route to an "Order Status" tracker instead 
                },
                child: const Text("Back to Menu", style: TextStyle(color: backgroundLight, fontSize: 16)),
              )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = _getCartSubtotal();
    double taxes = subtotal * 0.05; // 5% GST
    double total = subtotal + taxes;

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(fontWeight: FontWeight.bold, color: backgroundLight)),
        backgroundColor: textPrimary,
        iconTheme: const IconThemeData(color: backgroundLight),
      ),
      body: _cartItems.isEmpty 
        ? const Center(
            child: Text(
              "Your cart is empty", 
              style: TextStyle(fontSize: 18, color: textPrimary, fontWeight: FontWeight.bold)
            )
          )
        : Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryAccent.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: textPrimary.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 14,
                                color: item['isVeg'] ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary
                                  ),
                                ),
                              ),
                              Text(
                                "₹${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Note Button
                              TextButton.icon(
                                onPressed: () => _showAddNoteDialog(index),
                                icon: Icon(
                                  item['note'].toString().isEmpty ? Icons.note_add : Icons.edit_note,
                                  color: primaryAccent,
                                  size: 18,
                                ),
                                label: Text(
                                  item['note'].toString().isEmpty ? "Add Note" : "Edit Note",
                                  style: const TextStyle(color: primaryAccent, fontSize: 12),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              
                              // Quantity Adjuster
                              Container(
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
                                      onPressed: () => _updateQuantity(index, -1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        "${item['quantity']}", 
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimary)
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 18, color: textPrimary),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _updateQuantity(index, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          // Display Note if exists
                          if (item['note'].toString().isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.comment, size: 14, color: textPrimary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '"${item['note']}"',
                                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: textPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Summary & Checkout Area
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: textPrimary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    )
                  ]
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subtotal", style: TextStyle(color: primaryAccent, fontSize: 16)),
                        Text("₹${subtotal.toStringAsFixed(2)}", style: const TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Taxes (5%)", style: TextStyle(color: primaryAccent, fontSize: 16)),
                        Text("₹${taxes.toStringAsFixed(2)}", style: const TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: backgroundLight, thickness: 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("₹${total.toStringAsFixed(2)}", style: const TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Payment Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: textPrimary, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _checkoutItem('cash'),
                            child: const Column(
                              children: [
                                Icon(Icons.restaurant, color: textPrimary, size: 24),
                                SizedBox(height: 4),
                                Text("Pay Later\n(Cash)", textAlign: TextAlign.center, style: TextStyle(color: textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: textPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: () => _checkoutItem('online'),
                            child: const Column(
                              children: [
                                Icon(Icons.payment, color: backgroundLight, size: 24),
                                SizedBox(height: 4),
                                Text("Pay Now\n(Online)", textAlign: TextAlign.center, style: TextStyle(color: backgroundLight, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
    );
  }
}
