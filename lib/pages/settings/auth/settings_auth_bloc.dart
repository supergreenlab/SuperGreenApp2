import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsAuthBlocEvent extends Equatable {}

class SettingsAuthBlocEventInit extends SettingsAuthBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsAuthBlocEventLogout extends SettingsAuthBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SettingsAuthBlocState extends Equatable {}

class SettingsAuthBlocStateInit extends SettingsAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsAuthBlocStateLoading extends SettingsAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsAuthBlocStateLoaded extends SettingsAuthBlocState {
  final bool isAuth;

  SettingsAuthBlocStateLoaded(this.isAuth);

  @override
  List<Object> get props => [isAuth];
}

class SettingsAuthBlocStateDone extends SettingsAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsAuthBloc
    extends Bloc<SettingsAuthBlocEvent, SettingsAuthBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsAuth _args;
  bool _isAuth;

  SettingsAuthBloc(this._args) {
    _isAuth = AppDB().getAppData().jwt != null;
    add(SettingsAuthBlocEventInit());
  }

  @override
  SettingsAuthBlocState get initialState => SettingsAuthBlocStateInit();

  @override
  Stream<SettingsAuthBlocState> mapEventToState(
      SettingsAuthBlocEvent event) async* {
    if (event is SettingsAuthBlocEventInit) {
      yield SettingsAuthBlocStateLoading();
      yield SettingsAuthBlocStateLoaded(_isAuth);
    } else if (event is SettingsAuthBlocEventLogout) {
      AppDB().setJWT(null);
      yield SettingsAuthBlocStateDone();
    }
  }
}
