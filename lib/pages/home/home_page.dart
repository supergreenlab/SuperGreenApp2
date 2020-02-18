import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/explorer/explorer_bloc.dart';
import 'package:super_green_app/pages/explorer/explorer_page.dart';
import 'package:super_green_app/pages/feeds/box_feed/box_drawer_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/box_feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_page.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/settings_bloc.dart';
import 'package:super_green_app/pages/settings/settings_page.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  HomePage(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeNavigatorBloc, HomeNavigatorState>(
      builder: (context, state) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black38,
          selectedItemColor: Colors.green,
          onTap: (i) => this._onNavigationBarItemSelect(context, i, state),
          elevation: 0,
          currentIndex: state.index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback),
              title: Text('Towelie'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title: Text('Explore'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
        body: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) =>
              this._onGenerateRoute(context, settings),
        ),
      ),
    );
  }

  void _onNavigationBarItemSelect(
      BuildContext context, int i, HomeNavigatorState state) {
    if (i == state.index) return;
    if (i == 0) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToSGLFeedEvent());
    } else if (i == 1) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToBoxFeedEvent(null));
    } else if (i == 2) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToExplorerEvent());
    } else if (i == 3) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToSettingsEvent());
    }
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    if (settings.arguments == null) {
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SGLFeedBloc(),
                child: SGLFeedPage(),
              ));
    }
    switch (settings.name) {
      case '/feed/sgl':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: SGLFeedPage(),
                ));
      case '/feed/box':
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<BoxDrawerBloc>(
                        create: (context) => BoxDrawerBloc()),
                    BlocProvider<BoxFeedBloc>(
                      create: (context) => BoxFeedBloc(settings.arguments),
                    )
                  ],
                  child: BoxFeedPage(),
                ));
      case '/explorer':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ExplorerBloc(),
                  child: ExplorerPage(),
                ));
      case '/settings':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SettingsBloc(),
                  child: SettingsPage(),
                ));
      default:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: SGLFeedPage(),
                ));
    }
  }
}
