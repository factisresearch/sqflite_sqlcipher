import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_example/open_test_page.dart';

import 'test_page.dart';

class SqlCipherTestPage extends TestPage {
  SqlCipherTestPage() : super("SqlCipher tests") {
    test('Open and query database', () async {
      String path = await initDeleteDb("encrypted.db");

      expect(await isDatabase(path), isFalse);

      const String password = "1234";

      Database db = await openDatabase(
        path,
        password: password,
        version: 1,
        onCreate: (db, version) async {
          Batch batch = db.batch();

          batch
              .execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, text NAME)");
          await batch.commit();
        },
      );

      try {
        expect(
            await db.rawInsert("INSERT INTO Test (text) VALUES (?)", ['test']),
            1);
        var result = await db.query("Test");
        List expected = [
          {'id': 1, 'text': 'test'}
        ];
        expect(result, expected);

        expect(await isDatabase(path, password: password), isTrue);
      } finally {
        await db?.close();
      }
      expect(await isDatabase(path, password: password), isTrue);
    });

    test("Open asset database", () async {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, "asset_example.db");

      // delete existing if any
      await deleteDatabase(path);

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "example_pass_1234.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

      // open the database
      Database db = await openDatabase(path, password: "1234");

      // Our database as a single table with a single element
      List<Map<String, dynamic>> list = await db.rawQuery("SELECT * FROM Test");
      print("list $list");
      expect(list.first["name"], "simple value");

      await db.close();
    });
  }
}
