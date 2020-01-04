import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class HomeBlocEvent extends Equatable {}

class HomeBlocEventLoadControllers extends HomeBlocEvent {
  @override
  List<Object> get props => [];
}

class HomeBlocEventBoxListUpdated extends HomeBlocEvent {
  final List<Box> boxes;

  HomeBlocEventBoxListUpdated(this.boxes);

  @override
  List<Object> get props => [boxes];
}

abstract class HomeBlocState extends Equatable {}

class HomeBlocStateLoadingBoxList extends HomeBlocState {
  @override
  List<Object> get props => [];
}

class HomeBlocStateBoxListUpdated extends HomeBlocState {
  final List<Box> boxes;

  HomeBlocStateBoxListUpdated(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class HomeBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  @override
  HomeBlocState get initialState => HomeBlocStateLoadingBoxList();

  HomeBloc() {
    add(HomeBlocEventLoadControllers());
  }

  @override
  Stream<HomeBlocState> mapEventToState(HomeBlocEvent event) async* {
    if (event is HomeBlocEventLoadControllers) {
      final db = RelDB.get().boxesDAO;
      Stream<List<Box>> boxesStream = db.watchBoxes();
      boxesStream.listen(_onBoxListChange);
    } else if (event is HomeBlocEventBoxListUpdated) {
      yield HomeBlocStateBoxListUpdated(event.boxes);
    }
  }

  void _onBoxListChange(List<Box> boxes) {
    add(HomeBlocEventBoxListUpdated(boxes));
  }
}
