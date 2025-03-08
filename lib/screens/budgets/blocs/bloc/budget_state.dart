part of 'budget_bloc.dart';

sealed class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object> get props => [];
}

final class BudgetInitial extends BudgetState {}

final class BudgetLoadingState extends BudgetState {}

final class BudgetCreatedState extends BudgetState {}

final class BudgetErrorState extends BudgetState {
  final String message;

  const BudgetErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class BudgetLoadedState extends BudgetState {
  final List<Budget> budgets;

  const BudgetLoadedState({required this.budgets});

  @override
  List<Object> get props => [budgets];
}
