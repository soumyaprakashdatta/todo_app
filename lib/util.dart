import 'package:flutter/material.dart';

Route createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

String getTimeSinceString(String dateStr) {
  DateTime date;
  Duration dateAgo;
  String sinceStr;

  try {
    date = DateTime.parse(dateStr);
  } on Exception {
    sinceStr = "n/a";
    return sinceStr;
  }

  dateAgo = DateTime.now().difference(date);

  if (dateAgo.inDays >= 1) {
    sinceStr = "${dateAgo.inDays} day ago";
  } else if (dateAgo.inHours >= 1) {
    sinceStr = "${dateAgo.inHours} hr ago";
  } else {
    sinceStr = "${dateAgo.inMinutes} min ago";
  }

  return sinceStr;
}
