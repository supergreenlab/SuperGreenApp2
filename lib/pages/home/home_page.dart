import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/box_drawer_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/box_feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_page.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  HomePage(this._navigatorKey);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _navigationIndex = 0;

  HomePageState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeNavigatorBloc, dynamic>(
      builder: (context, state) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black38,
          selectedItemColor: Colors.black,
          onTap: (i) => this._onNavigationBarItemSelect(context, i),
          elevation: 0,
          currentIndex: _navigationIndex,
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
          ],
        ),
        body: Navigator(
          key: widget._navigatorKey,
          onGenerateRoute: (settings) =>
              this._onGenerateRoute(context, settings),
        ),
      ),
    );
  }

  void _onNavigationBarItemSelect(BuildContext context, int i) {
    if (i == _navigationIndex) return;
    setState(() => _navigationIndex = i);
    if (i == 0) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToSGLFeedEvent());
    } else if (i == 1) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToBoxFeedEvent(null));
    }
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    if (settings.arguments == null) {
      _navigationIndex = 0;
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SGLFeedBloc(),
                child: SGLFeedPage(),
              ));
    }
    switch (settings.name) {
      case '/feed/sgl':
        _navigationIndex = 0;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: SGLFeedPage(),
                ));
      case '/feed/box':
        _navigationIndex = 1;
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
      default:
        _navigationIndex = 0;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: SGLFeedPage(),
                ));
    }
  }
}
