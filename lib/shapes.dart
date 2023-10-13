import 'package:flutter/material.dart';

import 'models.dart';

class DrawNode extends CustomPainter{
  List<NodeModel> nodes = [];

  _message(double x, double y, String text, Canvas canvas){
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 20),
      text: text,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
    tp.layout();
    tp.paint(canvas, Offset(x, y));
  }

  DrawNode(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint()
        ..style = PaintingStyle.fill;
    nodes.forEach((element) {
      paint.color = element.color;
      canvas.drawCircle(Offset(element.x, element.y), element.radius, paint);
      //add text
      _message(element.x -5, element.y - 10, element.name, canvas);

    });

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class DrawLink extends CustomPainter{
  List<LinkModel> links = [];
  _message(double x, double y, String text, Canvas canvas){
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 20),
      text: text,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
    tp.layout();
    tp.paint(canvas, Offset(x, y));
  }
  DrawLink(this.links);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    links.forEach((element) {
      paint.color = element.source.color;
      canvas.drawLine(Offset(element.source.x, element.source.y), Offset(element.target.x, element.target.y), paint);
      _message(element.source.x + (element.target.x - element.source.x)/2, element.source.y + (element.target.y - element.source.y)/2, element.weight, canvas);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
