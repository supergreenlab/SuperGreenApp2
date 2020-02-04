import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class AddDeviceBlocEvent extends Equatable {}

class AddDeviceBlocState extends Equatable {
  final Box box;

  AddDeviceBlocState(this.box);
  
  @override
  List<Object> get props => [box];
}

class AddDeviceBloc extends Bloc<AddDeviceBlocEvent, AddDeviceBlocState> {
  final MainNavigateToAddDeviceEvent _args;

  AddDeviceBloc(this._args);

  @override
  AddDeviceBlocState get initialState => AddDeviceBlocState(_args.box);

  @override
  Stream<AddDeviceBlocState> mapEventToState(AddDeviceBlocEvent event) async* {}
}
