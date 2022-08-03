import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_sport_kalij/views/single.dart';

import '../provider/API-provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  dynamic _searchController = TextEditingController();

  List<String>? foodListSearch;
  final FocusNode _textFocusNode = FocusNode();
  @override
  void dispose() {
    _textFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> foodList = Provider.of<TodoProvider>(context).searcHints;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue.shade300,
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _searchController,
                focusNode: _textFocusNode,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Search here',
                    contentPadding: EdgeInsets.all(8)),
                onChanged: (value) {
                  setState(() {
                    foodListSearch = foodList
                        .where(
                            (element) => element.contains(value.toLowerCase()))
                        .toList();

                    if (_searchController.text.isNotEmpty &&
                        foodListSearch!.isEmpty) {
                      print('foodListSearch length ${foodListSearch!.length}');
                    }
                  });
                },
              ),
            )),
        body: _searchController.text.isNotEmpty && foodListSearch!.length == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: const[
                      Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search_off,
                          size: 160,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No results found,\nPlease try different',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _searchController.text.isNotEmpty
                    ? foodListSearch!.length
                    : foodList.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(
                      _searchController.text.isNotEmpty
                          ? foodListSearch![index]
                          : foodList[index],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    leading: Icon(Icons.fastfood),
                    onTap: () {
                      var click = _searchController.text.isNotEmpty
                          ? foodListSearch![index]
                          : foodList[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Detail(details: _searchController.text.isNotEmpty
                          ? foodListSearch![index]
                          : foodList[index])));
                      _searchController.clear();
                      _textFocusNode.unfocus();
                    },
                  );
                }));
  }
}
