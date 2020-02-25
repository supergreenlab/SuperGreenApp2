import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/card/feed_care_common_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_fimming/card/feed_fimming_card_bloc.dart';

class FeedFimmingCardPage extends FeedCareCommonCardPage<FeedFimmingCardBloc> {

  String iconPath() {
    return 'assets/feed_card/icon_fimming.svg';
  }

  @override
  String title() {
    return "Fimming";
  }

}
