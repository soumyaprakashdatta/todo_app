import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import './todo_entry.dart';
import './api.dart';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: "Todo App", home: TodoListView());
  }
}

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  TodoListViewState createState() => TodoListViewState();
}

class TodoListViewState extends State<TodoListView> {
  Future<List<TodoEntry>> todos = fetchTodoEntries();
  final todoController = TextEditingController();

  void fetchTodos() async {
    todos = fetchTodoEntries();
  }

  void createEntry() async {
    if (todoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("empty title"), duration: Duration(seconds: 2)));
      return;
    }

    await createTodoEntry(todoController.text, "abcd");
    fetchTodos();
    setState(() {
      todoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Today's tasks")),
        body: Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
                child: TextField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              controller: todoController,
              decoration: const InputDecoration(
                  labelText: "New Todo",
                  labelStyle: TextStyle(color: Colors.blue)),
            )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: createEntry,
                child: const Text("ADD")),
          ]),
          Expanded(
              child: FutureBuilder<List<TodoEntry>>(
                  future: todos,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      developer.log("waiting for data");
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      developer.log("fetched data");
                      developer.log(snapshot.data.toString());
                      return ListView.builder(
                          itemCount: snapshot.data?.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(snapshot.data![index].title),
                            );
                          });
                    } else {
                      developer.log("no data");
                      developer.log(snapshot.toString());
                      return Container();
                    }
                  }))
        ]));
  }
}
