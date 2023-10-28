import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

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
      print((o as ParseObject).toString());
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

class _RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<_RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup name generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return const Divider();
        }
        final int index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
        title: Text(
      pair.asPascalCase,
      style: _biggerFont,
    ));
  }
}
