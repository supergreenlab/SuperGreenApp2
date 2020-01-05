import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class SGLFeedBlocEvent extends Equatable {}

abstract class SGLFeedBlocState extends Equatable {
  final Feed feed;

  SGLFeedBlocState(this.feed);
}

class SGLFeedBlocStateInit extends SGLFeedBlocState {
  SGLFeedBlocStateInit(Feed feed) : super(feed);

  @override
  List<Object> get props => [this.feed];
}

class SGLFeedBloc
    extends Bloc<SGLFeedBlocEvent, SGLFeedBlocState> {
  final Feed _feed;

  SGLFeedBloc() : this._feed = Feed(id: 0, name: 'SuperGreenLab');

  @override
  SGLFeedBlocState get initialState => SGLFeedBlocStateInit(_feed);

  @override
  Stream<SGLFeedBlocState> mapEventToState(
      SGLFeedBlocEvent event) async* {}
}
