import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/device/storage/devices.dart';
import 'package:super_green_app/pages/home/home_page/bloc/home_navigator_bloc.dart';

abstract class HomeMonitoringBlocEvent extends Equatable {}

abstract class HomeMonitoringBlocState extends Equatable {
  final Device device;

  HomeMonitoringBlocState(this.device);
}

class HomeMonitoringBlocStateInit extends HomeMonitoringBlocState {
  HomeMonitoringBlocStateInit(Device device) : super(device);

  @override
  List<Object> get props => [];
}

class HomeMonitoringBloc
    extends Bloc<HomeMonitoringBlocEvent, HomeMonitoringBlocState> {
  final HomeNavigateToMonitoringEvent _args;

  HomeMonitoringBloc(this._args);

  @override
  HomeMonitoringBlocState get initialState => HomeMonitoringBlocStateInit(_args.device);

  @override
  Stream<HomeMonitoringBlocState> mapEventToState(
      HomeMonitoringBlocEvent event) async* {}
}
