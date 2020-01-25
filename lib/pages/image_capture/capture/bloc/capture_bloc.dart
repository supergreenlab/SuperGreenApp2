import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class CaptureBlocEvent extends Equatable {}

class CaptureBlocEventInit extends CaptureBlocEvent {
  @override
  List<Object> get props => [];
}

class CaptureBlocState extends Equatable {
  final ImageCaptureNextRouteEvent nextRoute;

  CaptureBlocState(this.nextRoute);

  @override
  List<Object> get props => [
        nextRoute,
      ];
}

class CaptureBlocStateInit extends CaptureBlocState {
  CaptureBlocStateInit(ImageCaptureNextRouteEvent nextRoute) : super(nextRoute);
}

class CaptureBloc extends Bloc<CaptureBlocEvent, CaptureBlocState> {
  final MainNavigateToImageCaptureEvent _args;

  @override
  CaptureBlocState get initialState => CaptureBlocState(_args.nextRoute);

  CaptureBloc(this._args) {
    add(CaptureBlocEventInit());
  }

  @override
  Stream<CaptureBlocState> mapEventToState(CaptureBlocEvent event) async* {
    if (event is CaptureBlocEventInit) {
      yield CaptureBlocStateInit(_args.nextRoute);
    }
  }
}
