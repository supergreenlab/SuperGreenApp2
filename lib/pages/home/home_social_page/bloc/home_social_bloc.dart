import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class HomeSocialBlocEvent extends Equatable {}

abstract class HomeSocialBlocState extends Equatable {}

class HomeSocialBlocStateLoading extends HomeSocialBlocState {
  @override
  List<Object> get props => [];
}

class HomeSocialBloc extends Bloc<HomeSocialBlocEvent, HomeSocialBlocState> {
  @override
  HomeSocialBlocState get initialState => HomeSocialBlocStateLoading();

  @override
  Stream<HomeSocialBlocState> mapEventToState(HomeSocialBlocEvent event) async* {
  }
}