import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class AddDeviceBlocEvent extends Equatable {}

class AddDeviceBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddDeviceBloc extends Bloc<AddDeviceBlocEvent, AddDeviceBlocState> {
  final MainNavigateToAddDeviceEvent _args;

  AddDeviceBloc(this._args);

  @override
  AddDeviceBlocState get initialState => AddDeviceBlocState();

  @override
  Stream<AddDeviceBlocState> mapEventToState(AddDeviceBlocEvent event) async* {}
}
