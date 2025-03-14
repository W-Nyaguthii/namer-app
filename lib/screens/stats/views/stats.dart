import 'package:flutter/material.dart';
import 'package:namer_app/screens/stats/views/chart.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Load transactions from your database or storage
  Future<void> _loadTransactions() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Replace this with your actual transaction fetching logic
      // For now, i used sample data that matches the home screen
      transactions = [
        Transaction(
          category: 'House',
          amount: 800.00,
          isExpense: false, // Income
          date: '11/03/2025',
          icon: Icons.home,
        ),
        Transaction(
          category: 'House',
          amount: 10.00,
          isExpense: true, // Expense
          date: '09/03/2025',
          icon: Icons.home,
        ),
        // Add more transactions if needed
      ];
    } catch (e) {
      // Handle any errors
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : transactions.isEmpty
                      ? const Center(child: Text('No transactions found'))
                      : Padding(
                          padding: const EdgeInsets.all(16),
                          child: MyChart(transactions: transactions),
                        ),
            ),

            // Categories list
            const SizedBox(height: 20),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : transactions.isEmpty
                      ? const Center(child: Text('No categories found'))
                      : buildCategoriesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoriesList() {
    // Group transactions by category and calculate totals
    final categoryTotals = <String, double>{};

    for (var transaction in transactions) {
      final category = transaction.category;
      final amount = transaction.amount.abs();

      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
      } else {
        categoryTotals[category] = amount;
      }
    }

    // Convert to list and sort by amount (optional)
    final categories = categoryTotals.entries.toList();
    categories.sort((a, b) => b.value.compareTo(a.value));

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index].key;
        final amount = categories[index].value;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: getColorForCategory(category),
            child: Text('0${index + 1}'),
          ),
          title: Text(category),
          subtitle: Text(
            getCategoryTransactionCount(category),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  String getCategoryTransactionCount(String category) {
    final count = transactions.where((t) => t.category == category).length;
    return '$count transaction${count == 1 ? '' : 's'}';
  }

  Color getColorForCategory(String category) {
    final colorMap = {
      'House': const Color(0xFF5cbdb9),
      'Food': Colors.red,
      'Transport': Colors.green,
      'Entertainment': Colors.purple,
      'Shopping': Colors.amber,
      'Health': Colors.pink,
      'Utilities': Colors.teal,
      'Job': Colors.blue,
    };

    return colorMap[category] ?? Colors.grey;
  }
}
