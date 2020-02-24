import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_training/form/feed_training_form_bloc.dart';

class FeedFimmingFormBloc extends FeedTrainingFormBloc {
  FeedFimmingFormBloc(MainNavigateToFeedTrainingFormEvent args)
      : super(args);

  @override
  String cardType() {
    return 'FE_FIMMING';
  }
}
