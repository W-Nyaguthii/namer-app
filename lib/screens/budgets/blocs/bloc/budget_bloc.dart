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
    on<LoadBudgetsEvent>(_onLoadBudgets);
    on<DeleteBudgetEvent>(_onDeleteBudget);
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
          amount: (doc['amount'] as num).toDouble(),
          category: doc['category'],
          spent: (doc['spent'] as num).toDouble(),
        );
      }).toList();

      emit(BudgetLoadedState(budgets: budgets));
    } catch (e) {
      emit(
          BudgetErrorState(message: 'Failed to load budgets: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteBudget(
      DeleteBudgetEvent event, Emitter<BudgetState> emit) async {
    try {
      emit(BudgetLoadingState());

      // to directly delete using the ID
      try {
        await FirebaseFirestore.instance
            .collection('budgets')
            .doc(event.budgetId)
            .delete();
      } catch (e) {
        //find by querying the id field
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('budgets')
            .where('id', isEqualTo: event.budgetId)
            .get();

        if (snapshot.docs.isNotEmpty) {
          await snapshot.docs.first.reference.delete();
        } else {
          throw Exception('Budget not found');
        }
      }

      emit(BudgetDeletedState());

      // Reload budgets after deletion
      add(LoadBudgetsEvent());
    } catch (e) {
      emit(BudgetErrorState(
          message: 'Failed to delete budget: ${e.toString()}'));
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      // Fetch categories from Firebase
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      // Extract category names
      List<String> categories = snapshot.docs.map((doc) {
        return doc['name'] as String;
      }).toList();

      return categories;
    } catch (e) {
      // default list if loading fails
      return ['Food', 'Transport', 'Entertainment', 'Savings'];
    }
  }
}
