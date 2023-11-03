import 'package:flutter/material.dart';

import './api.dart';
import './todo_entry.dart';
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

  Future<void> createEntry(BuildContext providedContext, VoidCallback onSuccess) async {
    if (todoTitleController.text.trim().isEmpty || todoDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color.fromARGB(200, 150, 1, 1),
          content: Text("empty title or description"),
          duration: Duration(seconds: 2)));
      return;
    }

    createTodoEntry(
      todoTitleController.text,
      todoDescriptionController.text,
    ).then(
      (value) {
        fetchTodos();
        setState(() {
          todoTitleController.clear();
          todoDescriptionController.clear();
        });
        onSuccess.call();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(199, 13, 122, 1),
            content: Text("successfully created todo"),
            duration: Duration(seconds: 2)));
      },
      onError: (err) {
        if (err != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: const Color.fromARGB(200, 150, 1, 1),
              content: Text("error while adding todo entry, err=${err.toString()}"),
              duration: const Duration(seconds: 2)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Today's tasks"),
          backgroundColor: const Color.fromARGB(255, 0, 18, 182),
        ),
        body: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 0, 18, 182),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: const Text("Add todo"),
                              content: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      TextFormField(
                                        autocorrect: true,
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: todoTitleController,
                                        decoration: const InputDecoration(
                                            labelText: "todo title",
                                            labelStyle: TextStyle(color: Color.fromARGB(255, 0, 18, 182))),
                                      ),
                                      TextFormField(
                                        autocorrect: true,
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: todoDescriptionController,
                                        decoration: const InputDecoration(
                                            labelText: "todo description",
                                            labelStyle: TextStyle(color: Color.fromARGB(255, 0, 18, 182))),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await createEntry(context, () {
                                      if (!mounted) {
                                        return;
                                      }
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: const Text("submit"),
                                ),
                              ],
                            );
                          });
                      // createEntry();
                    },
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
                          child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()),
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
                          return TaskListEntryView(data: snapshot.data!);
                        }
                    }
                  }))
        ]));
  }
}

class TaskListEntryView extends StatefulWidget {
  const TaskListEntryView({super.key, required this.data});

  final List<TodoEntry> data;

  @override
  TaskListEntryViewState createState() => TaskListEntryViewState();
}

class TaskListEntryViewState extends State<TaskListEntryView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          var title = widget.data[index].title;
          var description = widget.data[index].description;
          var sinceStr = getTimeSinceString(widget.data[index].createdAt);
          return Card(
            child: CheckboxListTile(
              value: widget.data[index].done,
              onChanged: (v) => setState(
                () {
                  widget.data[index].done = !widget.data[index].done;
                },
              ),
              title: Text(
                "$title - $sinceStr",
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                description,
                style: const TextStyle(color: Colors.white),
              ),
              tileColor: Colors.blueGrey.shade700,
              selectedTileColor: Colors.black,
              fillColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (!states.contains(MaterialState.selected)) {
                    return Colors.white;
                  }
                  return null;
                },
              ),
            ),
          );
        });
  }
}
