import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'create_expense_event.dart';
part 'create_expense_state.dart';

class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  ExpenseRepository expenseRepository;

  CreateExpenseBloc(this.expenseRepository) : super(CreateExpenseInitial()) {
    on<CreateExpense>((event, emit) async {
      emit(CreateExpenseLoading());
      try {
        await expenseRepository.createExpense(event.expense);
        emit(CreateExpenseSuccess());
      } catch (e) {
        emit(CreateExpenseFailure());
      }
    });

    //start here for deleting function
    on<DeleteExpense>((event, emit) async {
      try {
        emit(CreateExpenseLoading());

        // Delete the expense from Firebase
        await FirebaseFirestore.instance
            .collection('expenses')
            .doc(event.expenseId)
            .delete();

        emit(DeleteExpenseSuccess());
      } catch (e) {
        emit(DeleteExpenseFailure());
      }
    });
  }
}
