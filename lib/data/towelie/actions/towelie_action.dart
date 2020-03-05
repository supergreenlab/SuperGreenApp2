import 'package:super_green_app/data/towelie/towelie_bloc.dart';

abstract class TowelieAction {
  Stream<TowelieBlocState> eventReceived(TowelieBlocEvent event);
}
