import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/bloc/todo_event.dart';
import 'package:todo_app/model/todo_model.dart';

class AddTodoPopup extends StatefulWidget {
  const AddTodoPopup({super.key});

  @override
  State<AddTodoPopup> createState() => _AddTodoPopupState();
}

class _AddTodoPopupState extends State<AddTodoPopup> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Todo Title'),
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
            _addTodo();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addTodo() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    if (name.isNotEmpty && description.isNotEmpty) {
      final todo =
          Todo(name: name, description: description, isCompleted: false);
      BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(todo: todo));
      Navigator.of(context).pop();
    }
  }
}
