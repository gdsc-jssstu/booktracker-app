import 'package:flutter/material.dart';
import 'package:bookduetracker/screens/todo_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:bookduetracker/provider/theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider<Themechanger>(
      create: (_) => Themechanger(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themechanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getDarkMode() ? ThemeData.dark() : ThemeData.light(),
      home: const TodoListScreen(),
    );
  }
}
