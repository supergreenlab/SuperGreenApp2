/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/red_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Captcha extends StatefulWidget {
  const Captcha(
      {Key? key,
      required this.url,
      required this.onTokenReceived,
      this.webViewColor = Colors.transparent})
      : super(key: key);

  final Function(String token) onTokenReceived;
  final Color? webViewColor;
  final String url;

  @override
  State<Captcha> createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  bool loaded = false;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.webViewColor ?? Colors.transparent)
      ..addJavaScriptChannel('readyCaptcha', onMessageReceived: (message) {})
      ..addJavaScriptChannel('Captcha', onMessageReceived: (message) {
        if (message.message == 'ready') {
          setState(() {
            loaded = true;
          });
          return;
        } else if (message.message == 'error' || message.message == 'expired') {
          Navigator.pop(context);
          return;
        }
        widget.onTokenReceived(message.message);
      })
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          RecaptchaHandler.instance.start();
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
    RecaptchaHandler.instance.updateController(_controller);
  }

  @override
  Widget build(BuildContext context) {
    Widget webview = SingleChildScrollView(
      child: SizedBox(
        height: 600,
        child: WebViewWidget(controller: _controller),
      ),
    );
    if (!loaded) {
      webview = Stack(
        children: [
          webview,
          FullscreenLoading(
            backgroundColor: Colors.white,
          ),
        ],
      );
    }
    return Column(
      children: [
        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text(
              '🔐 Device verification',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff454545)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
              'Please complete the following captcha to prove you\'re not a robot.'),
        ),
        Expanded(
          child: webview,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RedButton(
              title: 'Cancel',
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
      ],
    );
  }
}

class RecaptchaHandler {
  RecaptchaHandler._();

  static RecaptchaHandler? _instance;
  late WebViewController controller;
  late String _siteKey;

  String get siteKey => _siteKey;

  static RecaptchaHandler get instance => _instance ??= RecaptchaHandler._();

  updateController(WebViewController controller) {
    _instance?.controller = controller;
  }

  start() {
    controller.runJavaScript('readyCaptcha("${_instance?._siteKey}")');
  }

  setupSiteKey({required String dataSiteKey}) =>
      _instance?._siteKey = dataSiteKey;

  static executeV3() => _instance?.controller
      .runJavaScript('readyCaptcha("${_instance?._siteKey}")');
}
