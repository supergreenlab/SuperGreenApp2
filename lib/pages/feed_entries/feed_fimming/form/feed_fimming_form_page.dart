import 'package:super_green_app/pages/feed_entries/feed_fimming/form/feed_fimming_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_training/form/feed_training_form_page.dart';

class FeedFimmingFormPage extends FeedTrainingFormPage<FeedFimmingFormBloc> {
  @override
  String title() {
    return 'Fimming log';
  }
}
