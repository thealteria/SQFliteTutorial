import 'package:flutter/material.dart';
import 'package:sqlite_database_tutorial/databsehelper.dart';
import 'package:sqlite_database_tutorial/models/User.dart';

List _users;
void main() async {
  var db = new DatabaseHelper();

  //add user
  // int savedUser = await db.saveUser(new User("kkkkk", "lol"));
  // print("User saved: $savedUser");

  int count = await db.getCount();
  print("Count: $count");

//get user
  User user = await db.getUser(3);
  print("Got user: ${user.username}");

  //delete user
  // int delete = await db.deleteUser(2);
  // print("Deleted user: $delete");

  _users = await db.getAllUsers();
  for (int i = 0; i < _users.length; i++) {
    User user = User.map(_users[i]);

    print("Username: ${user.username}");
  }

  runApp(new MaterialApp(
    title: "SQLite Tutorial",
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("SQLite Tutorial"),
          centerTitle: true,
          backgroundColor: Colors.red),
      body: new ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, int position) {
          // _ => means we are using _users context
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: new ListTile(
              leading: new CircleAvatar(
                backgroundColor: Colors.purple,
                child: new Text(
                    "${User.fromMap(_users[position]).username.substring(0, 1)}",
                    style: TextStyle(color: Colors.white)),
              ),
              title:
                  new Text("User: ${User.fromMap(_users[position]).username}"),
              subtitle: new Text("Id: ${User.fromMap(_users[position]).id}"),
              onTap: () =>
                  debugPrint("${User.fromMap(_users[position]).password}"),
            ),
          );
        },
      ),
    );
  }
}
