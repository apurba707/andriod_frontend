import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoModel {
  final String title;
  final String message;
  final String selectedFile;
  final String price;
  final List<String> tags;
  // like pardaina
  TodoModel(
      {required this.title,
      required this.message,
      required this.selectedFile,
      required this.tags,
      required this.price});

  //aba yeslai api ko response sanga map gara
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
        title: json['title'],
        message: json['message'],
        selectedFile: json['selectedFile'],
        tags: List<String>.from(json['tags']),
        price: json['"price"']);
  }
}

class TodoProvider extends ChangeNotifier {
  final httpClient = http.Client();
  List? todoData = [];
  Map? mapResponse = {};
  List? searchList = [];
  Map? searchMap = {};
  Map? login = {};
  Map? register = {};
  String? test;
  Map<String, String> customHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json;charset=UTF-8"
  };

  List<String> _searcHints = [];
  List<String> get searcHints {
    return [..._searcHints];
  }

  //Get request
  Future fetchData(int adminCurrentPage) async {
    try {
      final Uri restAPIURL = Uri.parse(
          "https://kalijfarm.herokuapp.com/kalijs?adminPage=$adminCurrentPage");
      http.Response response = await httpClient.get(restAPIURL);
      mapResponse = await jsonDecode(response.body.toString());
      todoData = mapResponse?['adminData'];
      //tesari dynamic list raknu hunna (dherai memory issue garauxa )
      
      // todoData.forEach((element) { })
      _searcHints = [];
      for (var element in todoData!) {
        _searcHints.add(element['title'].toLowerCase());
      }
      if (response.statusCode == 200) {
        return mapResponse;
      } else {
        // server error
        return Future.error('Server Error');
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  // Search request

  Future searchData(dynamic query) async {
    try {
      final Uri restAPIURL = Uri.parse(
          "https://kalijfarm.herokuapp.com/kalijs/all/search?searchKals=$query&tags=");
      http.Response response = await httpClient.get(restAPIURL);
      searchMap = await jsonDecode(response.body.toString());
      searchList = searchMap?['adminData'];
      print(searchList);
      if (response.statusCode == 200) {
        return searchList;
      } else {
        // server error
        return Future.error('Server Error');
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  //Post request
  Future addData(Map<String, String> body) async {
    try {
      final Uri restAPIURL =
          Uri.parse("https://kalijfarm.herokuapp.com/kalijs");
      http.Response response = await httpClient.post(restAPIURL,
          headers: customHeaders, body: jsonEncode(body));
      mapResponse = await jsonDecode(response.body.toString());

      if (response.statusCode == 201) {
        print('data of addData $mapResponse');
        return mapResponse;
      } else {
        // server error
        return 'error';
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //Delete request
  Future deleteData(String id) async {
    try {
      final Uri restAPIURL =
          Uri.parse("https://kalijfarm.herokuapp.com/kalijs/$id");

      http.Response response =
          await httpClient.delete(restAPIURL, headers: customHeaders);
      if (response.statusCode == 200) {
        return 'success';
      } else {
        // server error
        return 'error';
      }
    } catch (e) {
      return Future.error(e);
    }
  }

// update request
  Future updateData(Map<String, String> body, String id) async {
    try {
      final Uri restAPIURL =
          Uri.parse("https://kalijfarm.herokuapp.com/kalijs/$id");
      http.Response response = await httpClient.patch(restAPIURL,
          headers: customHeaders, body: jsonEncode(body));
      mapResponse = await jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        print(mapResponse);
        return mapResponse;
      } else {
        // server error
        return 'error';
      }
    } catch (e) {
      return Future.error(e);
    }
  }

// signin
  Future signIn(Map<String, String> body) async {
    try {
      final Uri restAPIURL =
          Uri.parse("https://kalijfarm.herokuapp.com/user/signin");
      http.Response response = await httpClient.post(restAPIURL,
          headers: customHeaders, body: jsonEncode(body));
      login = await jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        return login;
      } else {
        // server error
        return Future.error('Server Error');
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

// signup
  Future signUp(Map<String, String> body) async {
    try {
      final Uri restAPIURL =
          Uri.parse("https://kalijfarm.herokuapp.com/user/signup");
      http.Response response = await httpClient.post(restAPIURL,
          headers: customHeaders, body: jsonEncode(body));
      register = await jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        print(register);
      } else {
        // server error
        return Future.error('Server Error');
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }
}
