import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';
//import 'package:flutter/foundation.dart';

part 'create_category_event.dart';
part 'create_category_state.dart';

class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  final ExpenseRepository expenseRepository;

  CreateCategoryBloc(this.expenseRepository) : super(CreateCategoryInitial()) {
    on<CreateCategory>((event, emit) async {
      emit(CreateCategoryLoading());
      try {
        await expenseRepository.createCategory(event.category);
        emit(CreateCategorySuccess());
      } catch (e) {
        emit(CreateCategoryFailure());
      }
    });

//start here
    on<CategoryDeleteEvent>((event, emit) async {
      // Added delete event handler
      emit(CategoryDeletingState()); // Emit deleting state
      try {
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(event.categoryId)
            .delete();
        emit(CategoryDeletedState()); // Emit deleted state
      } catch (e) {
        emit(CategoryDeleteErrorState(e.toString())); // Emit error state
      }
    });
  }
}
