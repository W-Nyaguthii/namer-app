part of 'create_category_bloc.dart';

sealed class CreateCategoryState extends Equatable {
  const CreateCategoryState();

  @override
  List<Object> get props => [];
}

final class CreateCategoryInitial extends CreateCategoryState {}

final class CreateCategoryFailure extends CreateCategoryState {}

final class CreateCategoryLoading extends CreateCategoryState {}

final class CreateCategorySuccess extends CreateCategoryState {}

//start here
class CategoryDeletingState extends CreateCategoryState {}

class CategoryDeletedState extends CreateCategoryState {}

class CategoryDeleteErrorState extends CreateCategoryState {
  final String error;

  const CategoryDeleteErrorState(this.error);
}
