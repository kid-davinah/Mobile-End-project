import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final List<Map<String, dynamic>> _expenses = [
    {
      'id': '1',
      'amount': 25.50,
      'category': 'Food',
      'categoryIcon': Icons.restaurant,
      'categoryColor': Color(0xFFF8BBD0),
      'note': 'Lunch at cafe',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '2',
      'amount': 10.00,
      'category': 'Transport',
      'categoryIcon': Icons.directions_bus,
      'categoryColor': Color(0xFFCE93D8),
      'note': 'Bus ticket',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '3',
      'amount': 45.99,
      'category': 'Groceries',
      'categoryIcon': Icons.shopping_cart,
      'categoryColor': Color(0xFFFFF59D),
      'note': 'Weekly groceries',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  void _addExpense(Map<String, dynamic> expense) {
    setState(() {
      _expenses.insert(0, expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense added!')),
    );
  }

  void _showAddExpenseSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddExpenseSheet(onAdd: _addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: const Color(0xFFF8BBD0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _expenses.isEmpty
          ? const Center(child: Text('No expenses found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return Card(
                  color: expense['categoryColor'],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(expense['categoryIcon'], color: expense['categoryColor']),
                    ),
                    title: Text(
                      expense['category'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      expense['note'],
                      style: const TextStyle(color: Colors.black87),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormat.simpleCurrency().format(expense['amount']),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat.yMMMd().format(expense['date']),
                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF8BBD0),
        foregroundColor: Colors.white,
        onPressed: _showAddExpenseSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddExpenseSheet extends StatefulWidget {
  final void Function(Map<String, dynamic>) onAdd;
  const AddExpenseSheet({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  IconData? _selectedCategoryIcon;
  Color? _selectedCategoryColor;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Color(0xFFF8BBD0)},
    {'name': 'Transport', 'icon': Icons.directions_bus, 'color': Color(0xFFCE93D8)},
    {'name': 'Groceries', 'icon': Icons.shopping_cart, 'color': Color(0xFFFFF59D)},
    {'name': 'Leisure', 'icon': Icons.movie, 'color': Color(0xFFB2EBF2)},
    {'name': 'Bills', 'icon': Icons.receipt_long, 'color': Color(0xFFFFCCBC)},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return;
    final expense = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'amount': double.parse(_amountController.text),
      'category': _selectedCategory!,
      'categoryIcon': _selectedCategoryIcon!,
      'categoryColor': _selectedCategoryColor!,
      'note': _noteController.text,
      'date': _selectedDate,
    };
    widget.onAdd(expense);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Expense', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter amount';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat['name'],
                    child: Row(
                      children: [
                        Icon(cat['icon'], color: cat['color']),
                        const SizedBox(width: 8),
                        Text(cat['name']),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  final cat = _categories.firstWhere((c) => c['name'] == value);
                  setState(() {
                    _selectedCategory = value;
                    _selectedCategoryIcon = cat['icon'];
                    _selectedCategoryColor = cat['color'];
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value == null ? 'Select category' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text('Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8BBD0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 