import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/widgets.dart';

class Taskpage extends StatefulWidget {
  final Task? task;
  Taskpage({required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  final DatabaseHelper _dbhelper = DatabaseHelper();

  int? _taskId = 0;
  String? _taskTitle = '';
  String? _taskDescription = '';

  final _todoTextField = TextEditingController();

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _widgetVisibility = false;

  @override
  void initState() {
    if (widget.task != null) {
      _taskId = widget.task!.id;
      _taskTitle = widget.task!.title;
      _taskDescription = widget.task!.description ?? '';

      _widgetVisibility = true;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    _titleFocus.requestFocus();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  void clearTodoTextField() {
    _todoTextField.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 4.0,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Image(
                            image: AssetImage(
                          'assets/images/back_arrow_icon.png',
                        )),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _titleFocus,
                        onSubmitted: ((value) async {
                          if (value != '') {
                            if (widget.task == null) {
                              Task _newTask = Task(title: value);

                              _taskId = await _dbhelper.insertTask(_newTask);
                              setState(() {
                                _widgetVisibility = true;
                                _taskTitle = value;
                              });
                            } else {
                              _dbhelper.updateTaskTitle(_taskId!, value);
                            }

                            _descriptionFocus.requestFocus();
                          }
                        }),
                        controller: TextEditingController()..text = _taskTitle!,
                        decoration: InputDecoration(
                          hintText: 'Enter Title...',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff231551),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _widgetVisibility,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 4.0,
                  ),
                  child: TextField(
                    focusNode: _descriptionFocus,
                    onSubmitted: (value) async {
                      if (value != '') {
                        if (_taskId != null) {
                          await _dbhelper.updateTaskDescription(
                              _taskId!, value);
                          _taskDescription = value;
                        }

                        _todoFocus.requestFocus();
                      }
                    },
                    controller: TextEditingController()
                      ..text = _taskDescription!,
                    decoration: InputDecoration(
                      hintText: 'Enter description...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _widgetVisibility,
                child: FutureBuilder(
                  initialData: [],
                  future: _dbhelper.getTodos(_taskId!),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              int isDone = 0;

                              if (snapshot.data[index].isDone == 0) {
                                isDone = 1;
                              }

                              await _dbhelper.updateTodoDone(
                                  snapshot.data[index].id, isDone);

                              setState(() {});
                            },
                            child: TodoWidget(
                              text: snapshot.data[index].title,
                              isDone: snapshot.data[index].isDone == 0
                                  ? false
                                  : true,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                  visible: _widgetVisibility,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Row(children: [
                      Expanded(
                          child: TextField(
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                if (value != '') {
                                  if (_taskId != null) {
                                    Todo _newTodo = Todo(
                                      title: value,
                                      taskId: _taskId!,
                                      isDone: 0,
                                    );

                                    await _dbhelper.insertTodo(_newTodo);
                                    clearTodoTextField();
                                    setState(() {});
                                  } else {}

                                  _todoFocus.requestFocus();
                                }
                              },
                              controller: _todoTextField,
                              decoration: InputDecoration(
                                  hintText: 'Enter Todo Item...'))),
                    ]),
                  ))
            ],
          ),
          Visibility(
            visible: _widgetVisibility,
            child: Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                    if (_taskId != 0) {
                      await _dbhelper.deleteTask(_taskId!);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Color(0xfffe2572),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 7,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Image(
                      image: AssetImage(
                        'assets/images/delete_icon.png',
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ))),
    );
  }
}
