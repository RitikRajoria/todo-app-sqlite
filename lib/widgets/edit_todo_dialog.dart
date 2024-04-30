import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/bloc/todo_event.dart';
import 'package:todo_app/model/todo_model.dart';

class EditTodoPopup extends StatefulWidget {
  const EditTodoPopup({required this.todo, super.key});
  final Todo todo;

  @override
  State<EditTodoPopup> createState() => _EditTodoPopupState();
}

class _EditTodoPopupState extends State<EditTodoPopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.todo.name;
    _descriptionController.text = widget.todo.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            _updateTodo();
            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  void _updateTodo() async {
    final updatedTodo = Todo(
        id: widget.todo.id,
        name: _nameController.text,
        description: _descriptionController.text,
        isCompleted: widget.todo.isCompleted);
    BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(todo: updatedTodo));
    _nameController.clear();
    _descriptionController.clear();
  }
}
