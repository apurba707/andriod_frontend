import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'drawer.dart';

class Detail extends StatefulWidget {
  dynamic details;
  Detail({Key? key, @required this.details}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Uint8List? myImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("RhinoSpotnKalijFarm"), centerTitle: true),
        body: Center(
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: <Widget>[
              Container(
                child: Text(widget.details!['title']),
              ),
              Container(
                child: Image.network(widget.details['selectedFile']),
                width: 300,
                height: 300,
              ),
              Container(
                child: Text(widget.details['message']),
              ),
              Container(
                child: Text(widget.details['price'].toString()),
              ),
              Container(
                child: ElevatedButton(
                  child: Text("Khalti Payment"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/khalti');
                  },
                ),
              ),
            ]),
          )),
        ));
  }
}
