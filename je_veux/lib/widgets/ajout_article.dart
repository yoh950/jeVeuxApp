import 'dart:io';
import 'package:je_veux/model/article.dart';
import 'package:flutter/material.dart';
import 'package:je_veux/model/databaseClient.dart';
import 'package:je_veux/model/databaseClient.dart';

class Ajout extends StatefulWidget {
  int id;
  Ajout(int id) {
    this.id = id;
  }

  @override
  _AjoutState createState() => _AjoutState();
}

class _AjoutState extends State<Ajout> {
  String image;
  String nom;
  String magasin;
  String prix;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        title: Text('ajouter'),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: ajouter,
            child: Text(
              'Valider',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(children: [
          Text(
            'Article a ajouter',
            textScaleFactor: 1.4,
            style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
          ),
          Card(
            elevation: 10.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (image == null)
                    ? Image.asset('images/question.jpg')
                    : Image.file(File(image)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: Icon(Icons.camera), onPressed: null),
                    IconButton(icon: Icon(Icons.photo_library), onPressed: null)
                  ],
                ),
                textField(TypeTextField.nom, 'Nom de l\'article'),
                textField(TypeTextField.prix, 'Prix'),
                textField(TypeTextField.magasin, 'Magasin'),
              ],
            ),
          )
        ]),
      ),
    );
  }

  TextField textField(TypeTextField type, String label) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: (String string) {
        switch (type) {
          case TypeTextField.nom:
            nom = string;
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
      },
    );
  }

  void ajouter() {
    if (nom != null) {
      Map<String, dynamic> map = {'nom': nom, 'item': widget.id};
      if (magasin != null) {
        map['magasin'] = magasin;
      }
      if (prix != null) {
        map['prix'] = prix;
      }
      if (image != null) {
        map['image'] = image;
      }
      Article article = Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        image = null;
        nom = null;
        magasin = null;
        prix = null;
        Navigator.pop(context);
      });
    }
  }
}

enum TypeTextField { nom, prix, magasin }
