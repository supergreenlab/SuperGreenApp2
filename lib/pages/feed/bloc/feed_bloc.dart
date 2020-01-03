import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedBlocEvent extends Equatable {}

abstract class FeedBlocState extends Equatable {
  final Device device;

  FeedBlocState(this.device);
}

class FeedBlocStateInit extends FeedBlocState {
  FeedBlocStateInit(Device device) : super(device);

  @override
  List<Object> get props => [];
}

class FeedBloc
    extends Bloc<FeedBlocEvent, FeedBlocState> {
  final MainNavigateToFeedEvent _args;

  FeedBloc(this._args);

  @override
  FeedBlocState get initialState => FeedBlocStateInit(_args.device);

  @override
  Stream<FeedBlocState> mapEventToState(
      FeedBlocEvent event) async* {}
}
