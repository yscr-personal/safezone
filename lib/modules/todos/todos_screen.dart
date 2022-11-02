import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:unb/amplifyconfiguration.dart';
import 'package:unb/common/models/amplify/ModelProvider.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  List<Todo> _todos = [];

  late StreamSubscription<QuerySnapshot<Todo>> _subscription;

  @override
  void initState() {
    super.initState();
    _configureApp();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  Future<void> _configureApp() async {
    await _configureAmplify();
    _subscription = Amplify.DataStore.observeQuery(Todo.classType)
        .listen((QuerySnapshot<Todo> snapshot) {
      setState(() {
        _todos = snapshot.items;
      });
    });

    // _login();
  }

  Future<void> _configureAmplify() async {
    try {
      final dataStorePlugin =
          AmplifyDataStore(modelProvider: ModelProvider.instance);
      final apiPlugin = AmplifyAPI();
      final authPlugin = AmplifyAuthCognito();
      await Amplify.addPlugins([dataStorePlugin, apiPlugin, authPlugin]);
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      safePrint('An error occurred while configuring Amplify: $e');
    }
  }

  Future<void> _deleteTodo(final Todo todo) async {
    try {
      await Amplify.DataStore.delete(todo);
    } catch (e) {
      safePrint('An error occurred while deleting Todo: $e');
    }
  }

  Future<void> _toggleIsComplete(final Todo todo) async {
    final updatedTodo = todo.copyWith(isComplete: !todo.isComplete!);
    try {
      await Amplify.DataStore.save(updatedTodo);
    } catch (e) {
      safePrint('An error occurred while saving Todo: $e');
    }
  }

  Future<void> _saveTodo() async {
    final newTodo = Todo(
      name: 'new todo',
      description: 'wow',
      isComplete: false,
    );
    try {
      await Amplify.DataStore.save(newTodo);
    } catch (e) {
      safePrint('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: _todos
            .map(
              (todo) => Card(
                child: InkWell(
                  onTap: () {
                    _toggleIsComplete(todo);
                  },
                  onLongPress: () {
                    _deleteTodo(todo);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(todo.description!),
                            ],
                          ),
                        ),
                        Icon(
                          todo.isComplete!
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveTodo();
        },
        tooltip: 'Add Todo',
        label: Row(
          children: const [Icon(Icons.add), Text('Add todo')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
