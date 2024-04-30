import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/bloc/todo_event.dart';

class DeleteTodoPopup extends StatefulWidget {
  const DeleteTodoPopup({super.key, required this.todoId});
  final int? todoId;
  @override
  State<DeleteTodoPopup> createState() => _DeleteTodoPopupState();
}

class _DeleteTodoPopupState extends State<DeleteTodoPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            if (widget.todoId != null) {
              _deleteTodo(widget.todoId!);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  void _deleteTodo(int id) async {
    BlocProvider.of<TodoBloc>(context).add(DeleteTodoEvent(todoId: id));
  }
}
