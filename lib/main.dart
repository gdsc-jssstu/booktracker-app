import 'package:flutter/material.dart';
import 'package:bookduetracker/screens/todo_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:bookduetracker/provider/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Themechanger>(
      create: (_) => Themechanger(ThemeData()),
      child: const MaterialAppwithTheme(),
    );
  }
}

class MaterialAppwithTheme extends StatelessWidget {
  const MaterialAppwithTheme({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<Themechanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.gettheme(),
      home: const TodoListScreen(),
    );
  }
}
