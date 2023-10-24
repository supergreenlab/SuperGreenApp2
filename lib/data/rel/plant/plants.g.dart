// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plants.dart';

// ignore_for_file: type=lint
mixin _$PlantsDAOMixin on DatabaseAccessor<RelDB> {
  $PlantsTable get plants => attachedDatabase.plants;
  $BoxesTable get boxes => attachedDatabase.boxes;
  $ChartCachesTable get chartCaches => attachedDatabase.chartCaches;
  $TimelapsesTable get timelapses => attachedDatabase.timelapses;
  Selectable<int> nPlants() {
    return customSelect('SELECT COUNT(*) AS _c0 FROM plants',
        variables: [],
        readsFrom: {
          plants,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }

  Selectable<int> nBoxes() {
    return customSelect('SELECT COUNT(*) AS _c0 FROM boxes',
        variables: [],
        readsFrom: {
          boxes,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }

  Selectable<int> nTimelapses(int var1) {
    return customSelect(
        'SELECT COUNT(*) AS _c0 FROM timelapses WHERE plant = ?1',
        variables: [
          Variable<int>(var1)
        ],
        readsFrom: {
          timelapses,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }

  Selectable<int> nPlantsInBox(int var1) {
    return customSelect('SELECT COUNT(*) AS _c0 FROM plants WHERE box = ?1',
        variables: [
          Variable<int>(var1)
        ],
        readsFrom: {
          plants,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }
}
