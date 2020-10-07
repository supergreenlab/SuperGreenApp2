// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plants.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PlantsDAOMixin on DatabaseAccessor<RelDB> {
  $PlantsTable get plants => db.plants;
  $BoxesTable get boxes => db.boxes;
  $ChartCachesTable get chartCaches => db.chartCaches;
  $TimelapsesTable get timelapses => db.timelapses;
  Selectable<int> nPlants() {
    return customSelectQuery('SELECT COUNT(*) FROM plants',
        variables: [],
        readsFrom: {plants}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }

  Selectable<int> nBoxes() {
    return customSelectQuery('SELECT COUNT(*) FROM boxes',
        variables: [],
        readsFrom: {boxes}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }

  Selectable<int> nTimelapses(int var1) {
    return customSelectQuery('SELECT COUNT(*) FROM timelapses WHERE plant = ?',
        variables: [Variable.withInt(var1)],
        readsFrom: {timelapses}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }

  Selectable<int> nPlantsInBox(int var1) {
    return customSelectQuery('SELECT COUNT(*) FROM plants WHERE box = ?',
        variables: [Variable.withInt(var1)],
        readsFrom: {plants}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }
}
