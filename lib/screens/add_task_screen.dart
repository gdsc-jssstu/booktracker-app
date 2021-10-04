import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookduetracker/helpers/database_helper.dart';
import 'package:bookduetracker/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Function? updateTaskList;
  final Task? task;

  const AddTaskScreen({Key? key, this.updateTaskList, this.task})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _title = "";
  String? _priority = "Low";
  DateTime? _date = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //print('$_title, $_priority, $_date');

      // Insert Task to Users Database
      Task task = Task(title: _title, date: _date, priority: _priority);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        // Update Task to Users Database
        task.id = widget.task!.id;
        task.status = widget.task!.status;
        DatabaseHelper.instance.updateTask(task);
      }

      widget.updateTaskList!();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = _dateFormatter.format(_date!);

    if (widget.task != null) {
      _title = widget.task!.title;
      _priority = widget.task!.priority;
      _date = widget.task!.date;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  widget.task == null ? 'Add Book title' : 'Update Book title',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: const TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Please Enter a Book Title'
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 20),
                      //   child: TextFormField(
                      //     readOnly: true,
                      //     controller: _dateController,
                      //     style: TextStyle(fontSize: 18),
                      //     onTap: _handleDatePicker,
                      //     decoration: InputDecoration(
                      //         labelText: 'Date',
                      //         labelStyle: TextStyle(fontSize: 18),
                      //         border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10.0))),
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: TextButton(
                          onPressed: _submit,
                          child: Text(
                            widget.task == null ? 'Add' : 'Update',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
