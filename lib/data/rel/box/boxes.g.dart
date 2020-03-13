// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boxes.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$BoxesDAOMixin on DatabaseAccessor<RelDB> {
  $BoxesTable get boxes => db.boxes;
  $ChartCachesTable get chartCaches => db.chartCaches;
  Selectable<int> nBoxes() {
    return customSelectQuery('SELECT COUNT(*) FROM boxes',
        variables: [],
        readsFrom: {boxes}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }
}
