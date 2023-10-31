import 'package:flutter/material.dart';

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
  final todoTitleController = TextEditingController();
  final todoDescriptionController = TextEditingController();

  void fetchTodos() async {
    todos = fetchTodoEntries();
  }

  void createEntry() async {
    if (todoTitleController.text.trim().isEmpty ||
        todoDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("empty title or description"),
          duration: Duration(seconds: 2)));
      return;
    }

    await createTodoEntry(
        todoTitleController.text, todoDescriptionController.text);
    fetchTodos();
    setState(() {
      todoTitleController.clear();
      todoDescriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Today's tasks")),
        body: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: todoTitleController,
                  decoration: const InputDecoration(
                      labelText: "todo title",
                      labelStyle: TextStyle(color: Colors.blue)),
                )),
                Expanded(
                    child: TextField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: todoDescriptionController,
                  decoration: const InputDecoration(
                      labelText: "todo descriptuon",
                      labelStyle: TextStyle(color: Colors.blue)),
                )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: createEntry,
                    child: const Text("ADD")),
              ])),
          Expanded(
              child: FutureBuilder<List<TodoEntry>>(
                  future: todos,
                  builder: (ctx, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: const CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error while fetching todo list"),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(
                            child: Text("No todo found"),
                          );
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data?.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                var title = snapshot.data![index].title;
                                var description =
                                    snapshot.data![index].description;
                                var date = DateTime.parse(
                                    snapshot.data![index].createdAt);
                                var dateAgo =
                                    DateTime.now().difference(date).inHours;
                                return ListTile(
                                  title: Text(
                                      "$title - $description - ${dateAgo.toString()} hr ago"),
                                );
                              });
                        }
                    }
                  }))
        ]));
  }
}
