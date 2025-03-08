import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namer_app/screens/budgets/blocs/bloc/budget_bloc.dart';

class BudgetPopup extends StatefulWidget {
  const BudgetPopup({super.key});

  @override
  BudgetPopupState createState() => BudgetPopupState();
}

class BudgetPopupState extends State<BudgetPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    // Get the BudgetBloc instance
    final budgetBloc = context.read<BudgetBloc>();

    // Fetch categories
    final categories = await budgetBloc.fetchCategories();

    setState(() {
      _categories = categories;
      _selectedCategory = categories.isNotEmpty ? categories[0] : null;
      _isLoadingCategories = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state is BudgetCreatedState) {
          Navigator.pop(context);
        } else if (state is BudgetErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: Text(
          'Create Budget',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: _isLoadingCategories
            ? SizedBox(
                height: 200,
                width: 300,
                child: Center(child: CircularProgressIndicator()),
              )
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Budget Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a name' : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter an amount' : null,
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: _isLoadingCategories
                ? null // Disable when loading
                : () {
                    if (_formKey.currentState!.validate() &&
                        _selectedCategory != null) {
                      context.read<BudgetBloc>().add(CreateBudgetEvent(
                            name: _nameController.text,
                            amount: double.parse(_amountController.text),
                            category: _selectedCategory!,
                          ));
                    }
                  },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
