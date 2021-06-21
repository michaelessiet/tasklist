import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final int index;
  final String description;
  final bool darkthemeSwitch;

  TaskCard({this.title, this.description, this.darkthemeSwitch, this.index});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.darkthemeSwitch ? Colors.black54 : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? 'Unnamed task',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: widget.darkthemeSwitch ? Colors.white : null),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              widget.description ?? "This task has no description yet.",
              style: TextStyle(
                  fontSize: 16,
                  color: widget.darkthemeSwitch ? Colors.white : null),
              maxLines: 3,
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isdone;
  final bool darkthemeSwitcher;

  TodoWidget({this.isdone, @required this.text, this.darkthemeSwitcher});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
            child: Icon(
              isdone ? Icons.check_circle : Icons.crop_square_rounded,
              color: Colors.deepPurple,
            ),
          ),
          Flexible(
            child: Text(
              text ?? 'No task',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isdone ? FontWeight.normal : FontWeight.bold,
                  color: darkthemeSwitcher
                      ? isdone
                          ? Colors.grey
                          : Colors.white
                      : Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
