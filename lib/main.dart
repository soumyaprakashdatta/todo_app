import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:developer' as developer;
import "./todo.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = String.fromEnvironment('KeyApplicationId');
  const keyClientKey = String.fromEnvironment('KeyClientKey');
  const keyParseServerUrl = String.fromEnvironment('KeyParseServerUrl');

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true, debug: true);

  final ParseResponse apiResponse =
      await QueryBuilder<ParseObject>(ParseObject('todo')).query();
  if (apiResponse.success && apiResponse.results != null) {
    // Let's show the results
    for (var o in apiResponse.results!) {
      developer.log((o as ParseObject).toString());
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(title: "Startup name generator", home: _RandomWords());
    return const MaterialApp(title: "Todo App", home: Todo());
  }
}
