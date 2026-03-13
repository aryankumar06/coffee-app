import 'package:flutter/material.dart';

// Color Palette
const Color textPrimary = Color(0xFF4B2E2B); // Dark Chocolate
const Color primaryAccent = Color(0xFF8C5A3C); // Terra Cotta
const Color secondaryAccent = Color(0xFFC08552); // Copper/Tan
const Color backgroundLight = Color(0xFFFFF8F0); // Warm Off-White

class OrderDashboardScreen extends StatefulWidget {
  const OrderDashboardScreen({super.key});

  @override
  State<OrderDashboardScreen> createState() => _OrderDashboardScreenState();
}

class _OrderDashboardScreenState extends State<OrderDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _statuses = ["New", "Preparing", "Served", "Done"];

  // Mock Orders Data
  final List<Map<String, dynamic>> _mockOrders = [
    {
      "id": "#1042",
      "table": 5,
      "status": "New",
      "paymentMethod": "Cash",
      "paymentStatus": "Pending",
      "time": "18:42",
      "total": 525.0,
      "items": [
        {"name": "Crispy Spring Rolls", "qty": 2},
        {"name": "Lemon Iced Tea", "qty": 1},
      ]
    },
    {
      "id": "#1041",
      "table": 12,
      "status": "Preparing",
      "paymentMethod": "Online",
      "paymentStatus": "Paid",
      "time": "18:30",
      "total": 1250.0,
      "items": [
        {"name": "Chicken Tikka Masala", "qty": 1, "note": "Extra spicy"},
        {"name": "Garlic Naan", "qty": 3},
        {"name": "Coke", "qty": 2},
      ]
    },
    {
      "id": "#1040",
      "table": 2,
      "status": "Served",
      "paymentMethod": "Cash",
      "paymentStatus": "Pending",
      "time": "18:15",
      "total": 350.0,
      "items": [
        {"name": "Margherita Pizza", "qty": 1},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateOrderStatus(int orderIndex, String newStatus) {
    setState(() {
      _mockOrders[orderIndex]['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order moved to $newStatus', style: const TextStyle(color: backgroundLight)),
        backgroundColor: textPrimary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _markAsPaid(int orderIndex) {
    setState(() {
      _mockOrders[orderIndex]['paymentStatus'] = 'Paid';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment marked as Collected', style: TextStyle(color: backgroundLight)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  List<Map<String, dynamic>> _getOrdersForStatus(String status) {
    return _mockOrders.where((order) => order['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('Live Orders', style: TextStyle(fontWeight: FontWeight.bold, color: backgroundLight)),
        backgroundColor: textPrimary,
        iconTheme: const IconThemeData(color: backgroundLight),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: backgroundLight),
            onPressed: () {
              // Mock refresh
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: backgroundLight),
            onPressed: () {
              // Open filter drawer/dialog
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: secondaryAccent,
          indicatorWeight: 4,
          labelColor: backgroundLight,
          unselectedLabelColor: primaryAccent,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: _statuses.map((s) {
            int count = _getOrdersForStatus(s).length;
            return Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(s),
                  if (count > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: s == "New" ? Colors.redAccent : secondaryAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: s == "New" ? Colors.white : textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statuses.map((status) => _buildOrderListView(status)).toList(),
      ),
    );
  }

  Widget _buildOrderListView(String status) {
    final orders = _getOrdersForStatus(status);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 60, color: primaryAccent.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              "No $status orders right now.",
              style: const TextStyle(color: textPrimary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        // find original index for state updates
        final originalIndex = _mockOrders.indexWhere((o) => o['id'] == order['id']);
        
        return _buildOrderCard(order, originalIndex);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, int originalIndex) {
    final bool isPaid = order['paymentStatus'] == 'Paid';
    final bool isOnline = order['paymentMethod'] == 'Online';
    final String currentStatus = order['status'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: currentStatus == "New" ? Colors.redAccent.withOpacity(0.5) : primaryAccent.withOpacity(0.3),
          width: currentStatus == "New" ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: secondaryAccent.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(bottom: BorderSide(color: primaryAccent)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: textPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Table ${order['table']}",
                        style: const TextStyle(color: backgroundLight, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(order['id'], style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: primaryAccent),
                    const SizedBox(width: 4),
                    Text(order['time'], style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          
          // Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Order Items", style: TextStyle(color: primaryAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...List.generate(order['items'].length, (i) {
                  final item = order['items'][i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: backgroundLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("${item['qty']}x", style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'], style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                              if (item['note'] != null)
                                Text('Note: ${item['note']}', style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                
                const Divider(color: backgroundLight, thickness: 1.5, height: 24),
                
                // Payment Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Payment", style: TextStyle(color: primaryAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(isOnline ? Icons.credit_card : Icons.money, size: 16, color: textPrimary),
                            const SizedBox(width: 4),
                            Text(
                              "${order['paymentMethod']} • ", 
                              style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold)
                            ),
                            Text(
                              order['paymentStatus'], 
                              style: TextStyle(
                                color: isPaid ? Colors.green : Colors.orange, 
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Total", style: TextStyle(color: primaryAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          "₹${order['total'].toStringAsFixed(2)}",
                          style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: backgroundLight,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              children: [
                if (!isPaid && order['paymentMethod'] == 'Cash')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _markAsPaid(originalIndex),
                      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                      label: const Text("Collected", style: TextStyle(color: Colors.green)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                if (!isPaid && order['paymentMethod'] == 'Cash')
                  const SizedBox(width: 12),
                
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      String nextStatus = "Done";
                      if (currentStatus == "New") nextStatus = "Preparing";
                      else if (currentStatus == "Preparing") nextStatus = "Served";
                      else if (currentStatus == "Served") nextStatus = "Done";
                      
                      if (currentStatus != "Done") {
                        _updateOrderStatus(originalIndex, nextStatus);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentStatus == "Done" ? primaryAccent : textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      currentStatus == "New" ? "Start Preparing" :
                      currentStatus == "Preparing" ? "Mark as Served" :
                      currentStatus == "Served" ? "Complete Order" : "Order Completed",
                      style: const TextStyle(color: backgroundLight, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
