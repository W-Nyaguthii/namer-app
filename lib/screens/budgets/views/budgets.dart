import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namer_app/screens/budgets/blocs/bloc/budget_bloc.dart';
import 'package:namer_app/screens/budgets/views/budget_popup.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  BudgetScreenState createState() => BudgetScreenState();
}

class BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(LoadBudgetsEvent());
  }

  void _showSpendDialog(BuildContext context, Budget budget) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Record Expense for ${budget.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current spent: \$${budget.spent.toStringAsFixed(2)}'),
            Text('Budget: \$${budget.amount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Expense Amount',
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
                final newSpent =
                    budget.spent + double.parse(amountController.text);
                context.read<BudgetBloc>().add(
                      UpdateBudgetSpentEvent(
                        budgetId: budget.id,
                        newSpent: newSpent,
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: Text('Record'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state is BudgetDeletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Budget deleted successfully')),
          );
        } else if (state is BudgetErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is BudgetUpdatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Expense recorded successfully')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<BudgetBloc>().add(LoadBudgetsEvent());
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' My Budgets',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //the + icon
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => BudgetPopup(),
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
                    child:
                        Icon(Icons.add, size: 40, color: Colors.grey.shade600),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<BudgetBloc, BudgetState>(
                  builder: (context, state) {
                    if (state is BudgetLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is BudgetLoadedState) {
                      return state.budgets.isEmpty
                          ? Center(
                              child:
                                  Text("No budgets found, \nPlease create one"))
                          : ListView.builder(
                              itemCount: state.budgets.length,
                              itemBuilder: (context, index) {
                                final budget = state.budgets[index];

                                // Calculate percentage used from actual data
                                final double percentUsed =
                                    (budget.spent / budget.amount)
                                        .clamp(0.0, 1.0);
                                final double amountRemaining =
                                    budget.amount - budget.spent;

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
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Text(
                                                    budget.name,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              43,
                                                              113,
                                                              170),
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    "Amount: \$${budget.amount.toStringAsFixed(2)} \nCategory: ${budget.category}",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  // Add expense button
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                      size: 32,
                                                    ),
                                                    onPressed: () {
                                                      _showSpendDialog(
                                                          context, budget);
                                                    },
                                                  ),
                                                  // Delete button
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.black,
                                                      size: 28,
                                                    ),
                                                    onPressed: () {
                                                      // Show confirmation dialog
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Delete Budget'),
                                                          content: Text(
                                                              'Are you sure you want to delete ${budget.name}?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                // Delete budget
                                                                context
                                                                    .read<
                                                                        BudgetBloc>()
                                                                    .add(
                                                                      DeleteBudgetEvent(
                                                                          budgetId:
                                                                              budget.id),
                                                                    );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)),
                                                            ),
                                                          ],
                                                        ),
                                                      );
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
                                              value: percentUsed,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                      Color>(percentUsed >
                                                          0.9
                                                      ? Colors.red
                                                      : const Color.fromARGB(
                                                          255, 43, 113, 170)),
                                              minHeight: 8,
                                            ),
                                          ),

                                          // Spending statistics
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Spent: \$${budget.spent.toStringAsFixed(2)}",
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
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (state is BudgetErrorState) {
                      return Center(child: Text(state.message));
                    } else {
                      return Center(child: Text("Press + to create a budget"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
