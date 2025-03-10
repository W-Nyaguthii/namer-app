import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namer_app/screens/savings/blocs/bloc/savings_bloc.dart';
import 'package:namer_app/screens/savings/views/savings_popup.dart';
import 'package:intl/intl.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  SavingsScreenState createState() => SavingsScreenState();
}

class SavingsScreenState extends State<SavingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SavingsBloc>().add(LoadSavingsEvent());
  }

  String _formatTimeLeft(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now);

    if (difference.isNegative) {
      return 'Past due';
    }

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months months left';
    } else {
      return '${difference.inDays} days left';
    }
  }

  void _showDepositDialog(BuildContext context, Savings savings) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add to ${savings.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Current amount: \$${savings.currentAmount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Deposit Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty) {
                final newAmount =
                    savings.currentAmount + double.parse(amountController.text);
                context.read<SavingsBloc>().add(
                      UpdateSavingsAmountEvent(
                        savingsId: savings.id,
                        newAmount: newAmount,
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: Text('Deposit'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Savings savings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Savings Goal'),
        content: Text(
            'Are you sure you want to delete "${savings.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<SavingsBloc>().add(
                    DeleteSavingsEvent(
                      savingsId: savings.id,
                    ),
                  );
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SavingsBloc>().add(LoadSavingsEvent());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Goals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SavingsPopup(),
                );
              },
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Center(
                  child: Icon(Icons.add, size: 40, color: Colors.grey.shade600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<SavingsBloc, SavingsState>(
                builder: (context, state) {
                  if (state is SavingsLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SavingsLoadedState) {
                    return state.savingsList.isEmpty
                        ? Center(
                            child: Text("No goals found, \nPlease create one"))
                        : ListView.builder(
                            itemCount: state.savingsList.length,
                            itemBuilder: (context, index) {
                              final savings = state.savingsList[index];
                              final double percentComplete =
                                  savings.currentAmount / savings.targetAmount;
                              final double amountRemaining =
                                  savings.targetAmount - savings.currentAmount;

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  savings.name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 43, 113, 170),
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "Goal: \$${savings.targetAmount.toStringAsFixed(2)} \nCategory: ${savings.category}\nTarget: ${DateFormat('MMM dd, yyyy').format(savings.targetDate)}",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.green,
                                                    size: 32,
                                                  ),
                                                  onPressed: () {
                                                    _showDepositDialog(
                                                        context, savings);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                    size: 28,
                                                  ),
                                                  onPressed: () {
                                                    _showDeleteConfirmationDialog(
                                                        context, savings);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        // Progress bar
                                        SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: LinearProgressIndicator(
                                            value:
                                                percentComplete.clamp(0.0, 1.0),
                                            backgroundColor:
                                                Colors.grey.shade200,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    const Color.fromARGB(
                                                        255, 76, 175, 80)),
                                            minHeight: 8,
                                          ),
                                        ),

                                        // Savings statistics
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Saved: \$${savings.currentAmount.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            Text(
                                              "Remaining: \$${amountRemaining.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255, 43, 113, 170),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            _formatTimeLeft(savings.targetDate),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  } else if (state is SavingsErrorState) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(
                        child: Text("Press + to create a savings goal"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
