import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceTestBlocEvent extends Equatable {}

class DeviceTestBlocEventInit extends DeviceTestBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceTestBlocEventDone extends DeviceTestBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceTestBlocState extends Equatable {
  final int nLedChannels;
  final int nMotorChannels;

  DeviceTestBlocState(this.nLedChannels, this.nMotorChannels);

  @override
  List<Object> get props => [];
}

class DeviceTestBlocStateLoading extends DeviceTestBlocState {
  DeviceTestBlocStateLoading() : super(0, 0);
}

class DeviceTestBlocStateDone extends DeviceTestBlocState {
  DeviceTestBlocStateDone(Device device, int nLedChannels, int nMotorChannels)
      : super(nLedChannels, nMotorChannels);
}

class DeviceTestBloc extends Bloc<DeviceTestBlocEvent, DeviceTestBlocState> {
  final MainNavigateToDeviceTestEvent _args;

  DeviceTestBloc(this._args) {
    add(DeviceTestBlocEventInit());
  }

  @override
  DeviceTestBlocState get initialState => DeviceTestBlocStateLoading();

  @override
  Stream<DeviceTestBlocState> mapEventToState(
      DeviceTestBlocEvent event) async* {
    if (event is DeviceTestBlocEventInit) {
      yield DeviceTestBlocStateLoading();
      yield DeviceTestBlocState(6, 3);
    } else if (event is DeviceTestBlocEventDone) {
      var ddb = RelDB.get().devicesDAO;
      await ddb.updateDevice(_args.device.copyWith(isDraft: false));

      Device device = await ddb.getDevice(_args.device.id);
      yield DeviceTestBlocStateDone(device, 6, 3);
    }
  }
}
