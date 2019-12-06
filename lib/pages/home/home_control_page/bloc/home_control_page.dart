import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class HomeControlBlocEvent extends Equatable {}

abstract class HomeControlBlocState extends Equatable {}

class HomeControlBlocStateLoading extends HomeControlBlocState {
  @override
  List<Object> get props => [];
}

class HomeControlBloc extends Bloc<HomeControlBlocEvent, HomeControlBlocState> {
  @override
  HomeControlBlocState get initialState => HomeControlBlocStateLoading();

  @override
  Stream<HomeControlBlocState> mapEventToState(HomeControlBlocEvent event) async* {
  }
}