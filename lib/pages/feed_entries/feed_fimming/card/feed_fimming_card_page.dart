import 'package:super_green_app/pages/feed_entries/feed_fimming/card/feed_fimming_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_training/card/feed_training_card_page.dart';

class FeedFimmingCardPage extends FeedTrainingCardPage<FeedFimmingCardBloc> {

  String iconPath() {
    return 'assets/feed_card/icon_fimming.svg';
  }

  @override
  String title() {
    return "Fimming";
  }

}
