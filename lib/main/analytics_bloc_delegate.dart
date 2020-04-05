import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_matomo/flutter_matomo.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feed/app_bar/plant_feed_app_bar_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feed/plant_drawer_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feed/plant_feed_bloc.dart';

List<bool Function(Equatable)> filteredEvents = [
  (e) => e is DeviceDaemonBlocEventDeviceReachable,
  (e) => e is PlantFeedAppBarBlocEventReloadChart,
  (e) => e is PlantFeedAppBarBlocEventLoadChart,
  (e) => e is FeedBlocEventFeedEntriesListUpdated,
  (e) => e is DeviceDaemonBlocEventLoadDevice,
  (e) => e is PlantDrawerBlocEventBoxListUpdated,
  (e) => e is PlantFeedBlocEventLoad,
];

class AnalyticsBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    try {
      filteredEvents.singleWhere((fn) => fn(transition.event));
    } catch (e) {
      FlutterMatomo.trackEventWithName('AnalyticsBlocDelegate', 'onTransition',
          transition.event.runtimeType.toString());
    }
  }
}
