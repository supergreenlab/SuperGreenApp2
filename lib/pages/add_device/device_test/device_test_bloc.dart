import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/helpers/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class DeviceTestBlocEvent extends Equatable {}

class DeviceTestBlocEventInit extends DeviceTestBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceTestBlocEventTestLed extends DeviceTestBlocEvent {
  final int ledID;

  DeviceTestBlocEventTestLed(this.ledID);

  @override
  List<Object> get props => [ledID];
}

class DeviceTestBlocEventDone extends DeviceTestBlocEvent {
  @override
  List<Object> get props => [];
}

class DeviceTestBlocState extends Equatable {
  final int nLedChannels;

  DeviceTestBlocState(this.nLedChannels);

  @override
  List<Object> get props => [nLedChannels];
}

class DeviceTestBlocStateLoading extends DeviceTestBlocState {
  DeviceTestBlocStateLoading() : super(0);
}

class DeviceTestBlocStateTestingLed extends DeviceTestBlocState {
  final int ledID;

  DeviceTestBlocStateTestingLed(int nLedChannels, this.ledID)
      : super(nLedChannels);

  @override
  List<Object> get props => [nLedChannels, ledID];
}

class DeviceTestBlocStateDone extends DeviceTestBlocState {
  DeviceTestBlocStateDone(Device device, int nLedChannels)
      : super(nLedChannels);
}

class DeviceTestBloc extends Bloc<DeviceTestBlocEvent, DeviceTestBlocState> {
  final MainNavigateToDeviceTestEvent args;

  int _nLedChannels = 0;

  DeviceTestBloc(this.args) : super(DeviceTestBlocStateLoading()) {
    add(DeviceTestBlocEventInit());
  }

  @override
  Stream<DeviceTestBlocState> mapEventToState(
      DeviceTestBlocEvent event) async* {
    if (event is DeviceTestBlocEventInit) {
      yield DeviceTestBlocStateLoading();
      var ddb = RelDB.get().devicesDAO;
      Module lightModule = await ddb.getModule(args.device.id, "led");
      _nLedChannels = lightModule.arrayLen;
      yield DeviceTestBlocState(_nLedChannels);
    } else if (event is DeviceTestBlocEventTestLed) {
      var ddb = RelDB.get().devicesDAO;
      yield DeviceTestBlocStateTestingLed(_nLedChannels, event.ledID);
      Param ledParam =
          await ddb.getParam(args.device.id, "LED_${event.ledID}_DUTY");
      await DeviceHelper.updateIntParam(args.device, ledParam, 100);
      await Future.delayed(Duration(seconds: 2));
      await DeviceHelper.updateIntParam(args.device, ledParam, 0);
      yield DeviceTestBlocState(_nLedChannels);
    } else if (event is DeviceTestBlocEventDone) {
      yield DeviceTestBlocStateLoading();
      var ddb = RelDB.get().devicesDAO;
      Device device = await ddb.getDevice(args.device.id);
      Param stateParam = await ddb.getParam(args.device.id, "STATE");
      await DeviceHelper.updateIntParam(args.device, stateParam, 2);
      yield DeviceTestBlocStateDone(device, 6);
    }
  }
}
