import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class BoxDrawerBlocEvent extends Equatable {}

class BoxDrawerBlocEventLoadBoxes extends BoxDrawerBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxDrawerBlocEventBoxListUpdated extends BoxDrawerBlocEvent {
  final List<Box> boxes;

  BoxDrawerBlocEventBoxListUpdated(this.boxes);

  @override
  List<Object> get props => [boxes];
}

abstract class BoxDrawerBlocState extends Equatable {}

class BoxDrawerBlocStateLoadingBoxList extends BoxDrawerBlocState {
  @override
  List<Object> get props => [];
}

class BoxDrawerBlocStateBoxListUpdated extends BoxDrawerBlocState {
  final List<Box> boxes;

  BoxDrawerBlocStateBoxListUpdated(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class BoxDrawerBloc extends Bloc<BoxDrawerBlocEvent, BoxDrawerBlocState> {
  @override
  BoxDrawerBlocState get initialState => BoxDrawerBlocStateLoadingBoxList();

  BoxDrawerBloc() {
    add(BoxDrawerBlocEventLoadBoxes());
  }

  @override
  Stream<BoxDrawerBlocState> mapEventToState(BoxDrawerBlocEvent event) async* {
    if (event is BoxDrawerBlocEventLoadBoxes) {
      final db = RelDB.get().boxesDAO;
      Stream<List<Box>> boxesStream = db.watchBoxes();
      boxesStream.listen(_onBoxListChange);
    } else if (event is BoxDrawerBlocEventBoxListUpdated) {
      yield BoxDrawerBlocStateBoxListUpdated(event.boxes);
    }
  }

  void _onBoxListChange(List<Box> boxes) {
    add(BoxDrawerBlocEventBoxListUpdated(boxes));
  }
}
