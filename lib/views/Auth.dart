import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  dynamic token;
  dynamic role;
  dynamic name;
  @override
  void initState() {
    super.initState();
    getCard();
  }

  void getCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      name = prefs.getString('name');
      role = prefs.getInt('role');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Mydrawer(),
        appBar: AppBar(title: const Text("Food Ordering"), centerTitle: true),
        body: Center(
          child: Container(
              margin: EdgeInsets.fromLTRB(20, 50, 20, 50),
              child: Column(children: [
                ListTile(
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  onTap: () {
                    if (token != null && role == 1) {
                      print('admin');
                      Navigator.pushReplacementNamed(context, '/admin');
                    } else if (token != null && role == 0) {
                      Navigator.pushReplacementNamed(context, '/client');
                    }
                  },
                  title: const Text(
                    'Welcome to Food Ordering App',
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    name != null ? 'Welcome Back $name' : 'Login to Continue',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ])),
        ));
  }
}
