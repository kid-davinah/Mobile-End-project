import 'package:flutter/material.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Food', 'icon': Icons.restaurant, 'color': Color(0xFFF8BBD0), 'expenseCount': 15},
    {'id': '2', 'name': 'Transport', 'icon': Icons.directions_bus, 'color': Color(0xFFCE93D8), 'expenseCount': 8},
    {'id': '3', 'name': 'Groceries', 'icon': Icons.shopping_cart, 'color': Color(0xFFFFF59D), 'expenseCount': 12},
    {'id': '4', 'name': 'Leisure', 'icon': Icons.movie, 'color': Color(0xFFB2EBF2), 'expenseCount': 6},
    {'id': '5', 'name': 'Bills', 'icon': Icons.receipt_long, 'color': Color(0xFFFFCCBC), 'expenseCount': 4},
  ];
  
  final TextEditingController _controller = TextEditingController();
  final List<IconData> _availableIcons = [
    Icons.restaurant, Icons.directions_bus, Icons.shopping_cart, Icons.movie,
    Icons.receipt_long, Icons.home, Icons.school, Icons.work, Icons.fitness_center,
    Icons.medical_services, Icons.phone, Icons.wifi, Icons.electric_bolt
  ];
  final List<Color> _availableColors = [
    Color(0xFFF8BBD0), Color(0xFFCE93D8), Color(0xFFFFF59D), Color(0xFFB2EBF2),
    Color(0xFFFFCCBC), Color(0xFFC8E6C9), Color(0xFFFFE0B2), Color(0xFFE1BEE7)
  ];

  Future<void> _addCategory() async {
    final name = _controller.text.trim();
    if (name.isEmpty || _categories.any((cat) => cat['name'] == name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a unique category name')),
      );
      return;
    }
    
    final newCategory = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'icon': _availableIcons[0],
      'color': _availableColors[0],
      'expenseCount': 0,
    };
    
    setState(() {
      _categories.add(newCategory);
      _controller.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category "$name" added successfully!')),
    );
  }

  Future<void> _editCategory(int index) async {
    _controller.text = _categories[index]['name'];
    IconData selectedIcon = _categories[index]['icon'];
    Color selectedColor = _categories[index]['color'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Category name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 16),
                Text('Choose Icon:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _availableIcons.map((icon) => GestureDetector(
                    onTap: () => setDialogState(() => selectedIcon = icon),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIcon == icon ? Colors.blue.shade100 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: selectedIcon == icon ? Border.all(color: Colors.blue) : null,
                      ),
                      child: Icon(icon, color: selectedIcon == icon ? Colors.blue : Colors.grey),
                    ),
                  )).toList(),
                ),
                SizedBox(height: 16),
                Text('Choose Color:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _availableColors.map((color) => GestureDetector(
                    onTap: () => setDialogState(() => selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                        border: selectedColor == color ? Border.all(color: Colors.black, width: 2) : null,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _controller.clear();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = _controller.text.trim();
                if (newName.isNotEmpty && !_categories.any((cat) => cat['name'] == newName)) {
                  setState(() {
                    _categories[index]['name'] = newName;
                    _categories[index]['icon'] = selectedIcon;
                    _categories[index]['color'] = selectedColor;
                  });
                  Navigator.pop(context);
                  _controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category updated successfully!')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteCategory(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete "${_categories[index]['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _categories.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Category deleted successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8FA),
      appBar: AppBar(
        title: Text('Category Management'),
        backgroundColor: Color(0xFFF8BBD0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Add Category Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Category',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter category name...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _addCategory,
                          icon: Icon(Icons.add),
                          label: Text('Add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF8BBD0),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Categories List
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Categories (${_categories.length})',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: category['color'],
                              radius: 24,
                              child: Icon(
                                category['icon'],
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              category['name'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '${category['expenseCount']} expenses',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editCategory(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCategory(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 