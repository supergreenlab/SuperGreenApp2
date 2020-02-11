import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorerBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ExplorerBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ExplorerBloc extends Bloc<ExplorerBlocEvent, ExplorerBlocState> {
  @override
  ExplorerBlocState get initialState => ExplorerBlocState();

  @override
  Stream<ExplorerBlocState> mapEventToState(ExplorerBlocEvent event) async* {
  }

}