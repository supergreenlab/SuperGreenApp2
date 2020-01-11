import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class FeedBlocEvent extends Equatable {}

class FeedBlocEventLoadFeed extends FeedBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedBlocEventFeedEntriesListUpdated extends FeedBlocEvent {
  final List<FeedEntry> _feedEntries;

  FeedBlocEventFeedEntriesListUpdated(this._feedEntries);

  @override
  List<Object> get props => [_feedEntries];
}

abstract class FeedBlocState extends Equatable {}

class FeedBlocStateInit extends FeedBlocState {
  FeedBlocStateInit() : super();

  @override
  List<Object> get props => [];
}

class FeedBlocStateLoaded extends FeedBlocState {
  final Feed feed;
  final List<FeedEntry> entries;

  FeedBlocStateLoaded(this.feed, this.entries);

  @override
  List<Object> get props => [feed, entries];
}

class FeedBloc extends Bloc<FeedBlocEvent, FeedBlocState> {
  final int _feedID;
  Feed _feed;

  FeedBloc(this._feedID) {
    add(FeedBlocEventLoadFeed());
  }

  @override
  FeedBlocState get initialState => FeedBlocStateInit();

  @override
  Stream<FeedBlocState> mapEventToState(FeedBlocEvent event) async* {
    if (event is FeedBlocEventLoadFeed) {
      final fdb = RelDB.get().feedsDAO;
      _feed = await fdb.getFeed(_feedID);
      final entries = fdb.watchEntries(_feedID);
      entries.listen(_onFeedEntriesChange);
    } else if (event is FeedBlocEventFeedEntriesListUpdated) {
      yield FeedBlocStateLoaded(_feed, event._feedEntries);
    }
  }

  void _onFeedEntriesChange(List<FeedEntry> entries) {
    add(FeedBlocEventFeedEntriesListUpdated(entries));
  }
}
