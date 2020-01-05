import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class NewBoxInfosBlocEvent extends Equatable {}

class NewBoxInfosBlocEventCreateBox extends NewBoxInfosBlocEvent {
  final String name;
  NewBoxInfosBlocEventCreateBox(this.name);

  @override
  List<Object> get props => [];
}

abstract class NewBoxInfosBlocState extends Equatable {}

class NewBoxInfosBlocStateIdle extends NewBoxInfosBlocState {
  @override
  List<Object> get props => [];
}

class NewBoxInfosBlocStateDone extends NewBoxInfosBlocState {
  final Box box;
  NewBoxInfosBlocStateDone(this.box);

  @override
  List<Object> get props => [box];
}

class NewBoxInfosBloc extends Bloc<NewBoxInfosBlocEvent, NewBoxInfosBlocState> {
  @override
  NewBoxInfosBlocState get initialState => NewBoxInfosBlocStateIdle();

  @override
  Stream<NewBoxInfosBlocState> mapEventToState(NewBoxInfosBlocEvent event) async* {
    if (event is NewBoxInfosBlocEventCreateBox) {
      final bdb = RelDB.get().boxesDAO;
      final fdb = RelDB.get().feedsDAO;
      final feed = FeedsCompanion.insert(name: event.name);
      final feedID = await fdb.addFeed(feed);
      final box = BoxesCompanion.insert(device: Value(0), feed: feedID, name: event.name);
      final boxID = await bdb.addBox(box);
      final b = await bdb.getBox(boxID);
      yield NewBoxInfosBlocStateDone(b);
    }
  }
}