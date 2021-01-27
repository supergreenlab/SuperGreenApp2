import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class PlantFeedState extends FeedState {
  final PlantSettings plantSettings;
  final BoxSettings boxSettings;

  PlantFeedState(
      bool loggedIn, String storeGeo, this.plantSettings, this.boxSettings)
      : super(loggedIn, storeGeo);

  @override
  List<Object> get props => [...super.props, plantSettings, boxSettings];

  FeedState copyWith({
    bool loggedIn,
    String storeGeo,
    PlantSettings plantSettings,
    BoxSettings boxSettings,
  }) {
    return PlantFeedState(
      loggedIn ?? this.loggedIn,
      storeGeo ?? this.storeGeo,
      plantSettings ?? this.plantSettings,
      boxSettings ?? this.boxSettings,
    );
  }
}
