import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsLoginBlocEvent extends Equatable {}

class SettingsLoginBlocEventInit extends SettingsLoginBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsLoginBlocEventCreateAccount extends SettingsLoginBlocEvent {
  final String nickname;
  final String password;

  SettingsLoginBlocEventCreateAccount(this.nickname, this.password);

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

class SettingsLoginBloc
    extends Bloc<SettingsLoginBlocEvent, SettingsLoginBlocState> {

  //ignore: unused_field
  final MainNavigateToSettingsLogin args;
  bool _isAuth;

  SettingsLoginBloc(this.args) {
    _isAuth = AppDB().getAppData().jwt != null;
    add(SettingsLoginBlocEventInit());
  }

  @override
  SettingsLoginBlocState get initialState => SettingsLoginBlocStateInit();

  @override
  Stream<SettingsLoginBlocState> mapEventToState(
      SettingsLoginBlocEvent event) async* {
    if (event is SettingsLoginBlocEventInit) {
      yield SettingsLoginBlocStateLoading();
      yield SettingsLoginBlocStateLoaded(_isAuth);
    } else if (event is SettingsLoginBlocEventCreateAccount) {
      yield SettingsLoginBlocStateLoading();
      try {
        await FeedsAPI().login(event.nickname, event.password);
        await FeedsAPI().createUserEnd();
      } catch (e) {
        console.e(e);
        yield SettingsLoginBlocStateError();
        await Future.delayed(Duration(seconds: 2));
        yield SettingsLoginBlocStateLoaded(_isAuth);
        return;
      }
      yield SettingsLoginBlocStateDone();
    }
  }
}
