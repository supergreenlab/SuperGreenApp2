
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/form/feed_care_common_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_defoliation/form/feed_defoliation_form_bloc.dart';

class FeedDefoliationFormPage
    extends FeedCareCommonFormPage<FeedDefoliationFormBloc> {
  @override
  String title() {
    return 'Defoliation log';
  }
}
