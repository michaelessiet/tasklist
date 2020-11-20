import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:practice1/databasehelper.dart';
import 'package:practice1/screens/taskpage.dart';
import 'package:practice1/screens/widgets.dart';

class HomePage extends StatefulWidget {
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
          color: Colors.grey[200],
          width: double.infinity,
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 32),
                  child: Icon(
                    Icons.bubble_chart_outlined,
                    size: 50,
                    color: Colors.deepPurple,
                  ),
                ),
                Expanded(
                    child: FutureBuilder(
                  initialData: [],
                  future: _dbHelper.getTasks(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TaskPage(
                                            task: snapshot.data[index],
                                          ))).then((value) {
                                            setState(() {
                                              
                                            });
                                          });
                            },
                            child: TaskCard(
                              title: snapshot.data[index].title,
                              description: snapshot.data[index].description,
                            ),
                          );
                        });
                  },
                ))
              ],
            ),
            Positioned(
              bottom: 20,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskPage(
                              task: null,
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
            )
          ]),
        ),
      ),
    );
  }
}
