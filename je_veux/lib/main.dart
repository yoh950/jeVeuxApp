import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Je Veux App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String nouvelleListe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: ajouter,
            child: Text(
              "Ajouter",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Center(),
    );
  }

  Future<Null> ajouter() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext builtcontext) {
        return AlertDialog(
          title: Text('Ajouter une liste de souhait'),
          content: TextField(
            decoration: InputDecoration(
              labelText: "Liste",
              hintText: "ex: mes prochains jeux vidéos",
            ),
            onChanged: (String str) {
              nouvelleListe = str;
            },
          ),
          actions: [
            TextButton(
              onPressed: (() => Navigator.pop(builtcontext)),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: null,
              child: Text('Valider'),
            )
          ],
        );
      },
    );
  }
}
