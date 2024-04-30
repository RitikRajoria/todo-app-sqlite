import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_event.dart';
import 'package:todo_app/bloc/todo_state.dart';
import 'package:todo_app/services/repository.dart';

// await _todoRepository.insert(todo);

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitialState()) {
    final TodoRepository todoRepository = TodoRepository();
    on<FetchTodosEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        final todos = await todoRepository.getAllTodos();
        emit(TodoSuccessState(todoList: todos));
      } catch (e) {
        emit(TodoErrorState(error: e.toString()));
      }
    });

    on<AddTodoEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        await todoRepository.insert(event.todo);
        add(FetchTodosEvent());
      } catch (e) {
        emit(TodoErrorState(error: e.toString()));
      }
    });

     on<UpdateTodoEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        await todoRepository.update(event.todo);
        add(FetchTodosEvent());
      } catch (e) {
        emit(TodoErrorState(error: e.toString()));
      }
    });

     on<DeleteTodoEvent>((event, emit) async {
      emit(TodoLoadingState());
      try {
        await todoRepository.delete(event.todoId);
        add(FetchTodosEvent());
      } catch (e) {
        emit(TodoErrorState(error: e.toString()));
      }
    });
  }
}
