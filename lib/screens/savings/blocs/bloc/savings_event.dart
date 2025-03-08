part of 'savings_bloc.dart';

sealed class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object> get props => [];
}

class CreateSavingsEvent extends SavingsEvent {
  final String name;
  final double targetAmount;
  final String category;
  final DateTime targetDate;

  const CreateSavingsEvent({
    required this.name,
    required this.targetAmount,
    required this.category,
    required this.targetDate,
  });

  @override
  List<Object> get props => [name, targetAmount, category, targetDate];
}

class LoadSavingsEvent extends SavingsEvent {}

class UpdateSavingsAmountEvent extends SavingsEvent {
  final String savingsId;
  final double newAmount;

  const UpdateSavingsAmountEvent({
    required this.savingsId,
    required this.newAmount,
  });

  @override
  List<Object> get props => [savingsId, newAmount];
}

class DeleteSavingsEvent extends SavingsEvent {
  final String savingsId;

  const DeleteSavingsEvent({
    required this.savingsId,
  });

  @override
  List<Object> get props => [savingsId];
}
