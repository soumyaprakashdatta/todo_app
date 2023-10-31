import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import "./todo.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initParseSDK();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: "Todo App", home: Todo());
  }
}

Future<Parse> initParseSDK() async {
  const keyApplicationId = String.fromEnvironment('KeyApplicationId');
  const keyClientKey = String.fromEnvironment('KeyClientKey');
  const keyParseServerUrl = String.fromEnvironment('KeyParseServerUrl');

  return await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true, debug: true);
}
