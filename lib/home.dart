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
  String _weight = '';
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
                    openWeightInputDialog(context, (String weight) {

                      setState(() {
                        // print("weight: $weight");
                        // links.add(LinkModel(weight, nodes[posSource!], nodes[posTarget]));
                        _weight = weight;

                      });
                    });
                    setState(() {
                      links.add(LinkModel(_weight, nodes[posSource!], nodes[posTarget]));
                    });
                    selectedNodeIndex = null;

                  }
                }
                //show alert dialog to set weight

                links.forEach((element) {
                  print("weight: ${element.weight}");
                });
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



  Future<void> openWeightInputDialog(BuildContext context, Function(String) onWeightEntered) async {
    String weight = ''; // Variable para almacenar el peso ingresado

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Ingrese el peso del enlace'),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Peso'),
                onChanged: (value) {
                  weight = value;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (weight.isNotEmpty) {
                      onWeightEntered(weight); // Llamar a la función de devolución de llamada con el peso ingresado
                      Navigator.of(context).pop(); // Cerrar el diálogo
                    }
                  },
                  child: Text('Aceptar'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}
