import 'dart:developer' as developer;

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
  late Future<List<TodoEntry>> todos;
  final todoTitleController = TextEditingController();
  final todoDescriptionController = TextEditingController();
  bool appBarLoading = false;
  bool listLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  void _setAppbarLoading(bool val) {
    setState(() {
      developer.log("called _setLoading with $val");
      appBarLoading = val;
    });
  }

  void _setListLoading(bool val) {
    setState(() {
      developer.log("called _setLoading with $val");
      listLoading = val;
    });
  }

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

    _setAppbarLoading(true);
    _setListLoading(false);
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
    ).whenComplete(() => _setAppbarLoading(false));
  }

  Future<void> toggleTodoEntryDone(TodoEntry entry) async {
    _setAppbarLoading(true);
    _setListLoading(false);
    updateTodoEntry(entry.objectId, "done", !entry.done).then(
      (value) {
        fetchTodos();
      },
      onError: (err) {
        if (err != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: const Color.fromARGB(200, 150, 1, 1),
              content: Text("error while updating todo entry, err=${err.toString()}"),
              duration: const Duration(seconds: 2)));
        }
      },
    ).whenComplete(() => _setAppbarLoading(false));
  }

  Future<void> deleteEntry(TodoEntry entry) async {
    _setAppbarLoading(true);
    _setListLoading(false);
    deleteTodoEntry(entry.objectId).then((value) {
      fetchTodos();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(199, 13, 122, 1),
          content: Text("successfully deleted todo with title=${entry.title}"),
          duration: const Duration(seconds: 2)));
    }, onError: (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(200, 150, 1, 1),
          content: Text("error while deleting todo entry, err=${err.toString()}"),
          duration: const Duration(seconds: 2)));
    }).whenComplete(() => _setAppbarLoading(false));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    developer.log("loading: $appBarLoading");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Today's tasks"),
          backgroundColor: const Color.fromARGB(255, 0, 18, 182),
          bottom: appBarLoading
              ? PreferredSize(
                  preferredSize: Size(size.width, 0),
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                )
              : null,
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
                    if (listLoading &&
                        (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState == ConnectionState.waiting)) {
                      return const Center(
                        child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Error while fetching todo list"),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No todo found"),
                        );
                      } else {
                        return TaskListEntryView(
                          data: snapshot.data!,
                          toggleTodoEntryDone: toggleTodoEntryDone,
                          deleteEntry: deleteEntry,
                        );
                      }
                    }
                  }))
        ]));
  }
}

class TaskListEntryView extends StatefulWidget {
  const TaskListEntryView(
      {super.key, required this.data, required this.toggleTodoEntryDone, required this.deleteEntry});

  final List<TodoEntry> data;
  final Future<void> Function(TodoEntry) toggleTodoEntryDone;
  final Future<void> Function(TodoEntry) deleteEntry;

  @override
  TaskListEntryViewState createState() => TaskListEntryViewState();
}

class TaskListEntryViewState extends State<TaskListEntryView> {
  final border = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );

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
            shape: border,
            child: ListTile(
              shape: border,
              leading: Checkbox(
                value: widget.data[index].done,
                onChanged: (v) => setState(
                  () {
                    developer.log("pressed toggle for $title, prev_state=${widget.data[index].done}");
                    widget.toggleTodoEntryDone(widget.data[index]);
                  },
                ),
                fillColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (!states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return null;
                  },
                ),
              ),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "$title - $sinceStr",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        description,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      developer.log("pressed delete for $title");
                      widget.deleteEntry(widget.data[index]);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              tileColor: Colors.blueGrey.shade700,
              selectedTileColor: Colors.black,
            ),
          );
        });
  }
}
