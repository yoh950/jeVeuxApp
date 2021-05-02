import 'package:flutter/material.dart';
import 'dart:async';
import 'package:je_veux/model/item.dart';
import 'package:je_veux/widgets/donnees_vides.dart';
import 'package:je_veux/model/databaseClient.dart';
import 'package:je_veux/widgets/itemDetail.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  String nouvelleListe;
  List<Item> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: (() => ajouter(null)),
            child: Text(
              "Ajouter",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: (items == null || items.length == 0)
          ? DonneesVides()
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                Item item = items[i];
                return ListTile(
                  title: Text(item.nom),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      DatabaseClient().delete(item.id, 'item').then((int) {
                        print("L'int recupéré est : $int");
                        recuperer();
                      });
                    },
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (() => ajouter(item)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext buildcontext) {
                          return ItemDetail(item);
                        },
                      ),
                    );
                  },
                );
              }),
    );
  }

  Future<Null> ajouter(Item item) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext builtcontext) {
        return AlertDialog(
          title: Text('Ajouter une liste de souhait'),
          content: TextField(
            decoration: InputDecoration(
              labelText: "Liste",
              hintText:
                  (item == null) ? "ex: mes prochains jeux vidéos" : item.nom,
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
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {
                if (nouvelleListe != null) {
                  if (item == null) {
                    item = Item();
                    Map<String, dynamic> map = {'nom': nouvelleListe};
                    item.fromMap(map);
                  } else {
                    item.nom = nouvelleListe;
                  }

                  DatabaseClient().upsertItem(item).then((i) => recuperer());
                  nouvelleListe = null;
                }
                Navigator.pop(builtcontext);
              },
              child: Text(
                'Valider',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        );
      },
    );
  }

  void recuperer() {
    DatabaseClient().allItem().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}
