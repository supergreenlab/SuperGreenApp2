import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
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

class BoxFeedBlocStateNoBox extends BoxFeedBlocState {
  BoxFeedBlocStateNoBox() : super();

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
    AppDB _db = AppDB();
    if (event is BoxFeedBlocEventLoadBox) {
      Box box = _args.box;
      if (box == null) {
        AppData appData = _db.getAppData();
        if (appData.lastBoxID == null) {
          yield BoxFeedBlocStateNoBox();
          return;
        }
        box = await RelDB.get().boxesDAO.getBox(appData.lastBoxID);
      } else {
        _db.setLastBox(box.id);
      }
      yield BoxFeedBlocStateBoxLoaded(box);
    }
  }
}
