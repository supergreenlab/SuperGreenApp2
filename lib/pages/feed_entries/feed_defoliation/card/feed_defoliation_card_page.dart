import 'package:super_green_app/pages/feed_entries/feed_defoliation/card/feed_defoliation_card_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_training/card/feed_training_card_page.dart';

class FeedDefoliationCardPage extends FeedTrainingCardPage<FeedDefoliationCardBloc> {

  String iconPath() {
    return 'assets/feed_card/icon_defoliation.svg';
  }

  @override
  String title() {
    return "Defoliation";
  }

}
