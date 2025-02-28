import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:namer_app/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:namer_app/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:namer_app/screens/add_expense/views/add_expense.dart';
import 'package:namer_app/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:namer_app/screens/home/views/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import '../../stats/stats.dart';

// Placeholder screens for Budgets and Savings
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Budget Screen"));
  }
}

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Savings Screen"));
  }
} //end of placeholder screens

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = const Color.fromARGB(255, 61, 132, 190);
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
        builder: (context, state) {
      if (state is GetExpensesSuccess) {
        return Scaffold(
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: BottomNavigationBar(
              currentIndex: index,
              onTap: (value) {
                setState(() {
                  index = value;
                });
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 3,
              selectedItemColor: selectedItem, //Highlight selected icon
              unselectedItemColor: unselectedItem, //Gray out unselected items

              items: [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home,
                      color: index == 0 ? selectedItem : unselectedItem),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.graph_square_fill,
                      color: index == 1 ? selectedItem : unselectedItem),
                  label: 'Stats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chart_pie_fill,
                      color: index == 2 ? selectedItem : unselectedItem),
                  label: 'Budgets',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.money_dollar_circle,
                      color: index == 3 ? selectedItem : unselectedItem),
                  label: 'Savings',
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            //  mini: true,
            onPressed: () async {
              Expense? newExpense = await Navigator.push(
                context,
                MaterialPageRoute<Expense>(
                  builder: (BuildContext context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            CreateCategoryBloc(FirebaseExpenseRepo()),
                      ),
                      BlocProvider(
                        create: (context) =>
                            GetCategoriesBloc(FirebaseExpenseRepo())
                              ..add(GetCategories()),
                      ),
                      BlocProvider(
                        create: (context) =>
                            CreateExpenseBloc(FirebaseExpenseRepo()),
                      ),
                    ],
                    child: const AddExpense(),
                  ),
                ),
              );

              if (newExpense != null) {
                setState(() {
                  state.expenses.insert(0, newExpense);
                });
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), //rounding effect on +
            ),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary,
                  ],
                  transform: const GradientRotation(pi / 4),
                ),
              ),
              child: const Icon(CupertinoIcons.add),
            ),
          ),
          body: IndexedStack(
            index: index,
            children: [
              MainScreen(state.expenses), // Home
              const StatScreen(), // Stats
              const BudgetScreen(), // Budgets
              const SavingsScreen(), // Savings
            ],
          ),
        );
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
