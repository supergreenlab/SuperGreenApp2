import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class DeviceBlocEvent extends Equatable {}

abstract class DeviceBlocState extends Equatable {}

class DeviceBlocStateLoading extends DeviceBlocState {
  @override
  List<Object> get props => [];
}

class DeviceBloc extends Bloc<DeviceBlocEvent, DeviceBlocState> {
  @override
  DeviceBlocState get initialState => DeviceBlocStateLoading();

  @override
  Stream<DeviceBlocState> mapEventToState(DeviceBlocEvent event)  async*{
    
  }
}