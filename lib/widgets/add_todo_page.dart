import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:todo_app/api.dart';

class AddTodoWidget extends StatefulWidget {
  const AddTodoWidget({super.key, required this.triggerTodoRefresh});

  final Function(bool) triggerTodoRefresh;

  @override
  AddTodoStateWidget createState() => AddTodoStateWidget();
}

class AddTodoStateWidget extends State<AddTodoWidget> {
  final todoTitleController = TextEditingController();
  final todoDescriptionController = TextEditingController();
  bool appBarLoading = false;

  void _setAppbarLoading(bool val) {
    setState(() {
      developer.log("called _setLoading with $val");
      appBarLoading = val;
    });
  }

  Future<void> createEntry(BuildContext providedContext) async {
    if (todoTitleController.text.trim().isEmpty || todoDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color.fromARGB(200, 150, 1, 1),
          content: Text("empty title or description"),
          duration: Duration(seconds: 2)));
      return;
    }

    _setAppbarLoading(true);
    createTodoEntry(
      todoTitleController.text,
      todoDescriptionController.text,
    ).then(
      (value) {
        setState(() {
          todoTitleController.clear();
          todoDescriptionController.clear();
        });
        widget.triggerTodoRefresh(true);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(199, 13, 122, 1),
            content: Text("successfully created todo 👍"),
            duration: Duration(seconds: 2)));
      },
      onError: (err) {
        if (err != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: const Color.fromARGB(200, 150, 1, 1),
              content: Text("⚠️ error while adding todo entry, err=${err.toString()}"),
              duration: const Duration(seconds: 2)));
        }
      },
    ).whenComplete(() => _setAppbarLoading(false));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    developer.log("loading: $appBarLoading");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add todo"),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                TextFormField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: todoTitleController,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
                    labelText: "Enter todo title",
                    labelStyle: TextStyle(
                      color: Colors.blueGrey.shade100,
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: todoDescriptionController,
                  minLines: 3,
                  maxLines: 10,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
                    labelText: "Enter todo description",
                    labelStyle: TextStyle(
                      color: Colors.blueGrey.shade100,
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade700),
                    ),
                    onPressed: () {
                      createEntry(context);
                    },
                    child: const Text('ADD'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
