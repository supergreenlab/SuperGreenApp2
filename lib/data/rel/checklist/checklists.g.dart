// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklists.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ChecklistsDAOMixin on DatabaseAccessor<RelDB> {
  $ChecklistsTable get checklists => attachedDatabase.checklists;
  $ChecklistSeedsTable get checklistSeeds => attachedDatabase.checklistSeeds;
  $ChecklistLogsTable get checklistLogs => attachedDatabase.checklistLogs;
  Selectable<int> getNLogs() {
    return customSelect('select count(*) from checklist_logs',
        variables: [],
        readsFrom: {
          checklistLogs,
        }).map((QueryRow row) => row.read<int>('count(*)'));
  }
}
