import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TimelapseHowtoBlocEvent extends Equatable {}

class TimelapseHowtoBlocState extends Equatable {
  final Plant plant;

  TimelapseHowtoBlocState(this.plant);

  @override
  List<Object> get props => [];
}

class TimelapseHowtoBloc
    extends Bloc<TimelapseHowtoBlocEvent, TimelapseHowtoBlocState> {
  final MainNavigateToTimelapseHowto args;

  TimelapseHowtoBloc(this.args) : super(TimelapseHowtoBlocState(args.plant));

  @override
  Stream<TimelapseHowtoBlocState> mapEventToState(
      TimelapseHowtoBlocEvent event) async* {}
}
