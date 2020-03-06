import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/towelie_action_help.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionHelpTestDevice extends TowelieActionHelp {
  @override
  String get route => '/device/test';

  @override
  Stream<TowelieBlocState> trigger(TowelieBlocEventRoute event) async* {
    final ddb = RelDB.get().devicesDAO;
    int nDevices = await ddb.nDevices().getSingle();
    if (nDevices == 1) {
      yield TowelieBlocStateHelper(
          event.settings, SGLLocalizations.current.towelieHelperTestDevice);
    }
  }
}
