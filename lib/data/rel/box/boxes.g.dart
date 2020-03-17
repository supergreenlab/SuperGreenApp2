// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boxes.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$BoxesDAOMixin on DatabaseAccessor<RelDB> {
  $BoxesTable get boxes => db.boxes;
  $ChartCachesTable get chartCaches => db.chartCaches;
  $TimelapsesTable get timelapses => db.timelapses;
  Selectable<int> nBoxes() {
    return customSelectQuery('SELECT COUNT(*) FROM boxes',
        variables: [],
        readsFrom: {boxes}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }

  Selectable<int> nTimelapses(int var1) {
    return customSelectQuery('SELECT COUNT(*) FROM timelapses WHERE box = ?',
        variables: [Variable.withInt(var1)],
        readsFrom: {timelapses}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }
}
