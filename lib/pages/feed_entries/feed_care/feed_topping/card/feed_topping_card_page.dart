
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/card/feed_care_common_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_topping/card/feed_topping_card_bloc.dart';

class FeedToppingCardPage extends FeedCareCommonCardPage<FeedToppingCardBloc> {

  String iconPath() {
    return 'assets/feed_card/icon_topping.svg';
  }

  @override
  String title() {
    return "Topping";
  }

}
