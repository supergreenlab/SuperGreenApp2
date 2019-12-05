import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class MainBlocEvent extends Equatable {}

abstract class MainBlocState extends Equatable {}

class MainBlocStateLoading extends MainBlocState {
  @override
  List<Object> get props => [];
}

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  @override
  MainBlocState get initialState => MainBlocStateLoading();

  @override
  Stream<MainBlocState> mapEventToState(MainBlocEvent event) async* {
  }
}