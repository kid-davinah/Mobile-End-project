import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pastelColors = [
      const Color(0xFFF8BBD0), // Pink
      const Color(0xFFCE93D8), // Purple
      const Color(0xFFFFF59D), // Pastel Yellow
      const Color(0xFFB2EBF2), // Pastel Blue
      const Color(0xFFFFCCBC), // Peach
    ];
    final iconMap = {
      'Food': Icons.restaurant,
      'Transport': Icons.directions_bus,
      'Groceries': Icons.shopping_cart,
      'Leisure': Icons.movie,
      'Bills': Icons.receipt_long,
    };
    // In-memory demo data
    final double totalSpent = 1234.56;
    final List<Map<String, dynamic>> topCategories = [
      {'category': 'Food', 'total': 500.0},
      {'category': 'Transport', 'total': 300.0},
      {'category': 'Groceries', 'total': 200.0},
    ];
    final List<Map<String, dynamic>> barChartData = [
      {'category': 'Food', 'total': 500.0},
      {'category': 'Transport', 'total': 300.0},
      {'category': 'Groceries', 'total': 200.0},
      {'category': 'Leisure', 'total': 150.0},
      {'category': 'Bills', 'total': 84.56},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: pastelColors[0],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Greeting
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Welcome back! Here\'s your spending summary:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          // Total Spent Card
          Card(
            color: pastelColors[0],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Spent This Month', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    '\$${totalSpent.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Top Categories Card
          Card(
            color: pastelColors[1],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      const Text('Top 3 Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...topCategories.map((cat) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: pastelColors[2],
                                  child: Icon(iconMap[cat['category']] ?? Icons.category, color: Colors.deepPurple),
                                ),
                                const SizedBox(width: 12),
                                Text(cat['category']?.toString() ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$${(cat['total'] as num).toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.deepPurple),
                                  onPressed: () {}, // Placeholder for View Details
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Bar Chart Card
          Card(
            color: pastelColors[2],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bar_chart, color: Colors.amber),
                      const SizedBox(width: 8),
                      const Text('Spending by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= barChartData.length) return const SizedBox.shrink();
                                return Text(barChartData[idx]['category'].toString(), style: const TextStyle(fontSize: 13));
                              },
                              reservedSize: 40,
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        barGroups: [
                          for (int i = 0; i < barChartData.length; i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: (barChartData[i]['total'] as num).toDouble(),
                                  color: pastelColors[i % pastelColors.length],
                                  width: 28,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/expenses'),
                  child: const Text('Expenses'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/budget'),
                  child: const Text('Budget'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/settings'),
                  child: const Text('Settings'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/categories'),
                  child: const Text('Categories'),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: pastelColors[0],
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
} 