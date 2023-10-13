import 'package:flutter/material.dart';

class NodeModel{

  String name;
  double x;double y;
  double radius;
  Color color;

  NodeModel(this.name, this.x, this.y, this.radius, this.color);
}

class LinkModel{

  String weight;
  NodeModel source;
  NodeModel target;

  LinkModel(this.weight, this.source, this.target);
}