import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';

abstract class FeedBlocEvent extends Equatable {}

abstract class FeedBlocState extends Equatable {
  final Feed feed;

  FeedBlocState(this.feed);
}

class FeedBlocStateInit extends FeedBlocState {
  FeedBlocStateInit(Feed feed) : super(feed);

  @override
  List<Object> get props => [this.feed];
}

class FeedBloc
    extends Bloc<FeedBlocEvent, FeedBlocState> {
  final HomeNavigateToFeedEvent _args;

  FeedBloc(this._args);

  @override
  FeedBlocState get initialState => FeedBlocStateInit(_args.feed);

  @override
  Stream<FeedBlocState> mapEventToState(
      FeedBlocEvent event) async* {}
}
