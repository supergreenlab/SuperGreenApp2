import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/settings/plant_settings.dart';

class PlantFeedState extends FeedState {
  final PlantSettings plantSettings;
  final BoxSettings boxSettings;

  PlantFeedState(String storeGeo, this.plantSettings, this.boxSettings)
      : super(storeGeo);

  @override
  List<Object> get props => [...super.props, plantSettings, boxSettings];

  FeedState copyWith({
    String storeGeo,
    PlantSettings plantSettings,
    BoxSettings boxSettings,
  }) {
    return PlantFeedState(
      storeGeo ?? this.storeGeo,
      plantSettings ?? this.plantSettings,
      boxSettings ?? this.boxSettings,
    );
  }
}
