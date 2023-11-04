import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_entry.dart';

class TodoDetailsWidget extends StatelessWidget {
  const TodoDetailsWidget({super.key, required this.todo});

  final TodoEntry todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Todo Details"),
          backgroundColor: Colors.blueGrey.shade900,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _textWidgetHelper("Title: ${todo.title}", Colors.blueGrey.shade100),
              const Divider(),
              _textWidgetHelper("Description: ${todo.description}", Colors.blueGrey.shade300),
              const Divider(),
              _textWidgetHelper("Done: ${todo.done}", Colors.blueGrey.shade300),
              const Divider(),
              _textWidgetHelper("Created At: ${todo.createdAt}", Colors.blueGrey.shade300),
              const Divider(),
              _textWidgetHelper("Updated At: ${todo.updatedAt}", Colors.blueGrey.shade300),
            ],
          ),
        ));
  }

  Widget _textWidgetHelper(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 16,
      ),
    );
  }
}
