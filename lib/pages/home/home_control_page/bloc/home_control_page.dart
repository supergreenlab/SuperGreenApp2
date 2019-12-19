import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/pages/home/home_page/bloc/home_navigator_bloc.dart';

abstract class HomeControlBlocEvent extends Equatable {}

abstract class HomeControlBlocState extends Equatable {}

class HomeControlBlocStateLoading extends HomeControlBlocState {
  @override
  List<Object> get props => [];
}

class HomeControlBloc extends Bloc<HomeControlBlocEvent, HomeControlBlocState> {
  final HomeNavigateToControlEvent _args;

  HomeControlBloc(this._args);

  @override
  HomeControlBlocState get initialState => HomeControlBlocStateLoading();

  @override
  Stream<HomeControlBlocState> mapEventToState(
      HomeControlBlocEvent event) async* {}
}
