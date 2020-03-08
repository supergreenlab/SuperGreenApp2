import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_matomo/flutter_matomo.dart';

void main() => runApp(MyApp());

const URL = 'https://your_url/piwik.php';
const SITE_ID = 2;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _matomoStatus = 'Starting ...';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _matomoStatus = await FlutterMatomo.initializeTracker(URL, SITE_ID);
    setState(() {});

    Future.delayed(Duration(seconds: 2), () async {
      _matomoStatus = await FlutterMatomo.trackScreen(context, "Screen opened");
      setState(() {});
    });

    Future.delayed(Duration(seconds: 4), () async {
      _matomoStatus = await FlutterMatomo.trackScreenWithName("This uses a name MyAppWidget", "Screen opened");
      setState(() {});
    });

    Future.delayed(Duration(seconds: 6), () async {
      _matomoStatus = await FlutterMatomo.trackEvent(context, "Sign up button", "Clicked");
      setState(() {});
    });

    Future.delayed(Duration(seconds: 8), () async {
      _matomoStatus = await FlutterMatomo.trackEventWithName("This uses a name MyAppWidget", "LOGIIIN button", "Clicked");
      setState(() {});
    });

    Future.delayed(Duration(seconds: 10), () async {
      _matomoStatus = await FlutterMatomo.trackDownload();
      setState(() {});
    });

    Future.delayed(Duration(seconds: 12), () async {
      _matomoStatus = await FlutterMatomo.trackGoal(1);
      setState(() {});
    });

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(_matomoStatus, textAlign: TextAlign.center),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: () => FlutterMatomo.dispatchEvents(), label: Text("Dispatch now")),
      ),
    );
  }
}
