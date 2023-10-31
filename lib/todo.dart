import 'package:flutter/material.dart';

import './todo_entry.dart';
import './api.dart';
import './util.dart';

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
          backgroundColor: Color.fromARGB(200, 150, 1, 1),
          content: Text("empty title or description"),
          duration: Duration(seconds: 2)));
      return;
    }

    createTodoEntry(todoTitleController.text, todoDescriptionController.text)
        .then((value) {
      fetchTodos();
      setState(() {
        todoTitleController.clear();
        todoDescriptionController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color.fromARGB(199, 13, 122, 1),
          content: Text("successfully created todo"),
          duration: Duration(seconds: 2)));
    }, onError: (err) {
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: const Color.fromARGB(200, 150, 1, 1),
            content:
                Text("error while adding todo entry, err=${err.toString()}"),
            duration: const Duration(seconds: 2)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Today's tasks")),
        body: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          autocorrect: true,
                          textCapitalization: TextCapitalization.sentences,
                          controller: todoTitleController,
                          decoration: const InputDecoration(
                              labelText: "todo title",
                              labelStyle: TextStyle(color: Colors.blue)),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(16),
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
                        return const Center(
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator()),
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
                                var sinceStr = getTimeSinceString(
                                    snapshot.data![index].createdAt);
                                return ListTile(
                                  title:
                                      Text("$title - $description - $sinceStr"),
                                );
                              });
                        }
                    }
                  }))
        ]));
  }
}
