import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:super_green_app/data/rel/box/boxes.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';

part 'rel_db.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Devices, Modules, Params, Boxes, Feeds, FeedEntries], daos: [DevicesDAO, BoxesDAO, FeedsDAO])
class RelDB extends _$RelDB {
  static RelDB _instance;

  factory RelDB.get() {
    if (_instance == null) {
      _instance = RelDB();
    }
    return _instance;
  }

  // we tell the database where to store the data with this constructor
  RelDB() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}
