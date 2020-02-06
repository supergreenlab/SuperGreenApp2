import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceBoxBlocEvent extends Equatable {}

class SelectDeviceBoxBlocEventInitialize extends SelectDeviceBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBlocEventSetDeviceBox extends SelectDeviceBoxBlocEvent {
  final int deviceBox;
  SelectDeviceBoxBlocEventSetDeviceBox(this.deviceBox);

  @override
  List<Object> get props => [deviceBox];
}

class SelectDeviceBoxBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBloc
    extends Bloc<SelectDeviceBoxBlocEvent, SelectDeviceBoxBlocState> {
  final MainNavigateToSelectBoxDeviceBoxEvent _args;

  SelectDeviceBoxBloc(this._args);

  @override
  SelectDeviceBoxBlocState get initialState =>
      SelectDeviceBoxBlocState();

  @override
  Stream<SelectDeviceBoxBlocState> mapEventToState(
      SelectDeviceBoxBlocEvent event) async* {
    if (event is SelectDeviceBoxBlocEventInitialize) {
      final ddb = RelDB.get().devicesDAO;
      final boxModule = await ddb.getModule(_args.device.id, 'box');
      final availableBoxes = List<int>();
      for (int i = 0; i < boxModule.arrayLen; ++i) {
        final boxEnabled = await ddb.getParam(_args.device.id, 'BOX_${i}_ENABLED');
        if (boxEnabled.ivalue != 0) {
          availableBoxes.add(i);
        }
      }
      final ledModule = await ddb.getModule(_args.device.id, 'led');
      final availableLeds = List<int>();
      for (int i = 0; i < ledModule.arrayLen; ++i) {
        final ledBox = await ddb.getParam(_args.device.id, 'LED_${i}_BOX');
        if (availableBoxes.contains(ledBox.ivalue)) {
          availableLeds.add(i);
        }
      }
    }
  }
}
