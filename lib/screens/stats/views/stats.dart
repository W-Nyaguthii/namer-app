import 'package:flutter/material.dart';
import 'package:namer_app/screens/stats/views/chart.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  // Sample transaction data
  List<Transaction> getTransactions() {
    return [
      Transaction(
        category: 'Job',
        amount: 800.00,
        isExpense: false,
        date: '08/03/2025',
      ),
      Transaction(
        category: 'food',
        amount: 30.00,
        isExpense: true,
        date: '08/03/2025',
      ),
      Transaction(
        category: 'rent',
        amount: 400.00,
        isExpense: true,
        date: '08/02/2025',
      ),
      Transaction(
        category: 'transport',
        amount: 45.00,
        isExpense: true,
        date: '08/01/2025',
      ),
      Transaction(
        category: 'entertainment',
        amount: 60.00,
        isExpense: true,
        date: '08/01/2025',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final transactions = getTransactions();

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
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MyChart(transactions: transactions),
              ),
            ),

            // Optionally add a legend or transaction list below
            const SizedBox(height: 20),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.where((t) => t.isExpense).length,
                itemBuilder: (context, index) {
                  final expensesList =
                      transactions.where((t) => t.isExpense).toList();
                  final transaction = expensesList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          getColorForCategory(transaction.category),
                      child: Text('0${index + 1}'),
                    ),
                    title: Text(transaction.category),
                    trailing:
                        Text('\$${transaction.amount.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorForCategory(String category) {
    final colorMap = {
      'food': Colors.red,
      'rent': Colors.blue,
      'transport': Colors.green,
      'entertainment': Colors.purple,
      'groceries': Colors.orange,
      'utilities': Colors.teal,
      'shopping': Colors.amber,
      'health': Colors.pink,
    };

    return colorMap[category] ?? Colors.grey;
  }
}
