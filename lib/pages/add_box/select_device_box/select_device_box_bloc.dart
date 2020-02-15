import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceBoxBlocEvent extends Equatable {}

class SelectDeviceBoxBlocEventInitialize extends SelectDeviceBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBlocEventSelectLeds extends SelectDeviceBoxBlocEvent {
  final List<int> leds;

  SelectDeviceBoxBlocEventSelectLeds(this.leds);

  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBlocState extends Equatable {
  final List<int> leds;

  SelectDeviceBoxBlocState(this.leds);

  @override
  List<Object> get props => [leds];
}

class SelectDeviceBoxBlocStateLoaded extends SelectDeviceBoxBlocState {
  SelectDeviceBoxBlocStateLoaded(List<int> leds) : super(leds);
}

class SelectDeviceBoxBlocStateDeviceFull extends SelectDeviceBoxBlocState {
  SelectDeviceBoxBlocStateDeviceFull(List<int> leds) : super(leds);
}

class SelectDeviceBoxBlocStateLoading extends SelectDeviceBoxBlocState {
  SelectDeviceBoxBlocStateLoading(List<int> leds) : super(leds);
}

class SelectDeviceBoxBlocStateDone extends SelectDeviceBoxBlocState {
  final int box;

  SelectDeviceBoxBlocStateDone(this.box, List<int> leds) : super(leds);

  @override
  List<Object> get props => [box, leds];
}

class SelectDeviceBoxBloc
    extends Bloc<SelectDeviceBoxBlocEvent, SelectDeviceBoxBlocState> {
  List<int> _boxes = [];
  List<int> _leds = [];
  final MainNavigateToSelectBoxDeviceBoxEvent _args;

  SelectDeviceBoxBloc(this._args) {
    add(SelectDeviceBoxBlocEventInitialize());
  }

  @override
  SelectDeviceBoxBlocState get initialState => SelectDeviceBoxBlocState(_leds);

  @override
  Stream<SelectDeviceBoxBlocState> mapEventToState(
      SelectDeviceBoxBlocEvent event) async* {
    if (event is SelectDeviceBoxBlocEventInitialize) {
      final ddb = RelDB.get().devicesDAO;
      final Device device = await ddb.getDevice(_args.device.id);
      final boxModule = await ddb.getModule(device.id, 'box');
      for (int i = 0; i < boxModule.arrayLen; ++i) {
        final boxEnabled =
            await ddb.getParam(device.id, 'BOX_${i}_ENABLED');
        if (boxEnabled.ivalue == 0) {
          _boxes.add(i);
        }
      }
      if (_boxes.length == 0) {
        yield SelectDeviceBoxBlocStateDeviceFull(_leds);
        return;
      }
      final ledModule = await ddb.getModule(device.id, 'led');
      for (int i = 0; i < ledModule.arrayLen; ++i) {
        final ledBox = await ddb.getParam(device.id, 'LED_${i}_BOX');
        if (ledBox.ivalue < 0 || _boxes.contains(ledBox.ivalue)) {
          _leds.add(i);
        }
      }
      yield SelectDeviceBoxBlocStateLoaded(_leds);
    } else if (event is SelectDeviceBoxBlocEventSelectLeds) {
      yield SelectDeviceBoxBlocStateLoading(_leds);
      int box = _boxes[0];
      final ddb = RelDB.get().devicesDAO;
      final Device device = await ddb.getDevice(_args.device.id);
      for (int i = 0; i < event.leds.length; ++i) {
        final ledBox = await ddb.getParam(device.id, 'LED_${event.leds[i]}_BOX');
        await DeviceHelper.updateIntParam(device, ledBox, box);
      }
      final boxEnabled =
          await ddb.getParam(device.id, 'BOX_${box}_ENABLED');
      await DeviceHelper.updateIntParam(device, boxEnabled, 1);
      yield SelectDeviceBoxBlocStateDone(box, _leds);
    }
  }
}
