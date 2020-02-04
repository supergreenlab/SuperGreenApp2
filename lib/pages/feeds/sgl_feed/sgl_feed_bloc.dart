import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class SGLFeedBlocEvent extends Equatable {}

abstract class SGLFeedBlocState extends Equatable {}

class SGLFeedBlocStateInit extends SGLFeedBlocState {
  SGLFeedBlocStateInit() : super();

  @override
  List<Object> get props => [];
}

class SGLFeedBloc
    extends Bloc<SGLFeedBlocEvent, SGLFeedBlocState> {

  SGLFeedBloc();

  @override
  SGLFeedBlocState get initialState => SGLFeedBlocStateInit();

  @override
  Stream<SGLFeedBlocState> mapEventToState(
      SGLFeedBlocEvent event) async* {}
}
