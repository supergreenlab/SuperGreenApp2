import 'dart:async';
import 'dart:math';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:uni_links/uni_links.dart';

abstract class DeepLinkBlocEvent extends Equatable {}

class DeepLinkBlocEventInit extends DeepLinkBlocEvent {
  @override
  List<Object> get props => [];
}

class DeepLinkBlocEventUri extends DeepLinkBlocEvent {
  final Uri uri;

  DeepLinkBlocEventUri(this.uri);

  @override
  List<Object> get props => [uri];
}

abstract class DeepLinkBlocState extends Equatable {}

class DeepLinkBlocStateInit extends DeepLinkBlocState {
  @override
  List<Object> get props => [];
}

class DeepLinkBlocStateMainNavigation extends DeepLinkBlocState {
  final int rand = Random().nextInt(1 << 32);
  final MainNavigatorEvent mainNavigatorEvent;

  DeepLinkBlocStateMainNavigation(this.mainNavigatorEvent);

  @override
  List<Object> get props => [mainNavigatorEvent, rand];
}

class DeepLinkBloc extends LegacyBloc<DeepLinkBlocEvent, DeepLinkBlocState> {
  late StreamSubscription _sub;

  DeepLinkBloc() : super(DeepLinkBlocStateInit()) {
    on<DeepLinkBlocEvent>((event, emit) async {
      await emit.onEach(mapEventToState(event), onData: (DeepLinkBlocState state) {
        emit(state);
      });
    }, transformer: sequential());
  }

  Stream<DeepLinkBlocState> mapEventToState(DeepLinkBlocEvent event) async* {
    if (event is DeepLinkBlocEventInit) {
      Uri? initialUri = await getInitialUri();
      if (initialUri != null) {
        // TODO find something better
        Timer(Duration(seconds: 2), () {
          add(DeepLinkBlocEventUri(initialUri));
        });
      }
      _sub = uriLinkStream.listen((Uri? uri) {
        add(DeepLinkBlocEventUri(uri!));
      });
    } else if (event is DeepLinkBlocEventUri) {
      if (event.uri.path == '/public/plant') {
        yield DeepLinkBlocStateMainNavigation(MainNavigateToPublicPlant(event.uri.queryParameters['id']!,
            feedEntryID: event.uri.queryParameters['feid']));
      } else if (event.uri.path == '/plant') {
        Plant plant = await RelDB.get().plantsDAO.getPlantForServerID(event.uri.queryParameters['id']!);
        yield DeepLinkBlocStateMainNavigation(MainNavigateToHomeEvent(plant: plant));
      }
    }
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
