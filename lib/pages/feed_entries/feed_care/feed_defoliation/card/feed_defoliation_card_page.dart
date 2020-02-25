
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/card/feed_care_common_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_defoliation/card/feed_defoliation_card_bloc.dart';

class FeedDefoliationCardPage extends FeedCareCommonCardPage<FeedDefoliationCardBloc> {

  String iconPath() {
    return 'assets/feed_card/icon_defoliation.svg';
  }

  @override
  String title() {
    return "Defoliation";
  }

}
