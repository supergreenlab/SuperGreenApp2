import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
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

class DeepLinkBloc extends Bloc<DeepLinkBlocEvent, DeepLinkBlocState> {
  late StreamSubscription _sub;

  DeepLinkBloc() : super(DeepLinkBlocStateInit());

  @override
  Stream<DeepLinkBlocState> mapEventToState(DeepLinkBlocEvent event) async* {
    if (event is DeepLinkBlocEventInit) {
      Uri? initialUri = (await getInitialUri()) as Uri?;
      if (initialUri != null) {
        // TODO find something better
        Timer(Duration(seconds: 2), () {
          add(DeepLinkBlocEventUri(initialUri));
        });
      }
      _sub = getUriLinksStream().listen((Uri uri) {
        add(DeepLinkBlocEventUri(uri));
      });
    } else if (event is DeepLinkBlocEventUri) {
      if (event.uri.path == '/public/plant') {
        yield DeepLinkBlocStateMainNavigation(MainNavigateToPublicPlant(event.uri.queryParameters['id']!,
            feedEntryID: event.uri.queryParameters['feid']));
      }
    }
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
