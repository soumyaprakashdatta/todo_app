import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:todo_app/api.dart';
import 'package:todo_app/models/todo_entry.dart';
import 'package:todo_app/util.dart';
import 'package:todo_app/widgets/add_todo_page.dart';
import 'package:todo_app/widgets/divider_with_text_widget.dart';
import 'package:todo_app/widgets/task_list_entry_widget.dart';

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

  void triggerTodoRefresh(bool toRefresh) {
    if (toRefresh) {
      fetchTodos();
    }
  }

  Future<void> createEntry(
      BuildContext providedContext, VoidCallback onSuccess) async {
    if (todoTitleController.text.trim().isEmpty ||
        todoDescriptionController.text.trim().isEmpty) {
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
              content:
                  Text("error while adding todo entry, err=${err.toString()}"),
              duration: const Duration(seconds: 2)));
        }
      },
    ).whenComplete(() => _setAppbarLoading(false));
  }

  Future<void> toggleTodoEntryDone(TodoEntry entry) async {
    _setAppbarLoading(true);
    _setListLoading(false);
    updateTodoEntryField(entry.objectId, "done", !entry.done).then(
      (value) {
        fetchTodos();
      },
      onError: (err) {
        if (err != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: const Color.fromARGB(200, 150, 1, 1),
              content: Text(
                  "error while updating todo entry, err=${err.toString()}"),
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
          content:
              Text("error while deleting todo entry, err=${err.toString()}"),
          duration: const Duration(seconds: 2)));
    }).whenComplete(() => _setAppbarLoading(false));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    developer.log("loading: $appBarLoading");
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        backgroundColor: Colors.blueGrey.shade900,
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
        Expanded(
            child: FutureBuilder<List<TodoEntry>>(
                future: todos,
                builder: (ctx, snapshot) {
                  if (listLoading &&
                      (snapshot.connectionState == ConnectionState.none ||
                          snapshot.connectionState ==
                              ConnectionState.waiting)) {
                    return const Center(
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()),
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
                      return ListView(
                        children: <Widget>[
                          TaskListEntryWidget(
                            data: snapshot.data!
                                .where((e) => e.done == false)
                                .toList(),
                            triggerTodoRefresh: triggerTodoRefresh,
                            toggleTodoEntryDone: toggleTodoEntryDone,
                            deleteEntry: deleteEntry,
                          ),
                          const DividerWithTextWidget(text: "COMPLETED"),
                          TaskListEntryWidget(
                            data: snapshot.data!
                                .where((e) => e.done == true)
                                .toList(),
                            triggerTodoRefresh: triggerTodoRefresh,
                            toggleTodoEntryDone: toggleTodoEntryDone,
                            deleteEntry: deleteEntry,
                          ),
                        ],
                      );
                    }
                  }
                }))
      ]),
      floatingActionButton: FloatingActionButton(
        tooltip: "+",
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.blue.shade700),
        onPressed: () {
          Navigator.of(context).push(createRoute(AddTodoWidget(
            triggerTodoRefresh: triggerTodoRefresh,
          )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
