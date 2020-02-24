import 'package:super_green_app/pages/feed_entries/feed_topping/form/feed_topping_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_training/form/feed_training_form_page.dart';

class FeedToppingFormPage extends FeedTrainingFormPage<FeedToppingFormBloc> {
  @override
  String title() {
    return 'Topping log';
  }
}
