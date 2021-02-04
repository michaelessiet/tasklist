import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice1/databasehelper.dart';
import 'package:practice1/screens/taskpage.dart';
import 'package:practice1/screens/widgets.dart';

class HomePage extends StatefulWidget {
  final bool darkthemeSwitcher;
  int selectedIndex;
  var box;
  HomePage({this.darkthemeSwitcher, this.box, this.selectedIndex});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: widget.darkthemeSwitcher ? Colors.grey[850] : Colors.grey[200],
          width: double.infinity,
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 32),
                      child: Icon(
                        Icons.grading,
                        size: 50,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Container(
                      child: Text(
                        'Tasklist',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTasks(),
                        builder: (context, snapshot) {
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, crossAxisSpacing: 10),
                              itemCount: snapshot.data.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => TaskPage(
                                                  index: index,
                                                  darkthemeSwitcher:
                                                      widget.darkthemeSwitcher,
                                                  task: snapshot.data[index],
                                                  selectedindex:
                                                      widget.selectedIndex,
                                                ))).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: TaskCard(
                                    index: index,
                                    darkthemeSwitch: widget.darkthemeSwitcher,
                                    title: snapshot.data[index].title,
                                    description:
                                        snapshot.data[index].description,
                                  ),
                                );
                              });
                        }))
              ],
            ),
            Positioned(
                right: 0,
                top: 20,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        widget.darkthemeSwitcher
                            ? Icons.bedtime
                            : Icons.brightness_5,
                        color: widget.darkthemeSwitcher ? Colors.white : null,
                        size: 30,
                      ),
                      CupertinoSwitch(
                          value: widget.darkthemeSwitcher,
                          activeColor: Colors.deepPurple,
                          onChanged: (value) {
                            widget.box
                                .put('darkMode', !widget.darkthemeSwitcher);
                            setState(() {});
                          })
                    ],
                  ),
                )),
            Positioned(
              bottom: 20,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => TaskPage(
                              darkthemeSwitcher: widget.darkthemeSwitcher,
                              task: null,
                              selectedindex: widget.selectedIndex,
                            )),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
