import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookduetracker/screens/todo_list_screen.dart';
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
      theme: themeProvider.getDarkMode()
          ? ThemeData(
              primarySwatch: Colors.yellow,
              primaryColor: Colors.grey.shade900,
              brightness: Brightness.dark,
              cardColor: Colors.green,
              snackBarTheme: const SnackBarThemeData(
                actionTextColor: Colors.black,
                backgroundColor: Colors.green,
                contentTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              textTheme: const TextTheme(
                bodyText1: TextStyle(color: Colors.black),
              ),
            )
          : ThemeData(
              primarySwatch: Colors.green,
              brightness: Brightness.light,
              primaryColor: Colors.greenAccent,
              snackBarTheme: const SnackBarThemeData(
                actionTextColor: Colors.black,
                backgroundColor: Colors.white,
                contentTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
      home: const TodoListScreen(),
    );
  }
}
