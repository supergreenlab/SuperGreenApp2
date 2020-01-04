import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

part 'boxes.g.dart';

@DataClassName("Box")
class Boxes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get feed => integer()();
  IntColumn get device => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
}

@UseDao(tables: [Boxes])
class BoxesDAO extends DatabaseAccessor<RelDB> with _$BoxesDAOMixin {
  BoxesDAO(RelDB db) : super(db);

  Stream<List<Box>> watchBoxes() {
    return select(boxes).watch();
  }
}
