import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/DB.dart';
import 'package:todo/shared/constants.dart';

class TaskDetails extends StatefulWidget {
  final Task task;

  TaskDetails(this.task);

  @override
  _TaskDetailsState createState() => _TaskDetailsState(task);
}

class _TaskDetailsState extends State<TaskDetails> {
  _TaskDetailsState(this.task);

  final _formKey = GlobalKey<FormState>();
  final List<String> status = ['New', 'In Progress', 'Complite'];
  Task task;
  String _currentExecutorEmail = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final List<String> _usersEmails = Provider.of<List<String>>(context) ?? [];
    final List<String> _menuAssign = ['Assign to', 'me'] + (_usersEmails);
    _menuAssign.remove(user.email);
    if (task.assignedId == user.email) {
      _currentExecutorEmail = _menuAssign[1];
    } else if (task.assignedId == '') {
      _currentExecutorEmail = _menuAssign[0];
    } else {
      _currentExecutorEmail = task.assignedId;
    }
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Task detail, status is ${task.status}, to ${task.assignedId}',
              style: TextStyle(color: cText),
            ),
            SizedBox(height: 3),
            TextFormField(
              autofocus: true,
              initialValue: task.name ?? "",
              decoration: textInputDecoration.copyWith(hintText: 'Name'),
              validator: (val) => val.isEmpty ? 'Please enter the name' : null,
              onChanged: (val) => setState(() => task.name = val),
            ),
            SizedBox(height: 3),
            TextFormField(
              initialValue: task.description ?? "",
              decoration:
                  textInputDecoration.copyWith(hintText: 'Desscription'),
              onChanged: (val) => setState(() => task.description = val),
            ),
            SizedBox(height: 3),
            DropdownButtonFormField(
                decoration: textInputDecoration,
                value: _currentExecutorEmail ?? _menuAssign[0],
                items: _menuAssign.map((email) {
                  return DropdownMenuItem(
                    value: email,
                    child: Text(email),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val == _menuAssign[0]) {
                    task.assignedId = '';
                  } else if (val == _menuAssign[1]) {
                    task.assignedId = user.email;
                  } else {
                    task.assignedId = val;
                  }
                  DataBaseService().updateUserTask(task);
                  setState(() => _currentExecutorEmail = val);
                }),
            Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await DataBaseService().deleteTask(task.id);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(color: cText),
                  ),
                  color: cButton,
                ),
                SizedBox(width: 10),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      task.id != ""
                          ? await DataBaseService().updateTaskData(task)
                          : await DataBaseService().addTaskData(task);
                      if (task.assignedId != '' && !task.isMy)
                        DataBaseService().updateUserTask(task);

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: cText),
                  ),
                  color: cButton,
                ),
              ],
            ),
          ],
        ));
  }
}
