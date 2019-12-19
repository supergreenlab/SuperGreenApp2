import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/device/storage/devices.dart';

abstract class MainBlocEvent extends Equatable {}

class MainBlocEventLoadControllers extends MainBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class MainBlocState extends Equatable {}

class MainBlocStateLoading extends MainBlocState {
  @override
  List<Object> get props => [];
}

class MainBlocStateDevicesLoaded extends MainBlocState {
  final List<Device> devices;

  MainBlocStateDevicesLoaded(this.devices);

  @override
  List<Object> get props => [];
}

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  @override
  MainBlocState get initialState => MainBlocStateLoading();

  MainBloc() {
    add(MainBlocEventLoadControllers());
  }

  @override
  Stream<MainBlocState> mapEventToState(MainBlocEvent event) async* {
    if (event is MainBlocEventLoadControllers) {
      final db = DevicesDB.get();
      List<Device> devices = await db.getDevices();
      yield MainBlocStateDevicesLoaded(devices);
    }
  }
}
