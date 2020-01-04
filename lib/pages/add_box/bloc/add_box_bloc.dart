import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NewBoxBlocEvent extends Equatable {}

abstract class NewBoxBlocState extends Equatable {}

class NewBoxBlocStateIdle extends NewBoxBlocState {
  @override
  List<Object> get props => [];
}

class NewBoxBloc extends Bloc<NewBoxBlocEvent, NewBoxBlocState> {
  @override
  // TODO: implement initialState
  NewBoxBlocState get initialState => NewBoxBlocStateIdle();

  @override
  Stream<NewBoxBlocState> mapEventToState(NewBoxBlocEvent event) {
  }
  
}