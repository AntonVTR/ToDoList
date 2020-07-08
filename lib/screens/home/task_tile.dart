import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/DB.dart';
import 'package:todo/shared/constants.dart';

class TaskTile extends StatefulWidget {
  final Task task;

  TaskTile(this.task);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.task.isMy && widget.task.status != 'Complete') {
      return myTask();
    }
    if (widget.task.assignToMe && widget.task.status != 'Complete') {
      return guestTaskAsignedToMe();
    }
    if (widget.task.status != 'Complete') {
      return guestTask();
    } else {
      return completedTask();
    }
  }

  Widget myTask() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
          color: cButton[50],
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                    "${widget.task.name} (${widget.task.status}) assign to ${widget.task.assignedId}"),
                subtitle: Text(widget.task.description),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text(widget.task.status),
                    onPressed: () async {
                      if (widget.task.status == "New") {
                        widget.task.status = "In Progress";
                      } else if (widget.task.status == "In Progress") {
                        widget.task.status = "Complete";
                      }
                      await DataBaseService().updateTaskData(widget.task);
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget guestTaskAsignedToMe() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
          color: c[200],
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                    "${widget.task.name} (${widget.task.status}) assign to ${widget.task.assignedId}"),
                subtitle: Text(widget.task.description),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text(widget.task.status),
                    onPressed: () async {
                      if (widget.task.status == "New") {
                        widget.task.status = "In Progress";
                      } else if (widget.task.status == "In Progress") {
                        widget.task.status = "Complete";
                      }
                      await DataBaseService().updateTaskData(widget.task);
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget guestTask() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
          color: c[200],
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                    "${widget.task.name} (${widget.task.status}) owner ${widget.task.ownerId}"),
                subtitle: Text(widget.task.description),
              ),
            ],
          )),
    );
  }

  Widget completedTask() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
          color: c[400],
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                    "${widget.task.name} (${widget.task.status}) owner ${widget.task.ownerId}"),
                subtitle: Text(widget.task.description),
              ),
            ],
          )),
    );
  }
}
