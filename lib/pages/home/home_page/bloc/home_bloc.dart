import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/device/storage/devices.dart';

abstract class HomeBlocEvent extends Equatable {}

class HomeBlocEventLoadControllers extends HomeBlocEvent {
  @override
  List<Object> get props => [];
}

class HomeBlocEventDeviceListUpdated extends HomeBlocEvent {
  final List<Device> devices;

  HomeBlocEventDeviceListUpdated(this.devices);

  @override
  List<Object> get props => [devices];
}

abstract class HomeBlocState extends Equatable {}

class HomeBlocStateLoadingDeviceList extends HomeBlocState {
  @override
  List<Object> get props => [];
}

class HomeBlocStateDeviceListUpdated extends HomeBlocState {
  final List<Device> devices;

  HomeBlocStateDeviceListUpdated(this.devices);

  @override
  List<Object> get props => [devices];
}

class HomeBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  @override
  HomeBlocState get initialState => HomeBlocStateLoadingDeviceList();

  HomeBloc() {
    add(HomeBlocEventLoadControllers());
  }

  @override
  Stream<HomeBlocState> mapEventToState(HomeBlocEvent event) async* {
    if (event is HomeBlocEventLoadControllers) {
      final db = DevicesDB.get();
      Stream<List<Device>> devicesStream = db.watchDevices();
      devicesStream.listen(_onDeviceListChange);
    } else if (event is HomeBlocEventDeviceListUpdated) {
      yield HomeBlocStateDeviceListUpdated(event.devices);
    }
  }

  void _onDeviceListChange(List<Device> devices) {
    add(HomeBlocEventDeviceListUpdated(devices));
  }
}
