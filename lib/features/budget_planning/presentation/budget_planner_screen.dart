import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetPlannerScreen extends StatefulWidget {
  const BudgetPlannerScreen({Key? key}) : super(key: key);

  @override
  State<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'color': Color(0xFFF8BBD0), 'icon': Icons.restaurant, 'budget': 200.0},
    {'name': 'Transport', 'color': Color(0xFFCE93D8), 'icon': Icons.directions_bus, 'budget': 100.0},
    {'name': 'Groceries', 'color': Color(0xFFFFF59D), 'icon': Icons.shopping_cart, 'budget': 150.0},
    {'name': 'Leisure', 'color': Color(0xFFB2EBF2), 'icon': Icons.movie, 'budget': 80.0},
    {'name': 'Bills', 'color': Color(0xFFFFCCBC), 'icon': Icons.receipt_long, 'budget': 120.0},
  ];

  double get _totalBudget => _categories.fold(0.0, (sum, cat) => sum + (cat['budget'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        title: const Text('Budget Planner'),
        backgroundColor: const Color(0xFFF8BBD0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFFF8BBD0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Monthly Budget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      NumberFormat.simpleCurrency().format(_totalBudget),
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text('Set Category Budgets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return Card(
                    color: cat['color'],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(cat['icon'], color: cat['color']),
                              ),
                              const SizedBox(width: 12),
                              Text(cat['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Text(
                                NumberFormat.simpleCurrency().format(cat['budget']),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Slider(
                            value: cat['budget'],
                            min: 0,
                            max: 500,
                            divisions: 100,
                            label: NumberFormat.simpleCurrency().format(cat['budget']),
                            onChanged: (val) {
                              setState(() => cat['budget'] = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Budgets saved (demo only)!')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Budgets'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8BBD0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 