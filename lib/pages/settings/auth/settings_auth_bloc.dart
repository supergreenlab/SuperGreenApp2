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

class SettingsAuthBlocEventCreateAccount extends SettingsAuthBlocEvent {
  final String nickname;
  final String password;

  SettingsAuthBlocEventCreateAccount(this.nickname, this.password);

  @override
  List<Object> get props => [nickname, password];
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

class SettingsAuthBlocStateError extends SettingsAuthBlocState {
  @override
  List<Object> get props => [];
}

class SettingsAuthBloc
    extends Bloc<SettingsAuthBlocEvent, SettingsAuthBlocState> {
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
    } else if (event is SettingsAuthBlocEventCreateAccount) {
      yield SettingsAuthBlocStateLoading();
      try {
        await FeedsAPI().createUser(event.nickname, event.password);
        await FeedsAPI().login(event.nickname, event.password);
        await FeedsAPI().createUserEnd();
      } catch (e) {
        print(e);
        yield SettingsAuthBlocStateError();
        await Future.delayed(Duration(seconds: 2));
        yield SettingsAuthBlocStateLoaded(_isAuth);
        return;
      }
      yield SettingsAuthBlocStateDone();
    }
  }
}
