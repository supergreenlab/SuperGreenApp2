
import 'package:super_green_app/towelie/towelie_bloc.dart';

abstract class TowelieAction {
  Stream<TowelieBlocState> eventReceived(TowelieBlocEvent event);
}
