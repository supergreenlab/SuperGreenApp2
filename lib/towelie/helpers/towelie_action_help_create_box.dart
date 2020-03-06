import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/towelie_action_help.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionHelpCreateBox extends TowelieActionHelp {
  @override
  String get route => '/box/new';

  @override
  Stream<TowelieBlocState> trigger(TowelieBlocEventRoute event) async* {
    final bdb = RelDB.get().boxesDAO;
    int nBoxes = await bdb.nBoxes().getSingle();
    if (nBoxes == 0) {
      yield TowelieBlocStateHelper(
          event.settings, SGLLocalizations.current.towelieHelperCreateBox);
    }
  }
}
