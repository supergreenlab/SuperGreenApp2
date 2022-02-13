import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsLoginBlocEvent extends Equatable {}

class SettingsLoginBlocEventInit extends SettingsLoginBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsLoginBlocEventLogin extends SettingsLoginBlocEvent {
  final String nickname;
  final String password;

  SettingsLoginBlocEventLogin(this.nickname, this.password);

  @override
  List<Object> get props => [nickname, password];
}

abstract class SettingsLoginBlocState extends Equatable {}

class SettingsLoginBlocStateInit extends SettingsLoginBlocState {
  @override
  List<Object> get props => [];
}

class SettingsLoginBlocStateLoading extends SettingsLoginBlocState {
  @override
  List<Object> get props => [];
}

class SettingsLoginBlocStateLoaded extends SettingsLoginBlocState {
  final bool isAuth;

  SettingsLoginBlocStateLoaded(this.isAuth);

  @override
  List<Object> get props => [isAuth];
}

class SettingsLoginBlocStateDone extends SettingsLoginBlocState {
  @override
  List<Object> get props => [];
}

class SettingsLoginBlocStateError extends SettingsLoginBlocState {
  @override
  List<Object> get props => [];
}

class SettingsLoginBloc extends LegacyBloc<SettingsLoginBlocEvent, SettingsLoginBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsLogin args;
  late bool _isAuth;

  SettingsLoginBloc(this.args) : super(SettingsLoginBlocStateInit()) {
    _isAuth = BackendAPI().usersAPI.loggedIn;
    add(SettingsLoginBlocEventInit());
  }

  @override
  Stream<SettingsLoginBlocState> mapEventToState(SettingsLoginBlocEvent event) async* {
    if (event is SettingsLoginBlocEventInit) {
      yield SettingsLoginBlocStateLoading();
      yield SettingsLoginBlocStateLoaded(_isAuth);
    } else if (event is SettingsLoginBlocEventLogin) {
      yield SettingsLoginBlocStateLoading();
      try {
        await BackendAPI().usersAPI.login(event.nickname, event.password);
        String? notificationToken = AppDB().getAppData().notificationToken;
        await BackendAPI().feedsAPI.createUserEnd(notificationToken: notificationToken);
      } catch (e, trace) {
        Logger.logError(e, trace);
        yield SettingsLoginBlocStateError();
        await Future.delayed(Duration(seconds: 2));
        yield SettingsLoginBlocStateLoaded(_isAuth);
        return;
      }
      yield SettingsLoginBlocStateDone();
    }
  }
}
