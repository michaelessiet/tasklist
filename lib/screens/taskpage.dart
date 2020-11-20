import 'package:flutter/material.dart';
import 'package:practice1/databasehelper.dart';
import 'package:practice1/models/task.dart';
import 'package:practice1/models/todo.dart';
import 'package:practice1/screens/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _taskTitle = "";
  String _taskDescription = "";
  String _todoText = '';

  DatabaseHelper _dbhelper = DatabaseHelper();

  int _taskid = 0;

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task.title;
      _taskid = widget.task.id;
      _taskDescription = widget.task.description;

      //set visibility to true if task is not null
      _contentVisible = true;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    //Todo implement dispose

    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back_ios,
                            )),
                      ),
                      Expanded(
                          child: TextField(
                        focusNode: _titleFocus,
                        autofocus: _taskid == 0 ? true : false,
                        onSubmitted: (value) async {
                          //check if the field is empty
                          if (value != '') {
                            //check if the task is null
                            if (widget.task == null) {
                              Task _newTask = Task(title: value);

                              _taskid = await _dbhelper.insertTask(_newTask);

                              print('new task id: $_taskid');

                              print('a new  task was added');
                            } else {
                              await _dbhelper.updateTaskTitle(_taskid, value);
                              print('You have updated your task title ');
                            }
                            setState(() {
                              _taskTitle = value;
                              _contentVisible = true;
                            });
                            _descriptionFocus.requestFocus();
                          }
                        },
                        controller: TextEditingController(text: _taskTitle),
                        decoration: InputDecoration(
                          hintText: 'Enter task title',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ))
                    ],
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      maxLines: null,
                      controller: TextEditingController(text: _taskDescription),
                      textInputAction: TextInputAction.done,
                      focusNode: _descriptionFocus,
                      onSubmitted: (value) {
                        _todoFocus.requestFocus();
                        if (value != '') {
                          if (_taskid != 0) {
                            _dbhelper.updateTaskDescription(_taskid, value);
                            _taskDescription = value;
                          }
                        }
                      },
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          hintText: "Enter task description",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: FutureBuilder(
                    initialData: [],
                    future: _dbhelper.getTodo(_taskid),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  //switch todo completion state
                                  if (snapshot.data[index].isdone == 0) {
                                    await _dbhelper.updateTodoDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbhelper.updateTodoDone(
                                        snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isdone: snapshot.data[index].isdone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            }),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6)),
                          child: Icon(
                            Icons.crop_square_outlined,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          focusNode: _todoFocus,
                          controller: TextEditingController(text: _todoText),
                          onSubmitted: (value) async {
                            if (value != '') {
                              //check if the task is null
                              if (_taskid != 0) {
                                DatabaseHelper _dbhelper = DatabaseHelper();

                                Todo _newTodo = Todo(
                                    title: value, isdone: 0, taskid: _taskid);

                                await _dbhelper.insertTodo(_newTodo);

                                setState(() {});
                                _todoFocus.requestFocus();
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter todo item',
                            border: InputBorder.none,
                          ),
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: _contentVisible,
              child: Positioned(
                bottom: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () async {
                    if (_taskid != 0) {
                      await _dbhelper.deleteTask(_taskid);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.delete_forever,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
