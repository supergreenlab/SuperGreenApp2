
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class HomeBlocEvent extends Equatable {}

abstract class HomeBlocState extends Equatable {}

class HomeBlocStateInit extends HomeBlocState {
  @override
  List<Object> get props => [];
}

class HomeBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  @override
  HomeBlocState get initialState => HomeBlocStateInit();

  @override
  Stream<HomeBlocState> mapEventToState(HomeBlocEvent event) async* {}
}