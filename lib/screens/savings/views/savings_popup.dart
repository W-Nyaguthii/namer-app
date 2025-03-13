import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namer_app/screens/savings/blocs/bloc/savings_bloc.dart';
import 'package:intl/intl.dart';

class SavingsPopup extends StatefulWidget {
  const SavingsPopup({super.key});

  @override
  SavingsPopupState createState() => SavingsPopupState();
}

class SavingsPopupState extends State<SavingsPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  String _selectedCategory = 'Emergency Fund'; // Default category
  String _selectedAccountType = 'Bank Savings Account'; // Default account type
  DateTime _targetDate =
      DateTime.now().add(Duration(days: 365)); // Default 1 year target

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavingsBloc, SavingsState>(
      listener: (context, state) {
        if (state is SavingsCreatedState) {
          Navigator.pop(context); // Close popup
        } else if (state is SavingsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: Text(
          'Create Savings Goal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Goal Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _targetAmountController,
                  decoration: InputDecoration(
                    labelText: 'Target Amount',
                    prefixText: '\$',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a target amount' : null,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: [
                    'Emergency Fund',
                    'Vacation',
                    'Home',
                    'Education',
                    'Retirement',
                    'Other'
                  ]
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
                SizedBox(height: 20),
                // New dropdown for account type
                DropdownButtonFormField<String>(
                  value: _selectedAccountType,
                  items: [
                    'Bank Savings Account',
                    'Money Market Fund(MMF)',
                    '52-Week Challenge(Saf)',
                    'Fixed Deposit',
                    'Other'
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountType = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Savings Account Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _targetDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
                    );
                    if (picked != null && picked != _targetDate) {
                      setState(() {
                        _targetDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Target Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('MMM dd, yyyy').format(_targetDate)),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<SavingsBloc>().add(CreateSavingsEvent(
                      name: _nameController.text,
                      targetAmount: double.parse(_targetAmountController.text),
                      category: _selectedCategory,
                      accountType:
                          _selectedAccountType, // Add this new parameter
                      targetDate: _targetDate,
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
