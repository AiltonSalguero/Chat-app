import 'package:flutter/material.dart';

//FireStore Plugin
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter and FireStore Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///Variable para agregar un brandname al collection
  String _brandname;
  int _sold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //---------------------
        //Barra de navegacion
        appBar: AppBar(
          title: Text('Ailton Chat'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showInputDialog();
            },
          ),
        ),
        //---------------------

        //---------------------
        body: StreamBuilder(
          stream: Firestore.instance.collection('car').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading data... Please wait.');
            //Si tiene datos:
            return Column(
              children: <Widget>[
                Text(snapshot.data.documents[0]['brandname']),
                Text(snapshot.data.documents[0]['sold'].toString()),
              ],
            );
          },
        )
        //---------------------

        );
  }

  Future<Null> showInputDialog() async {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Add a document',
              style: TextStyle(fontSize: 14.0),
            ),
            children: <Widget>[
              //Campos para ingresar los datos
              TextField(
                decoration: InputDecoration(
                  hintText: 'Brand name',
                ),
                onChanged: (value) {
                  _brandname = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Sold',
                ),
                onChanged: (value) {
                  _sold = double.parse(value).round();
                },
              ),

              //Boton para agregar
              RaisedButton(
                child: Text('Add'),
                onPressed: saveDocument,
              ),
            ],
          );
        },
      );
    }

  saveDocument() {
    //Guarda un nuevo documento in el firestore collection.
    Firestore.instance
        .collection('car')
        .add({'brandname': _brandname, 'sold': _sold}).whenComplete(() {
      print('Document added');
    }).catchError((e) {
      print(e);
    });
  }
}
