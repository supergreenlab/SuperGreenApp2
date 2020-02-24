import 'package:super_green_app/pages/feed_entries/feed_defoliation/form/feed_defoliation_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_training/form/feed_training_form_page.dart';

class FeedDefoliationFormPage
    extends FeedTrainingFormPage<FeedDefoliationFormBloc> {
  @override
  String title() {
    return 'Defoliation log';
  }
}
