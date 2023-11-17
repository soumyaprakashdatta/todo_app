import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:todo_app/widgets/todo_list_view_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initParseSDK();

  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      home: const TodoListView(),
      theme: ThemeData(scaffoldBackgroundColor: Colors.blueGrey.shade900),
    );
  }
}

Future<Parse> initParseSDK() async {
  const keyApplicationId = String.fromEnvironment('APPLICATION_ID');
  const keyClientKey = String.fromEnvironment('CLIENT_KEY');
  const keyParseServerUrl = "https://parseapi.back4app.com";

  if (keyApplicationId.isEmpty || keyClientKey.isEmpty) {
    throw Exception(
        "APPLICATION_ID and CLIENT_KEY environment variable must not be empty");
  }

  return await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );
}
