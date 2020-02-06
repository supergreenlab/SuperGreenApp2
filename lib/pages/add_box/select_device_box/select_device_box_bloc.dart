import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceBoxBlocEvent extends Equatable {}

class SelectDeviceBoxBlocEventInitialize extends SelectDeviceBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBlocState extends Equatable {
  final List<int> leds;

  SelectDeviceBoxBlocState(this.leds);

  @override
  List<Object> get props => [leds];
}

class SelectDeviceBoxBloc
    extends Bloc<SelectDeviceBoxBlocEvent, SelectDeviceBoxBlocState> {
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
      final boxModule = await ddb.getModule(_args.device.id, 'box');
      final boxes = List<int>();
      for (int i = 0; i < boxModule.arrayLen; ++i) {
        final boxEnabled =
            await ddb.getParam(_args.device.id, 'BOX_${i}_ENABLED');
        if (boxEnabled.ivalue == 0) {
          boxes.add(i);
        }
      }
      final ledModule = await ddb.getModule(_args.device.id, 'led');
      final leds = List<int>();
      for (int i = 0; i < ledModule.arrayLen; ++i) {
        final ledBox = await ddb.getParam(_args.device.id, 'LED_${i}_BOX');
        if (boxes.contains(ledBox.ivalue)) {
          leds.add(i);
        }
      }
      yield SelectDeviceBoxBlocState(leds);
    }
  }
}
