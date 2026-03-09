import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final String table;
  final String urgency;
  final String items;
  final String timeElapsed;
  final String imageUrl;
  String status; // 'Queue', 'Active', 'Completed'

  OrderItem({
    required this.id,
    required this.table,
    required this.urgency,
    required this.items,
    required this.timeElapsed,
    required this.imageUrl,
    required this.status,
  });
}

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  String _activeTab = 'Active';

  final List<OrderItem> _allOrders = [
    OrderItem(
      id: '1',
      table: 'Table 04',
      urgency: 'Urgent',
      items: '2x Classic Burger, 1x Truffle Fries, 2x Draft Beer',
      timeElapsed: '14:20',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80',
      status: 'Active',
    ),
    OrderItem(
      id: '2',
      table: 'Table 12',
      urgency: 'Normal',
      items: '1x Pepperoni Pizza Large, 1x Caesar Salad, 4x Coke Zero',
      timeElapsed: '08:45',
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500&q=80',
      status: 'Active',
    ),
    OrderItem(
      id: '3',
      table: 'Table 07',
      urgency: 'Urgent',
      items: '3x BBQ Pork Ribs Full Rack, 3x Mashed Potatoes',
      timeElapsed: '22:10',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80',
      status: 'Queue',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF24A0D);
    const bgLight = Color(0xFFF8F6F5);

    int queueCount = _allOrders.where((o) => o.status == 'Queue').length;
    int activeCount = _allOrders.where((o) => o.status == 'Active').length;
    int completedCount = _allOrders.where((o) => o.status == 'Completed').length;

    List<OrderItem> currentOrders = _allOrders.where((o) => o.status == _activeTab).toList();

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight.withOpacity(0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.receipt_long, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Live Orders',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                const Text('KITCHEN LIVE', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.black54),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Syncing orders...')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _activeTab = 'Queue'),
                  child: _buildTab('Queue ($queueCount)', _activeTab == 'Queue', primaryColor),
                ),
                GestureDetector(
                  onTap: () => setState(() => _activeTab = 'Active'),
                  child: _buildTab('Active ($activeCount)', _activeTab == 'Active', primaryColor),
                ),
                GestureDetector(
                  onTap: () => setState(() => _activeTab = 'Completed'),
                  child: _buildTab('Completed ($completedCount)', _activeTab == 'Completed', primaryColor),
                ),
              ],
            ),
          ),
          
          // Order Cards
          Expanded(
            child: currentOrders.isEmpty
              ? const Center(child: Text('No orders here', style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: currentOrders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = currentOrders[index];
                    return _buildOrderCard(
                      order: order,
                      primaryColor: primaryColor,
                    );
                  },
              ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Tables'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Admin'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 16),
      decoration: BoxDecoration(
        color: Colors.transparent, // Ensure it registers taps easily
        border: Border(
          bottom: BorderSide(
            color: isActive ? primaryColor : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? primaryColor : Colors.grey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required OrderItem order,
    required Color primaryColor,
  }) {
    Color urgencyColor = order.urgency == 'Urgent' ? primaryColor : Colors.grey;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                child: Image.network(
                  order.imageUrl,
                  width: 120,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order.table, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: urgencyColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              order.urgency,
                              style: TextStyle(color: urgencyColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.items,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          const Text('TIME ELAPSED: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          Text(order.timeElapsed, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: order.status == 'Completed' ? Colors.green : primaryColor,
                                shadowColor: (order.status == 'Completed' ? Colors.green : primaryColor).withOpacity(0.4),
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {
                                if (order.status == 'Queue') {
                                  setState(() => order.status = 'Active');
                                } else if (order.status == 'Active') {
                                  setState(() => order.status = 'Completed');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order is already completed!')));
                                }
                              },
                              child: Text(
                                order.status == 'Queue' ? 'START ORDER' : (order.status == 'Completed' ? 'DONE' : 'MARK READY'), 
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.black54),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
