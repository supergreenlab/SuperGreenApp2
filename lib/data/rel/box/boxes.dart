import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

part 'boxes.g.dart';

@DataClassName("Box")
class Boxes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  IntColumn get device => integer().nullable()();
  IntColumn get deviceBox => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
}

@UseDao(tables: [Boxes])
class BoxesDAO extends DatabaseAccessor<RelDB> with _$BoxesDAOMixin {
  BoxesDAO(RelDB db) : super(db);

  Future<Box> getBox(int id) {
    return (select(boxes)..where((b) => b.id.equals(id))).getSingle();
  }

  Future<int> addBox(BoxesCompanion box) {
    return into(boxes).insert(box);
  }

  Future updateBox(int boxID, BoxesCompanion box) {
    return (update(boxes)..where((b) => b.id.equals(boxID))).write(box);
  }

  Stream<List<Box>> watchBoxes() {
    return select(boxes).watch();
  }
}
