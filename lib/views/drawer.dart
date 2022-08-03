import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../crud/crud.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer({Key? key}) : super(key: key);

  @override
  _MydrawerState createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  dynamic token;
  dynamic role;
  dynamic name;
  dynamic email;
  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
      name =  pref.getString('name');
      email = pref.getString('email');
      role =  pref.getInt('role');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
           UserAccountsDrawerHeader(
            accountName: Text(name ?? 'User Name'),
            accountEmail: Text(email ?? 'Email'),
            currentAccountPicture: CircleAvatar(
              child: Text(name ==null ? 'D' : name[0]),
              backgroundColor: Colors.white,
            ),
          ),
          
          role == 0
              ? ListTile(
                  leading: const Icon(Icons.contacts),
                  title: const Text(
                    'Client',
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/client');
                  })
                  
              : role == 1
                  ? Column(children: [
                      ListTile(
                          leading: const Icon(Icons.contacts),
                          title: const Text(
                            'Admin',
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/admin');
                          }),
                      ListTile(
                          leading: const Icon(Icons.contacts),
                          title: const Text(
                            'Client',
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/client');
                          }),
                    ])
                  : Container(),
          token == null
              ? Column(
                children: [
                  ListTile(
                            leading: const Icon(Icons.login),
                            title: const Text('Login'),
                            onTap: () => siginIn(context).whenComplete(() {
                              setState(() {});
                            }),
                          ),
                          ListTile(
                        leading: const Icon(Icons.login),
                        title: const Text('Register'),
                        onTap: () => siginUp(context).whenComplete(() {
                          setState(() {});
                        }),
                      )
                ],
              )       
              : Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('LogOut'),
                          onTap: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            await pref.clear();
                            Navigator.pushReplacementNamed(context, '/');
                          }))),
        ],
      ),
    );
  }
}
