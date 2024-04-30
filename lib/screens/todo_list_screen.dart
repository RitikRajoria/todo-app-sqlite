import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/bloc/todo_event.dart';
import 'package:todo_app/bloc/todo_state.dart';
import 'package:todo_app/model/todo_model.dart';

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

  void _addTodo() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    if (name.isNotEmpty && description.isNotEmpty) {
      final todo =
          Todo(name: name, description: description, isCompleted: false);
      BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(todo: todo));
      _nameController.clear();
      _descriptionController.clear();
    }
  }

  void _updateTodoStatus(Todo todo) async {
    final updatedTodo = Todo(
        id: todo.id,
        name: todo.name,
        description: todo.description,
        isCompleted: todo.isCompleted);
    BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(todo: updatedTodo));
  }

  void _updateTodo(Todo todo) async {
    final updatedTodo = Todo(
        id: todo.id,
        name: _nameController.text,
        description: _descriptionController.text,
        isCompleted: todo.isCompleted);
    BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(todo: updatedTodo));
    _nameController.clear();
    _descriptionController.clear();
  }

  void _deleteTodo(int id) async {
    BlocProvider.of<TodoBloc>(context).add(DeleteTodoEvent(todoId: id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Todo Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addTodo();
                  },
                  child: const Text('Add Todo'),
                ),
              ],
            ),
          ),
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoadingState) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is TodoSuccessState) {
                return Expanded(
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

  void _editTodo(Todo todo) {
    _nameController.text = todo.name;
    _descriptionController.text = todo.description;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Todo Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateTodo(todo);
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteTodoDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteTodo(todo.id!);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
