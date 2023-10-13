import 'dart:developer' as developer;
import 'dart:math';

import 'package:connect_nodes/shapes.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
enum Mode { none, add, delete, link, drag, calculate }

class _HomeState extends State<Home> {
  int _counter = 1;
  int? selectedNodeIndex;

  Mode mode = Mode.none;
  List<NodeModel> nodes = [];
  List<LinkModel> links = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: DrawNode(nodes)
          ),
          CustomPaint(
            painter: DrawLink(links)
          ),
          GestureDetector(
            onPanDown: (details) {
              if (mode == Mode.add) {

                setState(() {
                  nodes.add(NodeModel(
                      "$_counter",
                      details.localPosition.dx,
                      details.localPosition.dy,
                      32,
                      Colors.blue));
                });
                _counter++;

              }
              if (mode == Mode.delete) {
                int pos = isOnNode(details.localPosition.dx, details.localPosition.dy);
                if (pos >= 0) {
                  // Eliminar los enlaces que tienen el nodo a eliminar como origen o destino
                  setState(() {
                    links.removeWhere((link) =>
                    link.source == nodes[pos] || link.target == nodes[pos]
                    );
                    nodes.removeAt(pos);

                  });
                }
              }


              if (mode == Mode.link) {
                int posTarget = isOnNode(details.localPosition.dx, details.localPosition.dy);

                if (posTarget >= 0 && nodes[posTarget].x != null && nodes[posTarget].y != null) {
                  if (selectedNodeIndex == null) {
                    selectedNodeIndex = posTarget;
                  } else {
                    int? posSource = selectedNodeIndex;
                    setState(() {
                      links.add(LinkModel("1", nodes[posSource!], nodes[posTarget]));
                    });
                    selectedNodeIndex = null;
                  }
                }
              }
            },

    onPanUpdate: (details) {
              if (mode == Mode.drag) {
                int pos = isOnNode(details.localPosition.dx, details.localPosition.dy);
                if(pos >= 0){
                  setState(() {
                    nodes[pos].x = details.localPosition.dx;
                    nodes[pos].y = details.localPosition.dy;
                  });
                }

              }
            },
          )
        ],
      ),


      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle),
              color: (mode == Mode.add) ? Colors.white : Colors.black38,
              onPressed: () {
                setState(() {
                  mode == Mode.none ? mode = Mode.add : mode = Mode.none;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: (mode == Mode.delete) ? Colors.white : Colors.black38,

              onPressed: () {
                setState(() {
                  mode == Mode.none ? mode = Mode.delete : mode = Mode.none;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.link),
              color: (mode == Mode.link) ? Colors.white : Colors.black38,

              onPressed: () {
                setState(() {
                  mode == Mode.none ? mode = Mode.link : mode = Mode.none;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.touch_app),
              color: (mode == Mode.drag) ? Colors.white : Colors.black38,

              onPressed: () {
                setState(() {
                  mode == Mode.none ? mode = Mode.drag : mode = Mode.none;
                });
              },
            ),
            IconButton(onPressed: (){
              setState(() {
                mode == Mode.none ? mode = Mode.calculate : mode = Mode.none;
              });
            }, icon: const Icon(Icons.calculate),
              color: (mode == Mode.calculate) ? Colors.white : Colors.black38,
            )

          ],
        ),
      ),
    );
  }

  int isOnNode(double x, double y){
    int pos = -1;
    for(int i = 0; i < nodes.length; i++){
      double distance = sqrt(pow(nodes[i].x - x, 2) + pow(nodes[i].y - y, 2));
        if(distance <= nodes[i].radius){
          pos = i;
          i = nodes.length + 1;

        }

    }
    return pos;
  }


}
