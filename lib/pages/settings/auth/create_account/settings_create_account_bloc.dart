import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsCreateAccountBlocEvent extends Equatable {}

class SettingsCreateAccountBlocEventInit extends SettingsCreateAccountBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsCreateAccountBlocEventCreateAccount extends SettingsCreateAccountBlocEvent {
  final String nickname;
  final String password;
  final String token;

  SettingsCreateAccountBlocEventCreateAccount(this.nickname, this.password, this.token);

  @override
  List<Object> get props => [nickname, password, token];
}

abstract class SettingsCreateAccountBlocState extends Equatable {}

class SettingsCreateAccountBlocStateInit extends SettingsCreateAccountBlocState {
  @override
  List<Object> get props => [];
}

class SettingsCreateAccountBlocStateLoading extends SettingsCreateAccountBlocState {
  @override
  List<Object> get props => [];
}

class SettingsCreateAccountBlocStateLoaded extends SettingsCreateAccountBlocState {
  final bool isAuth;

  SettingsCreateAccountBlocStateLoaded(this.isAuth);

  @override
  List<Object> get props => [isAuth];
}

class SettingsCreateAccountBlocStateDone extends SettingsCreateAccountBlocState {
  @override
  List<Object> get props => [];
}

class SettingsCreateAccountBlocStateError extends SettingsCreateAccountBlocState {
  @override
  List<Object> get props => [];
}

class SettingsCreateAccountBloc extends LegacyBloc<SettingsCreateAccountBlocEvent, SettingsCreateAccountBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsCreateAccount args;
  late bool _isAuth;

  SettingsCreateAccountBloc(this.args) : super(SettingsCreateAccountBlocStateInit()) {
    _isAuth = BackendAPI().usersAPI.loggedIn;
    add(SettingsCreateAccountBlocEventInit());
  }

  @override
  Stream<SettingsCreateAccountBlocState> mapEventToState(SettingsCreateAccountBlocEvent event) async* {
    if (event is SettingsCreateAccountBlocEventInit) {
      yield SettingsCreateAccountBlocStateLoading();
      yield SettingsCreateAccountBlocStateLoaded(_isAuth);
    } else if (event is SettingsCreateAccountBlocEventCreateAccount) {
      yield SettingsCreateAccountBlocStateLoading();
      try {
        await BackendAPI().usersAPI.createUser(event.nickname, event.password, event.token);
        //await BackendAPI().usersAPI.login(event.nickname, event.password, event.token);
        await BackendAPI().feedsAPI.createUserEnd(notificationToken: AppDB().getAppData().notificationToken);
      } catch (e, trace) {
        Logger.logError(e, trace);
        yield SettingsCreateAccountBlocStateError();
        await Future.delayed(Duration(seconds: 2));
        yield SettingsCreateAccountBlocStateLoaded(_isAuth);
        return;
      }
      yield SettingsCreateAccountBlocStateDone();
    }
  }
}
