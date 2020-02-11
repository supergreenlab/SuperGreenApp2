import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  @override
  SettingsBlocState get initialState => SettingsBlocState();

  @override
  Stream<SettingsBlocState> mapEventToState(SettingsBlocEvent event) async* {
  }

}