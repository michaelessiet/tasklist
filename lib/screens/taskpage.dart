import 'package:flutter/material.dart';
import 'package:practice1/databasehelper.dart';
import 'package:practice1/models/task.dart';
import 'package:practice1/models/todo.dart';
import 'package:practice1/screens/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  final bool darkthemeSwitcher;
  final int index;
  int selectedindex;

  TaskPage({@required this.task, this.darkthemeSwitcher, this.selectedindex, this.index});

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

  pagecheckforTodoList() {
    if (widget.selectedindex == 0) {
      return _dbhelper.getWorkTodo(_taskid);
    } else {
      return _dbhelper.getTodo(_taskid);
    }
  }

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
        color: widget.darkthemeSwitcher ? Colors.grey[850] : Colors.white,
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
                              color: widget.darkthemeSwitcher
                                  ? Colors.white
                                  : null,
                            )),
                      ),
                      Expanded(
                          child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: _titleFocus,
                        autofocus: _taskid == 0 ? true : false,
                        onSubmitted: (value) async {
                              //Check if we're on work page
                              if (widget.selectedindex == 0) {
                                //check if the field is empty
                                if (value != '') {
                                  //check if the task is null
                                  if (widget.task == null) {
                                    Task _newTask = Task(title: value);

                                    _taskid =
                                        await _dbhelper.insertWorkTask(_newTask);
                                  } else {
                                    await _dbhelper.updateWorkTaskTitle(
                                        _taskid, value);
                                  }
                                  setState(() {
                                    _taskTitle = value;
                                    _contentVisible = true;
                                  });
                                  _descriptionFocus.requestFocus();
                                }
                              } else {
                                if (value != '') {
                                  //check if the task is null
                                  if (widget.task == null) {
                                    Task _newTask = Task(title: value);

                                    _taskid = await _dbhelper.insertTask(_newTask);
                                  } else {
                                    await _dbhelper.updateTaskTitle(_taskid, value);
                                  }
                                  setState(() {
                                    _taskTitle = value;
                                    _contentVisible = true;
                                  });
                                  _descriptionFocus.requestFocus();
                                }
                              }
                        },
                        controller: TextEditingController(text: _taskTitle),
                        decoration: InputDecoration(
                                hintText: 'Enter task title',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: widget.darkthemeSwitcher
                                      ? Colors.white60
                                      : Colors.black45,
                                )),
                        style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: widget.darkthemeSwitcher ? Colors.white : null,
                        ),
                      ))
                    ],
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          controller: TextEditingController(text: _taskDescription),
                          textInputAction: TextInputAction.done,
                          focusNode: _descriptionFocus,
                          onChanged: (value) {
                            //Check if we're on work page
                            if (widget.selectedindex == 0) {
                              if (value != '') {
                                if (_taskid != 0) {
                                  _dbhelper.updateWorkTaskDescription(
                                      _taskid, value);
                                  _taskDescription = value;
                                }
                              }
                            } else {
                              if (value != '') {
                                if (_taskid != 0) {
                                  _dbhelper.updateTaskDescription(_taskid, value);
                                  _taskDescription = value;
                                }
                              }
                            }
                          },
                          onSubmitted: (value) {
                            _todoFocus.requestFocus();
                            //Check if we're on work page
                            if (widget.selectedindex == 0) {
                              if (value != '') {
                                print(value);
                                if (_taskid != 0) {
                                  _dbhelper.updateWorkTaskDescription(
                                      _taskid, value);
                                  _taskDescription = value;
                                }
                              }
                            } else {
                              if (value != '') {
                                if (_taskid != 0) {
                                  _dbhelper.updateTaskDescription(_taskid, value);
                                  _taskDescription = value;
                                }
                              }
                            }
                          },
                          style: TextStyle(
                            fontSize: 18,
                            color: widget.darkthemeSwitcher ? Colors.white : null,
                          ),
                          decoration: InputDecoration(
                              hintText: "Enter task description",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              hintStyle: TextStyle(
                                color: widget.darkthemeSwitcher
                                    ? Colors.white60
                                    : Colors.black45,
                              )),
                        ),
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: FutureBuilder(
                    initialData: [],
                    future: pagecheckforTodoList(),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  //check if we're on work page
                                  if (widget.selectedindex == 0) {
                                    //switch todo completion state
                                    if (snapshot.data[index].isdone == 0) {
                                      await _dbhelper.updateWorkTodoDone(
                                          snapshot.data[index].id, 1);
                                    } else {
                                      await _dbhelper.updateWorkTodoDone(
                                          snapshot.data[index].id, 0);
                                    }
                                  } else {
                                    //switch todo completion state
                                    if (snapshot.data[index].isdone == 0) {
                                      await _dbhelper.updateTodoDone(
                                          snapshot.data[index].id, 1);
                                    } else {
                                      await _dbhelper.updateTodoDone(
                                          snapshot.data[index].id, 0);
                                    }
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  darkthemeSwitcher: widget.darkthemeSwitcher,
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
                          textCapitalization: TextCapitalization.sentences,
                          focusNode: _todoFocus,
                          controller: TextEditingController(text: _todoText),
                          onSubmitted: (value) async {
                            //check if we're on work page
                            if (widget.selectedindex == 0) {
                              if (value != '') {
                                //check if the task is null
                                if (_taskid != 0) {
                                  DatabaseHelper _dbhelper = DatabaseHelper();

                                  Todo _newTodo = Todo(
                                      title: value, isdone: 0, taskid: _taskid);

                                  await _dbhelper.insertWorkTodo(_newTodo);

                                  setState(() {});
                                  _todoFocus.requestFocus();
                                }
                              }
                            } else {
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
                            }
                          },
                          style: TextStyle(
                            color:
                                widget.darkthemeSwitcher ? Colors.white : null,
                          ),
                          decoration: InputDecoration(
                              hintText: 'Enter todo item',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: widget.darkthemeSwitcher
                                    ? Colors.white60
                                    : Colors.black45,
                              )),
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
                bottom: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () async {
                    //checking if we're on work page
                    if (widget.selectedindex == 0) {
                      if (_taskid != 0) {
                        await _dbhelper.deleteWorkTask(_taskid);
                        Navigator.pop(context);
                      }
                    } else {
                      if (_taskid != 0) {
                        await _dbhelper.deleteTask(_taskid);
                        Navigator.pop(context);
                      }
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
