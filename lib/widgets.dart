import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? desc;

  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 28.0,
          vertical: 28.0,
        ),
        margin: EdgeInsets.only(
          bottom: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 12.0,
              ),
              child: Text(
                title ?? '(Unnamed task)',
                style: TextStyle(
                  color: Color(0xff071330),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              desc ?? 'No description added',
              style: TextStyle(
                color: Color(0xff071330),
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  // const TodoWidget({Key? key}) : super(key: key);
  final String? text;
  final bool isDone;
  TodoWidget({this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 6.0,
      ),
      child: Row(children: [
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: isDone ? Color(0xff7349fe) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.0),
            border: isDone
                ? null
                : Border.all(
                    color: Color(0xff7349fe),
                  ),
          ),
          child: Image(image: AssetImage('assets/images/check_icon.png')),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.0,
            ),
            child: Text(
            text ?? 'Todo...',
            style: TextStyle(
                color: Color(0xff231551),
                fontSize: 16.0,
                fontWeight: isDone ? null : FontWeight.bold),
          ),)
        )
      ]),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
