import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello/myData.dart';

class Update extends StatefulWidget {
  final udata;
  Update(this.udata);
  @override
  _UpdateState createState() => _UpdateState(udata);
}

class _UpdateState extends State<Update> {
  final myData data;
  _UpdateState(this.data);

  var name = TextEditingController();
  var adress = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();

  updatedata() async {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    var data = {
      "name": name.text,
      "phone": phone.text,
      "email": email.text,
      "address": adress.text,
    };
    reference.child("contact").child(name.text).set(data).then((onValue) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Contect Saved");
    });
  }

  delete(String title) {
    FirebaseDatabase.instance
        .reference()
        .child("contact")
        .child(title)
        .remove();
    Navigator.pop(context);
  }

  @override
  void initState() {
    name.text = data.name;
    adress.text = data.address;
    email.text = data.email;
    phone.text = data.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add todo'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              delete(data.name);
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: CircleAvatar(
                radius: 50,
                child: data.imageurl == null
                    ? Icon(Icons.camera_alt)
                    : Image.network(data.imageurl),
              ),
            ),
            TextField(
              controller: name,
              readOnly: true,
            ),
            TextField(
              controller: email,
            ),
            TextField(
              controller: phone,
            ),
            TextField(
              controller: adress,
            ),
            MaterialButton(
              color: Colors.blue,
              child: Text("Save"),
              onPressed: () {
                print("tap");
                updatedata();
              },
            )
          ],
        ),
      ),
    );
  }
}
