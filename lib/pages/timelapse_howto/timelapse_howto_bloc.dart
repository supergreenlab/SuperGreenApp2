import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TimelapseHowtoBlocEvent extends Equatable {}

abstract class TimelapseHowtoBlocState extends Equatable {}

class TimelapseHowtoBlocStateInit extends TimelapseHowtoBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseHowtoBloc
    extends Bloc<TimelapseHowtoBlocEvent, TimelapseHowtoBlocState> {

  final MainNavigateToTimelapseHowto _args;

  TimelapseHowtoBloc(this._args);

  @override
  TimelapseHowtoBlocState get initialState => TimelapseHowtoBlocStateInit();

  @override
  Stream<TimelapseHowtoBlocState> mapEventToState(
      TimelapseHowtoBlocEvent event) async* {}
}
