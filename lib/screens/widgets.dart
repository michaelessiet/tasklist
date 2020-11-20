import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;

  TaskCard({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '(Unnamed task)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              description ?? "This task has no description yet.",
              style: TextStyle(
                fontSize: 16,
              ),
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

  TodoWidget({this.isdone, @required this.text});

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
                  color: isdone ? Colors.grey : null),
            ),
          )
        ],
      ),
    );
  }
}
