import 'dart:ui';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';
import 'package:bookduetracker/provider/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookduetracker/helpers/database_helper.dart';
import 'package:bookduetracker/models/task_model.dart';
import 'package:bookduetracker/screens/add_task_screen.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>>? _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            ListTile(
              title: Text(
                task.title!,
                style: TextStyle(
                    fontSize: 18,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              subtitle: Text(
                '${_dateFormatter.format(task.date!)} * ${task.priority}',
                style: TextStyle(
                    fontSize: 15,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              trailing: Checkbox(
                onChanged: (value) {
                  task.status = value! ? 1 : 0;
                  DatabaseHelper.instance.updateTask(task);
                  _updateTaskList();
                },
                activeColor: Theme.of(context).primaryColor,
                value: task.status == 1 ? true : false,
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddTaskScreen(
                          updateTaskList: _updateTaskList, task: task))),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Themechanger _themechanger = Provider.of<Themechanger>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Book Tracker')),
          toolbarHeight: 47,
          leading: const SizedBox(
            width: 10,
          ),
          actions: [
            Switcher(
              value: false,
              size: SwitcherSize.large,
              switcherButtonRadius: 70,
              enabledSwitcherButtonRotate: true,
              iconOff: Icons.light_mode,
              iconOn: Icons.dark_mode,
              colorOff: Colors.red,
              colorOn: Colors.green,
              onChanged: (bool state) {
                state
                    ? _themechanger.settheme(ThemeData.dark())
                    : _themechanger.settheme(ThemeData.light());
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(updateTaskList: _updateTaskList),
              ),
            )
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final int? completedTaskCount = (snapshot.data as List<Task>)
                .where((Task task) => task.status == 1)
                .toList()
                .length;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              itemCount: 1 + (snapshot.data as List<Task>).length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Books to be Returned',
                          style: TextStyle(
                              color: Color(0xFF018786),
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '$completedTaskCount of ${(snapshot.data as List<Task>).length}',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  );
                }
                return _buildTask((snapshot.data as List<Task>)[index - 1]);
              },
            );
          },
        ),
      ),
    );
  }
}
