import 'package:super_green_app/pages/feed_entries/feed_topping/card/feed_topping_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_training/card/feed_training_card_page.dart';

class FeedToppingCardPage extends FeedTrainingCardPage<FeedToppingCardBloc> {

  String iconPath() {
    return 'assets/feed_card/icon_topping.svg';
  }

  @override
  String title() {
    return "Topping";
  }

}
