import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/Logger.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsCreateAccountBlocEvent extends Equatable {}

class SettingsCreateAccountBlocEventInit extends SettingsCreateAccountBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsCreateAccountBlocEventCreateAccount extends SettingsCreateAccountBlocEvent {
  final String nickname;
  final String password;

  SettingsCreateAccountBlocEventCreateAccount(this.nickname, this.password);

  @override
  List<Object> get props => [nickname, password];
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

class SettingsCreateAccountBloc
    extends Bloc<SettingsCreateAccountBlocEvent, SettingsCreateAccountBlocState> {

  //ignore: unused_field
  final MainNavigateToSettingsCreateAccount args;
  bool _isAuth;

  SettingsCreateAccountBloc(this.args) {
    _isAuth = AppDB().getAppData().jwt != null;
    add(SettingsCreateAccountBlocEventInit());
  }

  @override
  SettingsCreateAccountBlocState get initialState => SettingsCreateAccountBlocStateInit();

  @override
  Stream<SettingsCreateAccountBlocState> mapEventToState(
      SettingsCreateAccountBlocEvent event) async* {
    if (event is SettingsCreateAccountBlocEventInit) {
      yield SettingsCreateAccountBlocStateLoading();
      yield SettingsCreateAccountBlocStateLoaded(_isAuth);
    } else if (event is SettingsCreateAccountBlocEventCreateAccount) {
      yield SettingsCreateAccountBlocStateLoading();
      try {
        await FeedsAPI().createUser(event.nickname, event.password);
        await FeedsAPI().login(event.nickname, event.password);
        await FeedsAPI().createUserEnd();
      } catch (e) {
        Logger.log(e);
        yield SettingsCreateAccountBlocStateError();
        await Future.delayed(Duration(seconds: 2));
        yield SettingsCreateAccountBlocStateLoaded(_isAuth);
        return;
      }
      yield SettingsCreateAccountBlocStateDone();
    }
  }
}
