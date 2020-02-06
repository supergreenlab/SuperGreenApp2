import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class BoxInfosBlocEvent extends Equatable {}

class BoxInfosBlocEventCreateBox extends BoxInfosBlocEvent {
  final String name;
  final Device device;
  final int deviceBox;
  BoxInfosBlocEventCreateBox(this.name, {this.device, this.deviceBox});

  @override
  List<Object> get props => [];
}

class BoxInfosBlocState extends Equatable {
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
  BoxInfosBlocState get initialState => BoxInfosBlocState();

  @override
  Stream<BoxInfosBlocState> mapEventToState(BoxInfosBlocEvent event) async* {
    if (event is BoxInfosBlocEventCreateBox) {
      final bdb = RelDB.get().boxesDAO;
      final fdb = RelDB.get().feedsDAO;
      final feed = FeedsCompanion.insert(name: event.name);
      final feedID = await fdb.addFeed(feed);
      BoxesCompanion box;
      if (event.device == null || event.deviceBox == null) {
        box = BoxesCompanion.insert(feed: feedID, name: event.name);
      } else {
        box = BoxesCompanion.insert(feed: feedID, name: event.name, device: Value(event.device.id), deviceBox: Value(event.deviceBox));
      }
      final boxID = await bdb.addBox(box);
      final b = await bdb.getBox(boxID);
      yield BoxInfosBlocStateDone(b);
    }
  }
}
