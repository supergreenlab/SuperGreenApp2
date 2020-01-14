import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';

abstract class BoxFeedBlocEvent extends Equatable {}

class BoxFeedBlocEventLoadBox extends BoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class BoxFeedBlocState extends Equatable {}

abstract class BoxFeedBlocStateBox extends BoxFeedBlocState {
  final Box box;

  BoxFeedBlocStateBox(this.box);
}

class BoxFeedBlocStateInit extends BoxFeedBlocState {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateBoxLoaded extends BoxFeedBlocStateBox {
  BoxFeedBlocStateBoxLoaded(Box box) : super(box);

  @override
  List<Object> get props => [box];
}

class BoxFeedBloc extends Bloc<BoxFeedBlocEvent, BoxFeedBlocState> {
  final HomeNavigateToBoxFeedEvent _args;

  BoxFeedBloc(this._args) {
    this.add(BoxFeedBlocEventLoadBox());
  }

  @override
  BoxFeedBlocState get initialState => BoxFeedBlocStateInit();

  @override
  Stream<BoxFeedBlocState> mapEventToState(BoxFeedBlocEvent event) async* {
    if (event is BoxFeedBlocEventLoadBox) {
      Box box = _args.box;
      if (box == null) {
        box = await RelDB.get().boxesDAO.getBox(1);
      }
      yield BoxFeedBlocStateBoxLoaded(box);
    }
  }
}
