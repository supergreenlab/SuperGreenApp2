import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';

class BoxFeedState extends FeedState {
  final BoxSettings boxSettings;

  BoxFeedState(bool loggedIn, String storeGeo, this.boxSettings)
      : super(loggedIn, storeGeo);

  @override
  List<Object> get props => [...super.props, boxSettings];

  FeedState copyWith({
    bool loggedIn,
    String storeGeo,
    BoxSettings boxSettings,
  }) {
    return BoxFeedState(
      loggedIn ?? this.loggedIn,
      storeGeo ?? this.storeGeo,
      boxSettings ?? this.boxSettings,
    );
  }
}
