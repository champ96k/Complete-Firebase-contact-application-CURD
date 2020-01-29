import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'myData.dart';

class TodoDetail extends StatefulWidget {
  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  var cname = TextEditingController();
  var cnumber = TextEditingController();
  var cemail = TextEditingController();
  var caddress = TextEditingController();

  File _image;
  List<myData> allData=[];

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  loadcontact() async {

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    print("before child");
      ref.child('contact').once().then((DataSnapshot snap){
        var keys =snap.value.keys;
        var data=snap.value;
        allData.clear();
        for(var key in keys){
          myData d =new myData(
            data[key]['name'],
            data[key]['phone'],
            data[key]['email'],
            data[key]['address'],
            data[key]['image'],
          );
          allData.add(d);
          print("object");
          print(data[key]['phone']);
        }
      });

  }


  updatedata() async {

   final StorageReference storageReference = FirebaseStorage.instance.ref().child("image");
   final StorageUploadTask task = storageReference.child(cname.text).putFile(_image);

    StorageTaskSnapshot storageTaskSnapshot=await task.onComplete;
    String url=await storageTaskSnapshot.ref.getDownloadURL();

    DatabaseReference reference=FirebaseDatabase.instance.reference();
    print(reference);
    var data={
      "name":cname.text,
      "phone":cnumber.text,
      "email":cemail.text,
      "address":caddress.text,
      "image":url
    };
    reference.child("contact").child(cname.text).set(data).then((onValue){
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Contect Saved");

    } );

  }
  @override
  void initState() {
    loadcontact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add todo'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
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
                radius: 30,
                child: _image == null
                    ? Icon(Icons.camera_alt)
                    : Image.file(_image),
              ),
              onTap: () {
                 getImage();
                print("object");
              },
            ),
            TextField(
              controller: cname,
              decoration: InputDecoration(hintText: "name"),
            ),
            TextField(
              controller: cemail,
              decoration: InputDecoration(hintText: "email"),
            ),
            TextField(
              controller: cnumber,
              decoration: InputDecoration(hintText: "Mobile no"),
            ),
            TextField(
              controller: caddress,
              decoration: InputDecoration(hintText: "address"),
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
