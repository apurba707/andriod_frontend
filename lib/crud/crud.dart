import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/API-provider.dart';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();
File? file;
String? imageData;
Uint8List? myImage;
Uint8List? imageBytes;
final emailController = TextEditingController();
final firstNameController = TextEditingController();
final lastNameController = TextEditingController();
final passwordController = TextEditingController();
final titleController = TextEditingController();
final priceController = TextEditingController();
final messageController = TextEditingController();
final tagController = TextEditingController();
final imgController = TextEditingController();

addDataWidget(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Add title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(hintText: 'Add price'),
              ),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(hintText: 'Add message'),
              ),
              TextField(
                controller: tagController,
                decoration: const InputDecoration(hintText: 'Add tags'),
              ),
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.gallery),
                icon: const Icon(Icons.image),
                label: imageData == null
                    ? Text('gallery')
                    : Text('Image Selected'),
              ),
              imageBytes != null
                  ? Image.memory(imageBytes!,
                      height: 40, width: 40, fit: BoxFit.fill)
                  : Container(),
              ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {  
                     var addDatas = await Provider.of<TodoProvider>(context, listen: false)
                          .addData({
                        "title": titleController.text,
                        "price": priceController.text,
                        "message": messageController.text,
                        "tags": tagController.text,
                        "selectedFile": imageData!,
                      }).whenComplete(() => Navigator.pushNamed(context, '/admin'));
                      print(addDatas['title']);
                    }
                  },
                  child: const Text("Submit"))
            ],
          ));
}

_getImage(ImageSource imageSource) async {
  var imageFile = (await picker.pickImage(source: imageSource));
  if (imageFile == null) return '';
  // image to Uint8List
  var _image = File(imageFile.path);
  imageBytes = _image.readAsBytesSync();
  // from camera image path to base64
  Uint8List bytes = Uint8List.fromList(imageBytes!);
  imageData = 'data:image/jpeg;base64,' + base64.encode(bytes);
  // base64 to image and use image.memory
  // UriData? _data = Uri.parse(imageData!).data;
  // myImage = _data!.contentAsBytes();
  // print(myImage);
  return imageData;
}

updateDataWidget(BuildContext context, String id, String title, String price,
    String message, String tags, String selectedFile) {
  titleController.text = title;
  priceController.text = price;
  messageController.text = message;
  tagController.text = tags;
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 500,
          width: 500,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Add title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              TextField(
                controller: tagController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.gallery),
                icon: const Icon(Icons.image),
                label: const Text('gallery'),
              ),
              imageBytes != null
                  ? Image.memory(imageBytes!,
                      height: 30, width: 30, fit: BoxFit.fill)
                  : Image.network(
                      'https://img.traveltriangle.com/blog/wp-content/uploads/2018/12/cover-for-street-food-in-sydney.jpg',
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
              ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      await Provider.of<TodoProvider>(context, listen: false)
                          .updateData({
                        'id': id,
                        "title": titleController.text,
                        "price": priceController.text,
                        "message": messageController.text,
                        "tags": tagController.text,
                        "selectedFile": imageData!,
                      }, id).whenComplete(() => Navigator.pushNamed(context, '/admin'));
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: const Text('Updated',
                          style: TextStyle(fontSize: 15)))),
            ],
          )));
}

deleteDataWidget(BuildContext context, String id) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 200,
          width: 50,
          alignment: Alignment.center,
          child: Center(
              child: Column(
            children: <Widget>[
              const Center(
                child: ListTile(
                    leading: Icon(Icons.photo),
                    title: Text('Click Yes To Delete Items')),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Yes'),
                onTap: () {
                  Provider.of<TodoProvider>(context, listen: false)
                      .deleteData(id)
                      .whenComplete(() => Navigator.pop(context));
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text('Message'),
                            content: Text('Your file is Deleted.'),
                          )).whenComplete(() => Navigator.pushNamed(context, '/admin'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('No'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text('Message'),
                            content: Text('Your file is not Deleted.'),
                          )).whenComplete(() => Navigator.pop(context));
                },
              ),
            ],
          ))));
}

siginIn(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 500,
          width: 50,
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 35),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email))),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password))),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      var signin =
                          Provider.of<TodoProvider>(context, listen: false);
                      var signinCon = await signin.signIn({
                        "email": emailController.text,
                        "password": passwordController.text,
                      }).whenComplete(() => Navigator.pop(context));
                      var role = await signinCon['result']['role'];
                      var name = await signinCon['result']['name'];
                      var email = await signinCon['result']['email'];
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('token', signinCon['token']);
                      prefs.setInt('role', role);
                      prefs.setString('name', name);
                      prefs.setString('email', email);
                      if (signinCon['token'] != null && role == 0) {
                        Navigator.pushReplacementNamed(context, '/client');
                      } else if (signinCon['token'] != null && role == 1) {
                        Navigator.pushReplacementNamed(context, '/admin');
                      } else {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                      print(signinCon['result']);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                                title: Text('Message'),
                                content: Text('Something .'),
                              )).whenComplete(() => Navigator.pop(context));
                    }
                  },
                  child: const Text("Submit"))
            ],
          )));
}

siginUp(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 500,
          width: 50,
          margin: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 7,
              ),
              TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                      labelText: 'FIRST NAME',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.person))),
              const SizedBox(
                height: 7,
              ),
              TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                      labelText: 'LAST NAME',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.person))),
              const SizedBox(
                height: 7,
              ),
              TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email))),
              const SizedBox(
                height: 7,
              ),
              TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password))),
              const SizedBox(
                height: 7,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      var signup =
                          Provider.of<TodoProvider>(context, listen: false);
                      var signinCon = await signup.signUp({
                        "firstName": firstNameController.text,
                        "lastName": lastNameController.text,
                        "email": emailController.text,
                        "password": passwordController.text,
                      }).whenComplete(() => Navigator.pop(context));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                                title: Text('Message'),
                                content: Text('Something .'),
                              )).whenComplete(() => Navigator.pop(context));
                    }
                  },
                  child: const Text("Submit"))
            ],
          )));
}
