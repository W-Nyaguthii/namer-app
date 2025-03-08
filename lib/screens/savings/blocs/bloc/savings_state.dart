part of 'savings_bloc.dart';

sealed class SavingsState extends Equatable {
  const SavingsState();

  @override
  List<Object> get props => [];
}

final class SavingsInitial extends SavingsState {}

final class SavingsLoadingState extends SavingsState {}

final class SavingsCreatedState extends SavingsState {}

final class SavingsUpdatedState extends SavingsState {}

final class SavingsDeletedState extends SavingsState {}

final class SavingsErrorState extends SavingsState {
  final String message;

  const SavingsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class SavingsLoadedState extends SavingsState {
  final List<Savings> savingsList;

  const SavingsLoadedState({required this.savingsList});

  @override
  List<Object> get props => [savingsList];
}
