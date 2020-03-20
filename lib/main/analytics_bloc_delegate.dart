import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_matomo/flutter_matomo.dart';

class AnalyticsBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    FlutterMatomo.trackEventWithName('AnalyticsBlocDelegate', 'onTransition',
        transition.event.runtimeType.toString());
  }
}
