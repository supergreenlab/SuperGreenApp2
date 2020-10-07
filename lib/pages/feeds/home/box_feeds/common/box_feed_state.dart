import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';

class BoxFeedState extends FeedState {
  final BoxSettings boxSettings;

  BoxFeedState(String storeGeo, this.boxSettings) : super(storeGeo);

  @override
  List<Object> get props => [...super.props, boxSettings];

  FeedState copyWith({
    String storeGeo,
    BoxSettings boxSettings,
  }) {
    return BoxFeedState(
      storeGeo ?? this.storeGeo,
      boxSettings ?? this.boxSettings,
    );
  }
}
