// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklists.dart';

// ignore_for_file: type=lint
mixin _$ChecklistsDAOMixin on DatabaseAccessor<RelDB> {
  $ChecklistsTable get checklists => attachedDatabase.checklists;
  $ChecklistSeedsTable get checklistSeeds => attachedDatabase.checklistSeeds;
  $ChecklistLogsTable get checklistLogs => attachedDatabase.checklistLogs;
  $ChecklistCollectionsTable get checklistCollections =>
      attachedDatabase.checklistCollections;
  Selectable<int> getNLogs(int var1) {
    return customSelect(
        'SELECT count(*) AS _c0 FROM checklist_logs WHERE checked = FALSE AND skipped = FALSE AND checklist = ?1',
        variables: [
          Variable<int>(var1)
        ],
        readsFrom: {
          checklistLogs,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }

  Selectable<int> getNLogsTotal() {
    return customSelect(
        'SELECT count(*) AS _c0 FROM checklist_logs WHERE checked = FALSE AND skipped = FALSE',
        variables: [],
        readsFrom: {
          checklistLogs,
        }).map((QueryRow row) => row.read<int>('_c0'));
  }

  Selectable<GetNLogsPerPlantsResult> getNLogsPerPlants() {
    return customSelect(
        'SELECT checklists.plant, (SELECT count(*) FROM checklist_logs WHERE checked = FALSE AND skipped = FALSE AND checklist_logs.checklist = checklists.id) AS nPending FROM checklists WHERE nPending > 0',
        variables: [],
        readsFrom: {
          checklists,
          checklistLogs,
        }).map((QueryRow row) => GetNLogsPerPlantsResult(
          plant: row.read<int>('plant'),
          nPending: row.read<int>('nPending'),
        ));
  }

  Selectable<ChecklistSeed> searchSeeds(String searchTerms, int checklistid) {
    return customSelect(
        'SELECT checklist_seeds.* FROM checklist_seeds WHERE(title LIKE \'%\' || ?1 || \'%\' OR description LIKE \'%\' || ?1 || \'%\' OR actions LIKE \'%\' || ?1 || \'%\' OR conditions LIKE \'%\' || ?1 || \'%\' OR exitConditions LIKE \'%\' || ?1 || \'%\')AND checklist = ?2 ORDER BY mine DESC, id DESC',
        variables: [
          Variable<String>(searchTerms),
          Variable<int>(checklistid)
        ],
        readsFrom: {
          checklistSeeds,
        }).asyncMap(checklistSeeds.mapFromRow);
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
