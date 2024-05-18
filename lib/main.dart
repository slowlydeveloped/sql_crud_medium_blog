import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/items_bloc.dart';
import 'home_page.dart';
import 'my_sqlite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemsBloc(DatabaseHelper()),
      child: const MaterialApp(
        title: 'Flutter CRUD with Bloc',
        home: HomePage(),
      ),
    );
  }
}
