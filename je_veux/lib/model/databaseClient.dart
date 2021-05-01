import 'dart:io';
import 'package:je_veux/model/item.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClient {
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      //creer database
      _database = await create();
      return _database;
    }
  }

  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db');
    var bdd =
        await openDatabase(database_directory, version: 1, onCreate: _onCreate);
    return bdd;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE item (id INTEGER PRIMARY KEY, nom TEXT NOT NULL)''');
  }

  /* Ecrire les donnees */
  Future<Item> ajoutItem(Item item) async {
    Database maDatabase = await database;
    item.id = await maDatabase.insert('item', item.toMap());
    return item;
  }

  /* Lecture des données*/
  Future<List<Item>> allItem() async {
    Database maDatabase = await database;
    List<Map<String, dynamic>> resultat =
        await maDatabase.rawQuery('SELECT * FROM item');
    List<Item> items = [];
    resultat.forEach((map) {
      Item item = Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }
}
