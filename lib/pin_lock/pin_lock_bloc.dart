import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class PinLockBlocEvent extends Equatable {}

class PinLockBlocEventInit extends PinLockBlocEvent {
  PinLockBlocEventInit();

  @override
  List<Object> get props => [];
}

class PinLockBlocEventShow extends PinLockBlocEvent {
  PinLockBlocEventShow();

  @override
  List<Object> get props => [];
}

class PinLockBlocEventSuccess extends PinLockBlocEvent {
  PinLockBlocEventSuccess();

  @override
  List<Object> get props => [];
}

abstract class PinLockBlocState extends Equatable {}

class PinLockBlocStateInit extends PinLockBlocState {
  @override
  List<Object> get props => [];
}

class PinLockBlocStateShow extends PinLockBlocState {
  final String pinLock;

  PinLockBlocStateShow(this.pinLock);

  @override
  List<Object> get props => [pinLock];
}

class PinLockBlocStateSuccess extends PinLockBlocState {
  @override
  List<Object> get props => [];
}

class PinLockBloc extends LegacyBloc<PinLockBlocEvent, PinLockBlocState> {
  PinLockBloc() : super(PinLockBlocStateInit()) {
    add(PinLockBlocEventInit());
  }

  Stream<PinLockBlocState> mapEventToState(PinLockBlocEvent event) async* {
    if (event is PinLockBlocEventInit) {
      if (AppDB().hasPinLock()) {
        yield PinLockBlocStateShow(AppDB().pinLock);
      } else {
        yield PinLockBlocStateSuccess();
      }
    } else if (event is PinLockBlocEventShow) {
      if (AppDB().hasPinLock()) {
        yield PinLockBlocStateShow(AppDB().pinLock);
      } else {
        yield PinLockBlocStateSuccess();
      }
    } else if (event is PinLockBlocEventSuccess) {
      yield PinLockBlocStateSuccess();
    }
  }
}
