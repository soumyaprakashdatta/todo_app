import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import './todo_entry.dart';

Future<List<TodoEntry>> fetchTodoEntries() async {
  final ParseResponse apiResponse =
      await QueryBuilder<ParseObject>(ParseObject('todo')).query();
  if (apiResponse.success && apiResponse.results != null) {
    for (var o in apiResponse.results!) {
      developer.log((o as ParseObject).toString());
    }

    final maps =
        jsonDecode(apiResponse.results.toString()).cast<Map<String, dynamic>>();
    return List.generate(maps.length, (i) {
      return TodoEntry.fromMap(maps[i]);
    });
  }
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
