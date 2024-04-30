import 'package:todo_app/model/todo_model.dart';

abstract class TodoState {}

class TodoInitialState extends TodoState {}

class TodoLoadingState extends TodoState {}

class TodoSuccessState extends TodoState {
  final List<Todo> todoList;

  TodoSuccessState({required this.todoList});
}

class TodoErrorState extends TodoState {
  final String error;

  TodoErrorState({required this.error});
}
