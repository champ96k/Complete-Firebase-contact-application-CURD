import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hello/TodoDetail.dart';
import 'package:hello/Update.dart';

import 'myData.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    loadcontact();
    super.initState();
  }

  List<myData> allData = [];
  loadcontact() async {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    print("before child");
    ref.child('contact').once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        myData d = new myData(
          data[key]['name'],
          data[key]['phone'],
          data[key]['email'],
          data[key]['address'],
          data[key]['image'],
        );
        allData.add(d);
        print(data[key]['phone']);
        print("upto object");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: ListView.builder(
        itemCount: allData.length,
        itemBuilder: (context, index) {
          return Center(
            child: allData.length == 0
                ? CircularProgressIndicator()
                : GestureDetector(
                    child: Card(
                      child: Column(children: <Widget>[
                        CircleAvatar(
                          child: Image.network(allData[index].imageurl),
                        ),
                        Text(allData[index].name),
                        Text(allData[index].phone)
                      ]),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Update(allData[index])));
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("upto push method");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TodoDetail()));
        },
        child: Icon(Icons.note_add),
      ),
    );
  }
}
