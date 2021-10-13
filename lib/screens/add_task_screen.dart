import 'package:flutter/cupertino.dart';
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
  DateTime currentDate = DateTime.now();
  DateTime today = DateTime.now();
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
      Navigator.pop(context, currentDate.day.toString());
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(today.year, today.month, today.day + 14));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
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
                  onTap: () =>
                      Navigator.pop(context, currentDate.day.toString()),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Color(0xFF018786),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  widget.task == null ? 'Add Book title' : 'Update Book title',
                  style: const TextStyle(
                      color: Color(0xFF018786),
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // Form(
                //   key: _formKey,
                //   child: Column(
                //     children: <Widget>[
                //       Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 20),
                //         child: TextFormField(
                //           style: const TextStyle(fontSize: 18),
                //           decoration: InputDecoration(
                //               labelText: 'Title',
                //               labelStyle: const TextStyle(fontSize: 18),
                //               border: OutlineInputBorder(
                //                   borderRadius: BorderRadius.circular(10.0))),
                //           validator: (input) => input!.trim().isEmpty
                //               ? 'Please Enter a Book Title'
                //               : null,
                //           onSaved: (input) => _title = input,
                //           initialValue: _title,
                //         ),
                //       ),
                //       // Padding(
                //       //   padding: const EdgeInsets.symmetric(vertical: 20),
                //       //   child: TextFormField(
                //       //     readOnly: true,
                //       //     controller: _dateController,
                //       //     style: TextStyle(fontSize: 18),
                //       //     onTap: _handleDatePicker,
                //       //     decoration: InputDecoration(
                //       //         labelText: 'Date',
                //       //         labelStyle: TextStyle(fontSize: 18),
                //       //         border: OutlineInputBorder(
                //       //             borderRadius: BorderRadius.circular(10.0))),
                //       //   ),
                //       // ),
                //       Container(
                //         margin: const EdgeInsets.symmetric(vertical: 20.0),
                //         height: 60.0,
                //         width: double.infinity,
                //         decoration: BoxDecoration(
                //             color: Theme.of(context).primaryColor,
                //             borderRadius: BorderRadius.circular(30.0)),
                //         child: TextButton(
                //           onPressed: _submit,
                //           child: Text(
                //             widget.task == null ? 'Add' : 'Update',
                //             style: const TextStyle(
                //                 color: Colors.white, fontSize: 20.0),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  height: 172.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Title of the Book',
                            contentPadding: EdgeInsets.only(top: 15.0),
                          ),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Title of the book is required'
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        "Return Date",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            height: 35.0,
                            width: 133.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  currentDate.day.toString(),
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                                const VerticalDivider(
                                  color: Colors.black,
                                  thickness: 1.0,
                                ),
                                Text(
                                  currentDate.month.toString(),
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                                const VerticalDivider(
                                  color: Colors.black,
                                  thickness: 1.0,
                                ),
                                Text(
                                  currentDate.year.toString(),
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(
                              Icons.calendar_today,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60.0,
                      width: 150.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pop(context, currentDate.day.toString()),
                        child: Text(
                          'BACK',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 60.0,
                      width: 150.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: TextButton(
                        onPressed: _submit,
                        child: Text(
                          widget.task == null ? 'CONFIRM' : 'UPDATE',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
