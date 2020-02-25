
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/form/feed_care_common_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_topping/form/feed_topping_form_bloc.dart';

class FeedToppingFormPage extends FeedCareCommonFormPage<FeedToppingFormBloc> {
  @override
  String title() {
    return 'Topping log';
  }
}
