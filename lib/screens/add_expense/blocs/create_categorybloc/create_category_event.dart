part of 'create_category_bloc.dart';

sealed class CreateCategoryEvent extends Equatable {
  const CreateCategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategory extends CreateCategoryEvent {
  final Category category;

  const CreateCategory(this.category);

  @override
  List<Object> get props => [category];
}

//to handle deleting
//class DeleteCategory extends CreateCategoryEvent {
  //final String categoryId;

  //const DeleteCategory(this.categoryId);

 // @override
 // List<Object> get props => [categoryId];
//}
