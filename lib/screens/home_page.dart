import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/screens/task_page.dart';
import 'package:todolist/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbhelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 28.0,
            vertical: 28.0,
          ),
          color: Color(0xfff6f6f6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 24.0,
                    ),
                    child: Image(
                        image: AssetImage(
                      'assets/images/logo.png',
                    )),
                  ),
                  Expanded(
                      child: FutureBuilder(
                    initialData: [],
                    future: _dbhelper.getTasks(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return ScrollConfiguration(
                        behavior: NoGlowBehaviour(),
                        child: ListView.builder(
                            itemCount: snapshot.data.length ?? 0,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => 
                                        Taskpage(task: snapshot.data[index])
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        
                                      });
                                    });
                                  },
                                  child: TaskCardWidget(
                                    title: snapshot.data[index].title,
                                    desc: snapshot.data[index].description,
                                  ));
                            }),
                      );
                    },
                  )),
                ],
              ),
              Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Taskpage(task: null,),
                          )).then((value) {
                        setState(() {
                          // when navigator is finished (back arrow) it will set state
                        });
                      });
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0)),
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
                          'assets/images/add_icon.png',
                        ),
                      ),
                    ),
                  )),
            ],
          )),
    ));
  }
}
