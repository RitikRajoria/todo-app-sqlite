import 'package:todo_app/model/todo_model.dart';

abstract class TodoEvent {}

class FetchTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;

  AddTodoEvent({required this.todo});
}

class UpdateTodoEvent extends TodoEvent {
   final Todo todo;

  UpdateTodoEvent({required this.todo});
}

class DeleteTodoEvent extends TodoEvent {
   final int todoId;

  DeleteTodoEvent({required this.todoId});
}
