import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../crud/crud.dart';
import '../provider/API-provider.dart';
import 'drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int adminCurrentPage = 1;
  Uint8List? myImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Mydrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () => addDataWidget(context),
          child: const Icon(Icons.add)),
      appBar:
          AppBar(title: const Text("RhinoSpotnKalijFarm"), centerTitle: true),
      body: Consumer<TodoProvider>(
        builder: (context, model, _) => FutureBuilder(
          future: model.fetchData(adminCurrentPage),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model.todoData?.length,
                        itemBuilder: (context, int index) {
                          var img = model.todoData![index]['selectedFile'];
                          final UriData? _data = Uri.parse(img).data;
                          myImage = _data!.contentAsBytes();
                          return Container(
                              height: 70,
                              color: Colors.lightBlue,
                              child: ListTile(
                                onLongPress: () {
                                  deleteDataWidget(
                                      context, model.todoData![index]["_id"]);
                                },
                                onTap: () {
                                  updateDataWidget(
                                    context,
                                    model.todoData![index]["_id"],
                                    model.todoData![index]["title"],
                                    model.todoData![index]["price"],
                                    model.todoData![index]["message"],
                                    model.todoData![index]["tags"][0],
                                    model.todoData![index]["selectedFile"],
                                  );
                                },
                                title: Text(model.todoData![index]['title']),
                                subtitle: Text(
                                    model.todoData![index]['message'],
                                    maxLines: 1),
                                leading: CircleAvatar(
                                  backgroundImage: Image.memory(myImage!).image,
                                ),
                              ));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (model.mapResponse!['adminCurrentPage'] <
                              model.mapResponse!['adminNumberOfPages'])
                            OutlinedButton(
                              onPressed: ()async {
                                print(model.mapResponse!['adminNumberOfPages']);
                                setState(()  {
                                  adminCurrentPage++;
                                  showDialog(
                                      context: context,
                                      builder: (context) => Padding(
                                        padding: const EdgeInsets.all(150.0),
                                        child: Center(child: CircularProgressIndicator()),
                                      ));
                                });
                                 await Future.delayed(const Duration(seconds: 4)).then((_) {
                                   Navigator.pop(context);
                                 });

                              },
                              child: const Text(
                                "Next",
                              ),
                            ),
                          if (model.mapResponse!['adminCurrentPage'] > 1)
                            OutlinedButton(
                              onPressed: () async{
                                setState(() {
                                  adminCurrentPage--;
                                  showDialog(
                                      context: context,
                                      builder: (context) => Padding(
                                        padding: const EdgeInsets.all(150.0),
                                        child: Center(child: CircularProgressIndicator()),
                                      ));
                                  });
                                  await Future.delayed(const Duration(seconds: 4)).then((_) {
                                   Navigator.pop(context);
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
