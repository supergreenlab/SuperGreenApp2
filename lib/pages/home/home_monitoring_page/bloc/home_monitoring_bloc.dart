import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class HomeMonitoringBlocEvent extends Equatable {}

abstract class HomeMonitoringBlocState extends Equatable {}

class HomeMonitoringBlocStateLoading extends HomeMonitoringBlocState {
  @override
  List<Object> get props => [];
}

class HomeMonitoringBloc extends Bloc<HomeMonitoringBlocEvent, HomeMonitoringBlocState> {
  @override
  HomeMonitoringBlocState get initialState => HomeMonitoringBlocStateLoading();

  @override
  Stream<HomeMonitoringBlocState> mapEventToState(HomeMonitoringBlocEvent event) async* {
  }
}