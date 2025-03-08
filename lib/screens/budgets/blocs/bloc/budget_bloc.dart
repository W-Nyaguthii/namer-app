import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'budget_event.dart';
part 'budget_state.dart';

// Budget model class
class Budget {
  final String id;
  final String name;
  final double amount;
  final String category;
  final double spent;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    this.spent = 0.0,
  });
}

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(BudgetInitial()) {
    on<CreateBudgetEvent>(_onCreateBudget);
    on<LoadBudgetsEvent>(_onLoadBudgets); // Listen for loading budgets
  }

  Future<void> _onCreateBudget(
      CreateBudgetEvent event, Emitter<BudgetState> emit) async {
    try {
      emit(BudgetLoadingState());

      final uuid = Uuid();
      final newBudget = {
        "id": uuid.v4(),
        "name": event.name,
        "amount": event.amount,
        "category": event.category,
        "spent": 0.0
      };

      // Save to Firebase
      await FirebaseFirestore.instance.collection('budgets').add(newBudget);

      emit(BudgetCreatedState());

      // Reload budgets after creation
      add(LoadBudgetsEvent());
    } catch (e) {
      emit(BudgetErrorState(
          message: 'Failed to create budget: ${e.toString()}'));
    }
  }

  Future<void> _onLoadBudgets(
      LoadBudgetsEvent event, Emitter<BudgetState> emit) async {
    try {
      emit(BudgetLoadingState());

      // Fetch budgets from Firebase
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('budgets').get();

      List<Budget> budgets = snapshot.docs.map((doc) {
        return Budget(
          id: doc.id,
          name: doc['name'],
          amount: (doc['amount'] as num).toDouble(), // Ensure double type
          category: doc['category'],
          spent: (doc['spent'] as num).toDouble(),
        );
      }).toList();

      emit(BudgetLoadedState(budgets: budgets)); // Emit loaded budgets
    } catch (e) {
      emit(
          BudgetErrorState(message: 'Failed to load budgets: ${e.toString()}'));
    }
  }
}
