import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:convert';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Todo App", home: TodoListView());
  }
}

class TodoListView extends StatefulWidget {
  @override
  TodoListViewState createState() => TodoListViewState();
}

class TodoListViewState extends State<TodoListView> {
  Future<List<TodoEntry>> todos = fetchTodoEntries();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Today's tasks")),
        body: Scaffold(
            body: Center(
                child: FutureBuilder<List<TodoEntry>>(
                    future: todos,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        print("waiting for data");
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        print("fetched data");
                        print(snapshot.data);
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index].title),
                              );
                            });
                      } else {
                        print("no data");
                        print(snapshot);
                        return Container();
                      }
                    }))));
  }
}

Future<List<TodoEntry>> fetchTodoEntries() async {
  final ParseResponse apiResponse = await QueryBuilder<ParseObject>(ParseObject('todo')).query();
  if (apiResponse.success && apiResponse.results != null) {
    // Let's show the results
    for (var o in apiResponse.results!) {
      print((o as ParseObject).toString());
    }

    final maps = jsonDecode(apiResponse.results.toString()).cast<Map<String, dynamic>>();
    return List.generate(maps.length, (i) {
      return TodoEntry.fromMap(maps[i]);
    });
  }
  throw Exception("error while fetching data");
}

// {
//     "className":"todo",
//     "objectId":"anl1T8kCE2",
//     "createdAt":"2023-10-28T08:02:22.183Z",
//     "updatedAt":"2023-10-28T08:02:22.183Z",
//     "title":"sample item",
//     "description":"this is a sample todo item"
// }
class TodoEntry {
  final String className;
  final String objectId;
  final String createdAt;
  final String updatedAt;
  final String title;
  final String description;

  TodoEntry(
      {required this.className,
      required this.objectId,
      required this.createdAt,
      required this.updatedAt,
      required this.title,
      required this.description});

  factory TodoEntry.fromMap(Map<String, dynamic> map) {
    return TodoEntry(
      className: map['className'],
      objectId: map['objectId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      title: map['title'],
      description: map['description'],
    );
  }
}
