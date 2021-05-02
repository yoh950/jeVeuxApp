import 'package:flutter/material.dart';
import 'package:je_veux/model/item.dart';
import 'package:je_veux/model/article.dart';
import 'package:je_veux/widgets/donnees_vides.dart';
import 'package:je_veux/widgets/ajout_article.dart';
import 'package:je_veux/model/databaseClient.dart';
import 'dart:io';

class ItemDetail extends StatefulWidget {
  Item item;

  ItemDetail(Item item) {
    this.item = item;
  }

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<Article> articles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseClient().allArticles(widget.item.id).then((liste) {
      setState(() {
        articles = liste;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.nom),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Ajout(widget.item.id);
                })).then((value) {
                  DatabaseClient().allArticles(widget.item.id).then((liste) {
                    setState(() {
                      articles = liste;
                    });
                  });
                });
              },
              child: Text(
                'ajouter',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: (articles != null || articles.length != 0)
          ? DonneesVides()
          : GridView.builder(
              itemCount: articles.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, i) {
                Article article = articles[i];
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(article.nom),
                      (article.image == null)
                          ? Image.asset(null)
                          : Image.file(null),
                      Text((article.prix == null)
                          ? 'Aucun prix renseigner'
                          : "Prix: ${article.prix}"),
                      Text((article.magasin == null)
                          ? 'Aucun magasin renseigné'
                          : "Magasin: ${article.magasin}"),
                    ],
                  ),
                );
              }),
    );
  }
}
