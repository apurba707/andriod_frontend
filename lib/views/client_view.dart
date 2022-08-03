import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/API-provider.dart';
import 'drawer.dart';
import 'single.dart';

class Client extends StatefulWidget {
  const Client({Key? key}) : super(key: key);

  @override
  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {
  dynamic token;
  int adminCurrentPage = 1;
  Uint8List? myImage;
  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Mydrawer(),
      appBar: AppBar(title: const Text("Food Ordering"), centerTitle: true),
      body: Consumer<TodoProvider>(
        builder: (context, model, _) => FutureBuilder(
          future: model.fetchData(adminCurrentPage),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              leading: const Icon(Icons.search),
                              title: const Text('Search',
                                  style: TextStyle(fontSize: 15)),
                              onTap: () {
                                Navigator.pushNamed(context, '/search');
                              }),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model.todoData?.length,
                        itemBuilder: (context, int index) {
                          var img = model.todoData![index]['selectedFile'];
                          // final UriData? _data = Uri.parse(img).data;
                          // myImage = _data?.contentAsBytes();
                          return Container(
                            height: 70,
                            color: Colors.lightBlue,
                            child: ListTile(
                              onTap: () {
                                var click = model.todoData![index]['title'];
                                print(click);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Detail(
                                            details: model.todoData![index])));
                              },
                              title: Text(model.todoData![index]['title']),
                              subtitle: Text(model.todoData![index]['message'],
                                  maxLines: 1),
                              leading: CircleAvatar(
                                backgroundImage: Image.network(img!).image,
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (model.mapResponse!['adminCurrentPage'] <
                              model.mapResponse!['adminNumberOfPages'])
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  adminCurrentPage++;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          content: Text(
                                              "Moving to the $adminCurrentPage page")));
                                  Timer(const Duration(seconds: 4), () {
                                    Navigator.pop(context);
                                  });
                                });
                              },
                              child: const Text(
                                "Next",
                              ),
                            ),
                          if (model.mapResponse!['adminCurrentPage'] > 1)
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  adminCurrentPage--;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          content: Text(
                                              "Moving to the $adminCurrentPage page")));
                                  Timer(const Duration(seconds: 4), () {
                                    Navigator.pop(context);
                                  });
                                });
                              },
                              child: const Text(
                                "Previous",
                              ),
                            ),
                        ],
                      ),
                    ],
                  ))
                : snapshot.hasError
                    ? Text(snapshot.error.toString())
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
          },
        ),
      ),
    );
  }
}
