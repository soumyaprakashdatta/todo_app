import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_entry.dart';
import 'package:todo_app/util.dart';

class TaskListEntryWidget extends StatefulWidget {
  const TaskListEntryWidget(
      {super.key, required this.data, required this.toggleTodoEntryDone, required this.deleteEntry});

  final List<TodoEntry> data;
  final Future<void> Function(TodoEntry) toggleTodoEntryDone;
  final Future<void> Function(TodoEntry) deleteEntry;

  @override
  TaskListEntryViewState createState() => TaskListEntryViewState();
}

class TaskListEntryViewState extends State<TaskListEntryWidget> {
  final border = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );

  TextDecoration getTextDecoration(bool done) {
    if (done == true) {
      return TextDecoration.lineThrough;
    }
    return TextDecoration.none;
  }

  Color getTileColor(bool done) {
    if (done == true) {
      return Colors.blueGrey.shade700;
    }
    return Colors.blueGrey.shade500;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
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
                shape: const CircleBorder(),
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
                    return Colors.blueGrey.shade900;
                  },
                ),
              ),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "$title - $sinceStr",
                        style: TextStyle(color: Colors.white, decoration: getTextDecoration(widget.data[index].done)),
                      ),
                      subtitle: Text(
                        description,
                        style: TextStyle(color: Colors.white, decoration: getTextDecoration(widget.data[index].done)),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      developer.log("pressed delete for $title");
                      widget.deleteEntry(widget.data[index]);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade300,
                    ),
                  )
                ],
              ),
              tileColor: getTileColor(widget.data[index].done),
              selectedTileColor: Colors.black,
            ),
          );
        });
  }
}
