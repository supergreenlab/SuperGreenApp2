import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';

abstract class BoxFeedBlocEvent extends Equatable {}

abstract class BoxFeedBlocState extends Equatable {
  final Box box;

  BoxFeedBlocState(this.box);
}

class BoxFeedBlocStateInit extends BoxFeedBlocState {
  BoxFeedBlocStateInit(Box box) : super(box);

  @override
  List<Object> get props => [box];
}

class BoxFeedBlocStateFeedLoaded extends BoxFeedBlocState {
  BoxFeedBlocStateFeedLoaded(Box box, Feed feed) : super(box);

  @override
  List<Object> get props => [box];
}

class BoxFeedBloc
    extends Bloc<BoxFeedBlocEvent, BoxFeedBlocState> {
  final HomeNavigateToBoxFeedEvent _args;

  BoxFeedBloc(this._args);

  @override
  BoxFeedBlocState get initialState => BoxFeedBlocStateInit(_args.box);

  @override
  Stream<BoxFeedBlocState> mapEventToState(
      BoxFeedBlocEvent event) async* {}
}
