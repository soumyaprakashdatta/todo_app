import 'dart:convert';
import 'dart:developer' as developer;

import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'models/todo_entry.dart';

Future<List<TodoEntry>> fetchTodoEntries() async {
  final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('todo'));
  parseQuery.orderByDescending('createdAt');

  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    for (var o in apiResponse.results!) {
      developer.log((o as ParseObject).toString());
    }

    final maps = jsonDecode(apiResponse.results.toString()).cast<Map<String, dynamic>>();

    List<TodoEntry> entries = List.generate(maps.length, (i) {
      return TodoEntry.fromMap(maps[i]);
    });

    developer.log("fetched entries: ${entries.toString()}");
    return entries;
  }
  developer.log("faced some issue while fetching todo entries");
  throw Exception("error while fetching data");
}

Future<bool> createTodoEntry(String title, String description) async {
  var entry = ParseObject("todo");
  entry.set("title", title);
  entry.set("description", description);
  var response = await entry.save();
  if (response.success && response.results != null) {
    for (var o in response.results!) {
      developer.log((o as ParseObject).toString());
    }
    return true;
  }
  throw Exception("error while creating todo entry");
}

Future<bool> updateTodoEntry(String id, String key, Object val) async {
  var todoEntry = ParseObject("todo")..objectId = id;
  todoEntry.set(key, val);
  final ParseResponse response = await todoEntry.save();
  if (response.success && response.results != null) {
    return true;
  }
  throw Exception("error while updating todo entry for id=$id");
}

Future<bool> deleteTodoEntry(String id) async {
  var todoEntry = ParseObject("todo")..objectId = id;
  final ParseResponse response = await todoEntry.delete();
  if (response.success && response.results != null) {
    return true;
  }
  throw Exception("error while deleting todo entry for id=$id");
}
