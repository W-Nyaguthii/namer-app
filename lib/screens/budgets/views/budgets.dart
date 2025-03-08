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
                              child: Text(
                                  "No budgets found \nPress + to create one"))
                          : ListView.builder(
                              itemCount: state.budgets.length,
                              itemBuilder: (context, index) {
                                final budget = state.budgets[index];

                                // Simulate budget usage data
                                //to be replaced with actual data
                                final double percentUsed =
                                    [0.65, 0.32, 0.78][index % 3];
                                final double amountSpent =
                                    budget.amount * percentUsed;
                                final double amountRemaining =
                                    budget.amount - amountSpent;

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
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              budget.name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 43, 113, 170),
                                              ),
                                            ),
                                            subtitle: Text(
                                              "Amount: \$${budget.amount.toStringAsFixed(2)} \nCategory: ${budget.category}",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // Add the delete button here
                                            trailing: IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                // Show confirmation dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title:
                                                        Text('Delete Budget'),
                                                    content: Text(
                                                        'Are you sure you want to delete ${budget.name}?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text('Cancel'),
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
                                                                        budget
                                                                            .id),
                                                              );
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Delete',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
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
                                                  AlwaysStoppedAnimation<Color>(
                                                      const Color.fromARGB(
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
                                                "Spent: \$${amountSpent.toStringAsFixed(2)}",
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
              //
            ],
          ),
        ),
      ),
    );
  }
}
