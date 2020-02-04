import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class BoxInfosBlocEvent extends Equatable {}

class BoxInfosBlocEventCreateBox extends BoxInfosBlocEvent {
  final String name;
  BoxInfosBlocEventCreateBox(this.name);

  @override
  List<Object> get props => [];
}

abstract class BoxInfosBlocState extends Equatable {}

class BoxInfosBlocStateIdle extends BoxInfosBlocState {
  @override
  List<Object> get props => [];
}

class BoxInfosBlocStateDone extends BoxInfosBlocState {
  final Box box;
  BoxInfosBlocStateDone(this.box);

  @override
  List<Object> get props => [box];
}

class BoxInfosBloc extends Bloc<BoxInfosBlocEvent, BoxInfosBlocState> {
  @override
  BoxInfosBlocState get initialState => BoxInfosBlocStateIdle();

  @override
  Stream<BoxInfosBlocState> mapEventToState(BoxInfosBlocEvent event) async* {
    if (event is BoxInfosBlocEventCreateBox) {
      final bdb = RelDB.get().boxesDAO;
      final fdb = RelDB.get().feedsDAO;
      final feed = FeedsCompanion.insert(name: event.name);
      final feedID = await fdb.addFeed(feed);
      final box = BoxesCompanion.insert(feed: feedID, name: event.name);
      final boxID = await bdb.addBox(box);
      final b = await bdb.getBox(boxID);
      yield BoxInfosBlocStateDone(b);
    }
  }
}
