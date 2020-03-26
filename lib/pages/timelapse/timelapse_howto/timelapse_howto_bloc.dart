import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TimelapseHowtoBlocEvent extends Equatable {}

class TimelapseHowtoBlocState extends Equatable {
  final Plant box;

  TimelapseHowtoBlocState(this.box);
  
  @override
  List<Object> get props => [];
}

class TimelapseHowtoBloc
    extends Bloc<TimelapseHowtoBlocEvent, TimelapseHowtoBlocState> {

  final MainNavigateToTimelapseHowto _args;

  TimelapseHowtoBloc(this._args);

  @override
  TimelapseHowtoBlocState get initialState => TimelapseHowtoBlocState(_args.plant);

  @override
  Stream<TimelapseHowtoBlocState> mapEventToState(
      TimelapseHowtoBlocEvent event) async* {}
}
