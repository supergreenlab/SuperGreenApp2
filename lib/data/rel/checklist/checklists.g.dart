// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklists.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ChecklistsDAOMixin on DatabaseAccessor<RelDB> {
  $ChecklistsTable get checklists => attachedDatabase.checklists;
  $ChecklistSeedsTable get checklistSeeds => attachedDatabase.checklistSeeds;
  $ChecklistLogsTable get checklistLogs => attachedDatabase.checklistLogs;
  $ChecklistCollectionsTable get checklistCollections =>
      attachedDatabase.checklistCollections;
  Selectable<int> getNLogs(int var1) {
    return customSelect(
        'select count(*) from checklist_logs where checked=false and skipped=false and checklist=?',
        variables: [
          Variable<int>(var1)
        ],
        readsFrom: {
          checklistLogs,
        }).map((QueryRow row) => row.read<int>('count(*)'));
  }

  Selectable<int> getNLogsTotal() {
    return customSelect(
        'select count(*) from checklist_logs where checked=false and skipped=false',
        variables: [],
        readsFrom: {
          checklistLogs,
        }).map((QueryRow row) => row.read<int>('count(*)'));
  }

  Selectable<GetNLogsPerPlantsResult> getNLogsPerPlants() {
    return customSelect(
        'select\n      checklists.plant,\n      (select\n        count(*)\n        from checklist_logs\n        where checked=false and skipped=false and checklist_logs.checklist = checklists.id\n      ) as nPending\n    from checklists where nPending > 0',
        variables: [],
        readsFrom: {
          checklists,
          checklistLogs,
        }).map((QueryRow row) {
      return GetNLogsPerPlantsResult(
        plant: row.read<int>('plant'),
        nPending: row.read<int>('nPending'),
      );
    });
  }
}

class GetNLogsPerPlantsResult {
  final int plant;
  final int nPending;
  GetNLogsPerPlantsResult({
    required this.plant,
    required this.nPending,
  });
}
