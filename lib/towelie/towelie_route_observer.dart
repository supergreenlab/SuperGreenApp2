import 'package:flutter/material.dart';

class TowelieRouteObserver extends StatefulWidget {
  final Widget child;

  const TowelieRouteObserver({Key key, this.child}) : super(key: key);

  @override
  _TowelieRouteObserverState createState() => _TowelieRouteObserverState();
}

class _TowelieRouteObserverState extends State<TowelieRouteObserver>
    with RouteAware {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  void initState() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didPush() {
    print('didPush Screen3');
  }
}
