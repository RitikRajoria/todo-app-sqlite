import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/bloc/todo_event.dart';
import 'package:todo_app/bloc/todo_state.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/widgets/add_todo_dialog.dart';
import 'package:todo_app/widgets/delete_todo_popup.dart';
import 'package:todo_app/widgets/edit_todo_dialog.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    BlocProvider.of<TodoBloc>(context).add(FetchTodosEvent());
  }

  void _updateTodoStatus(Todo todo) async {
    final updatedTodo = Todo(
      id: todo.id,
      name: todo.name,
      description: todo.description,
      isCompleted: todo.isCompleted,
    );
    BlocProvider.of<TodoBloc>(context).add(
      UpdateTodoEvent(todo: updatedTodo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoDialog,
        child: const Center(child: Icon(Icons.add)),
      ),
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          BlocConsumer<TodoBloc, TodoState>(
            listener: (context, state) {
              if (state is TodoErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Something error occured!'),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is TodoLoadingState) {
                return todoLoadingUI();
              } else if (state is TodoSuccessState) {
                return todoListUI(state);
              } else {
                return const Center(
                  child: Text("Please Add Todo here"),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget todoListUI(TodoSuccessState state) {
    return state.todoList.isEmpty
        ? const Expanded(
            child: Center(
              child: Text("No Todos"),
            ),
          )
        : Expanded(
            child: ListView.builder(
              itemCount: state.todoList.length,
              itemBuilder: (context, index) {
                final todo = state.todoList[index];
                return ListTile(
                  leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (newValue) {
                        todo.isCompleted = newValue ?? false;
                        _updateTodoStatus(todo);
                      }),
                  title: Text(todo.name),
                  subtitle: Text(todo.description),
                  trailing: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTodo(todo),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteTodoDialog(todo),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Center todoLoadingUI() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  void _editTodo(Todo todo) {
    _nameController.text = todo.name;
    _descriptionController.text = todo.description;
    showDialog(
      context: context,
      builder: (_) => EditTodoPopup(todo: todo),
    );
  }

  void _addTodoDialog() {
    showDialog(
      context: context,
      builder: (_) => const AddTodoPopup(),
    );
  }

  void _deleteTodoDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (_) => DeleteTodoPopup(todoId: todo.id),
    );
  }
}
