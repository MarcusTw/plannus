import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_button.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  User user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context, listen: true);
    return ChangeNotifierProvider<TodoData>.value(
      value: user.toDoDatabase,
      child: StreamProvider<List<Todo>>.value(
          value: user.toDoDatabase.getTodoByType(TodoType.TYPE_TASK.index),
          child: Consumer<List<Todo>>(
            builder: (context, _dataList, child) {
              return _dataList == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: _dataList.length,
                itemBuilder: (context, index) {
                  return _dataList[index].isFinish
                      ? _taskComplete(_dataList[index])
                      : _taskIncomplete(_dataList[index]);
                },
              );
            },
          ),
      ),
    );
  }

  Widget _taskIncomplete(Todo data) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Confirm Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data.task),
                      SizedBox(
                        height: 24,
                      ),
                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Complete",
                        onPressed: () async {
                          user.toDoDatabase
                              .completeTodoEntries(data.id);
                          await user.update().whenComplete(() => Navigator.pop(context));
                        },
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              );
            });
      },
      onLongPress: () async {
        await deleteBox(context, data);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.radio_button_unchecked,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            SizedBox(
              width: 28,
            ),
            Text(data.task)
          ],
        ),
      ),
    );
  }

  Widget _taskComplete(Todo data) {
    return Container(
      foregroundDecoration: BoxDecoration(color: Color(0x60FDFDFD)),
      child: GestureDetector(
        onLongPress: () async {
          await deleteBox(context, data);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.radio_button_checked,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
              SizedBox(
                width: 28,
              ),
              Text(data.task)
            ],
          ),
        ),
      ),
    );
  }

  Future deleteBox(BuildContext context, Todo data) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Delete Task",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(
                    height: 24,
                  ),
                  Text(data.task),
                  SizedBox(
                    height: 24,
                  ),
                  Text(new DateFormat("dd-MM-yyyy").format(data.date)),
                  SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                    buttonText: "Delete",
                    onPressed: () async{
                      user.toDoDatabase
                          .deleteTodoEntries(data.id);
                      await user.update().whenComplete(() => Navigator.pop(context));
                    },
                    color: Theme
                        .of(context)
                        .accentColor,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}