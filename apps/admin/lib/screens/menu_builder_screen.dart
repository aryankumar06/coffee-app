import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:typed_data';

// Color Palette
const Color textPrimary = Color(0xFF4B2E2B); // Dark Chocolate
const Color primaryAccent = Color(0xFF8C5A3C); // Terra Cotta
const Color secondaryAccent = Color(0xFFC08552); // Copper/Tan
const Color backgroundLight = Color(0xFFFFF8F0); // Warm Off-White

class MenuItem {
  String name;
  double price;
  bool isVeg;
  String description;
  double discount;
  String offerLabel;

  MenuItem({
    required this.name,
    required this.price,
    this.isVeg = true,
    this.description = "",
    this.discount = 0.0,
    this.offerLabel = "",
  });
}

class MenuCategory {
  String name;
  List<MenuItem> items;

  MenuCategory({required this.name, required this.items});
}

class MenuBuilderScreen extends StatefulWidget {
  const MenuBuilderScreen({super.key});

  @override
  State<MenuBuilderScreen> createState() => _MenuBuilderScreenState();
}

class _MenuBuilderScreenState extends State<MenuBuilderScreen> {
  final List<MenuCategory> _categories = [
    MenuCategory(
      name: "Starters",
      items: [
        MenuItem(
          name: "Crispy Spring Rolls",
          price: 120.0,
          isVeg: true,
          description: "Fresh vegetable spring rolls with sweet chili sauce.",
          discount: 10.0,
          offerLabel: "Best Seller",
        ),
      ],
    ),
  ];

  Future<void> _importCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final Uint8List fileBytes = result.files.single.bytes!;
        final String csvString = utf8.decode(fileBytes);
        final List<List<dynamic>> rowsAsListOfValues =
            const CsvToListConverter().convert(csvString);

        if (rowsAsListOfValues.isNotEmpty) {
          // Assume columns: Category, Name, Price, Veg(Y/N), Description, Discount, OfferLabel
          // Skipping header row 0
          for (int i = 1; i < rowsAsListOfValues.length; i++) {
            final row = rowsAsListOfValues[i];
            if (row.length >= 3) {
              String catName = row[0].toString();
              String name = row[1].toString();
              double price = double.tryParse(row[2].toString()) ?? 0.0;
              bool isVeg = row.length > 3 ? row[3].toString().toUpperCase() == 'Y' : true;
              String description = row.length > 4 ? row[4].toString() : '';
              double discount = row.length > 5 ? double.tryParse(row[5].toString()) ?? 0.0 : 0.0;
              String offerLabel = row.length > 6 ? row[6].toString() : '';

              _addItemToCategory(
                catName,
                MenuItem(
                  name: name,
                  price: price,
                  isVeg: isVeg,
                  description: description,
                  discount: discount,
                  offerLabel: offerLabel,
                ),
              );
            }
          }
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('CSV Imported Successfully', style: TextStyle(color: backgroundLight)), backgroundColor: textPrimary),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error parsing CSV: $e')),
      );
    }
  }

  void _addItemToCategory(String catName, MenuItem item) {
    var category = _categories.where((c) => c.name.toLowerCase() == catName.toLowerCase()).firstOrNull;
    if (category == null) {
      category = MenuCategory(name: catName, items: []);
      _categories.add(category);
    }
    category.items.add(item);
  }

  void _showAddCategoryDialog() {
    TextEditingController catController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundLight,
          title: const Text('Add Category', style: TextStyle(color: textPrimary)),
          content: TextField(
            controller: catController,
            decoration: const InputDecoration(
              hintText: "Category Name (e.g., Desserts)",
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
                if (catController.text.isNotEmpty) {
                  setState(() {
                    _categories.add(MenuCategory(name: catController.text, items: []));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add', style: TextStyle(color: backgroundLight)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('Menu Builder', style: TextStyle(fontWeight: FontWeight.bold, color: backgroundLight)),
        backgroundColor: textPrimary,
        iconTheme: const IconThemeData(color: backgroundLight),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: "Import CSV",
            onPressed: _importCSV,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Save Template",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Template Saved!', style: TextStyle(color: backgroundLight)), backgroundColor: textPrimary)
              );
            },
          ),
        ],
      ),
      body: _categories.isEmpty
          ? const Center(child: Text("No categories added yet.", style: TextStyle(color: textPrimary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildCategorySection(category);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: textPrimary,
        onPressed: _showAddCategoryDialog,
        icon: const Icon(Icons.add, color: backgroundLight),
        label: const Text("Add Category", style: TextStyle(color: backgroundLight)),
      ),
    );
  }

  Widget _buildCategorySection(MenuCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryAccent.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: secondaryAccent.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: const Border(bottom: BorderSide(color: primaryAccent)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: textPrimary),
                  tooltip: "Add Item",
                  onPressed: () {
                    // Quick add mock
                    setState(() {
                      category.items.add(MenuItem(name: "New Item", price: 0.0));
                    });
                  },
                )
              ],
            ),
          ),
          // Items List
          if (category.items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("No items in this category.", style: TextStyle(color: primaryAccent)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: category.items.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: backgroundLight),
              itemBuilder: (context, itemIndex) {
                final item = category.items[itemIndex];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryAccent.withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.fastfood, color: primaryAccent),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimary),
                        ),
                      ),
                      Icon(
                        Icons.circle,
                        size: 14,
                        color: item.isVeg ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("₹${item.price.toStringAsFixed(2)}", style: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                      if (item.offerLabel.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Text(
                            item.offerLabel,
                            style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: primaryAccent, size: 20),
                    onPressed: () {},
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
