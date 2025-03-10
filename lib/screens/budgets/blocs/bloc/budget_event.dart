part of 'budget_bloc.dart';

sealed class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object> get props => [];
}

class CreateBudgetEvent extends BudgetEvent {
  final String name;
  final double amount;
  final String category;

  const CreateBudgetEvent({
    required this.name,
    required this.amount,
    required this.category,
  });

  @override
  List<Object> get props => [name, amount, category];
}

class LoadBudgetsEvent extends BudgetEvent {}

//To delete
class DeleteBudgetEvent extends BudgetEvent {
  final String budgetId;

  const DeleteBudgetEvent({required this.budgetId});

  @override
  List<Object> get props => [budgetId];
}

class UpdateBudgetSpentEvent extends BudgetEvent {
  final String budgetId;
  final double newSpent;

  const UpdateBudgetSpentEvent({
    required this.budgetId,
    required this.newSpent,
  });

  @override
  List<Object> get props => [budgetId, newSpent];
}
