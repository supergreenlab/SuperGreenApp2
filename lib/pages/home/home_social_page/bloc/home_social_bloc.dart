import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/pages/home/home_page/bloc/home_navigator_bloc.dart';

abstract class HomeSocialBlocEvent extends Equatable {}

abstract class HomeSocialBlocState extends Equatable {}

class HomeSocialBlocStateLoading extends HomeSocialBlocState {
  @override
  List<Object> get props => [];
}

class HomeSocialBloc extends Bloc<HomeSocialBlocEvent, HomeSocialBlocState> {
  final HomeNavigateToSocialEvent _args;

  HomeSocialBloc(this._args);

  @override
  HomeSocialBlocState get initialState => HomeSocialBlocStateLoading();

  @override
  Stream<HomeSocialBlocState> mapEventToState(
      HomeSocialBlocEvent event) async* {}
}
