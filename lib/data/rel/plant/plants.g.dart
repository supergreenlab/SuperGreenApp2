// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plants.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PlantsDAOMixin on DatabaseAccessor<RelDB> {
  $PlantsTable get plants => attachedDatabase.plants;
  $BoxesTable get boxes => attachedDatabase.boxes;
  $ChartCachesTable get chartCaches => attachedDatabase.chartCaches;
  $TimelapsesTable get timelapses => attachedDatabase.timelapses;
  Selectable<int> nPlants() {
    return customSelect('SELECT COUNT(*) FROM plants',
        variables: [],
        readsFrom: {
          plants,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }

  Selectable<int> nBoxes() {
    return customSelect('SELECT COUNT(*) FROM boxes',
        variables: [],
        readsFrom: {
          boxes,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }

  Selectable<int> nTimelapses(int var1) {
    return customSelect('SELECT COUNT(*) FROM timelapses WHERE plant = ?',
        variables: [
          Variable<int>(var1)
        ],
        readsFrom: {
          timelapses,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }

  Selectable<int> nPlantsInBox(int var1) {
    return customSelect('SELECT COUNT(*) FROM plants WHERE box = ?',
        variables: [
          Variable<int>(var1)
        ],
        readsFrom: {
          plants,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }
}
