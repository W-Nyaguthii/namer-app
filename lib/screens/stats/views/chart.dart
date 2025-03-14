import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Transaction model
class Transaction {
  final String category;
  final double amount;
  final bool isExpense;
  final String date;
  final IconData? icon;

  Transaction({
    required this.category,
    required this.amount,
    required this.isExpense,
    required this.date,
    this.icon,
  });
}

class MyChart extends StatefulWidget {
  final List<Transaction> transactions;

  const MyChart({
    super.key,
    required this.transactions,
  });

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    // Group transactions by category
    final transactionsByCategory = <String, double>{};

    // Process all transactions, both income and expenses
    for (var transaction in widget.transactions) {
      final category = transaction.category;
      final amount =
          transaction.amount.abs(); // Use absolute value for chart size

      if (transactionsByCategory.containsKey(category)) {
        transactionsByCategory[category] =
            transactionsByCategory[category]! + amount;
      } else {
        transactionsByCategory[category] = amount;
      }
    }

    final colorMap = {
      'House': const Color(0xFF5cbdb9),
      'Food': Colors.red,
      'Transport': Colors.green,
      'Entertainment': Colors.purple,
      'Shopping': Colors.amber,
      'Health': Colors.pink,
      'Utilities': Colors.teal,
      'Job': Colors.blue,
      // Add more categories as needed
    };

    // Convert to list format needed for pie chart
    final data =
        transactionsByCategory.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value.key;
      final amount = entry.value.value;
      final title = '0${index + 1}'; // Creates ID numbers

      return {
        'title': title,
        'category': category,
        'value': amount,
        'color': colorMap[category] ??
            Colors.grey, // Default to grey if no color defined
      };
    }).toList();

    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      return PieChartSectionData(
        color: data[i]['color'] as Color,
        value: data[i]['value'] as double,
        title: data[i]['title'] as String,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
        badgeWidget: _Badge(
          data[i]['title'] as String,
          size: widgetSize,
          borderColor: data[i]['color'] as Color,
          category: data[i]['category'] as String,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.text, {
    required this.size,
    required this.borderColor,
    required this.category,
  });

  final String text;
  final String category;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
