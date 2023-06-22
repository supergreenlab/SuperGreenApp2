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
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Captcha extends StatefulWidget {
  const Captcha({Key? key, required this.url, required this.onTokenReceived, this.webViewColor = Colors.transparent})
      : super(key: key);

  final Function(String token) onTokenReceived;
  final Color? webViewColor;
  final String url;

  @override
  State<Captcha> createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  bool loaded = false;
  GlobalKey webviewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget webview = SingleChildScrollView(
      child: SizedBox(
        height: 600,
        child: WebViewPlus(
          key: webviewKey,
          zoomEnabled: false,
          backgroundColor: widget.webViewColor,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            RecaptchaHandler.instance.updateController(controller);
            controller.loadUrl(widget.url);
          },
          onPageFinished: (url) {
            RecaptchaHandler.instance.start();
          },
          javascriptChannels: _initializeJavascriptChannels(),
        ),
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
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text(
              '🔐 Device verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff454545)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Please complete the following captcha to prove you\'re not a robot.'),
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

  Set<JavascriptChannel> _initializeJavascriptChannels() {
    return {
      JavascriptChannel(
        name: 'readyCaptcha',
        onMessageReceived: (JavascriptMessage message) {},
      ),
      JavascriptChannel(
        name: 'Captcha',
        onMessageReceived: (JavascriptMessage message) {
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
        },
      ),
    };
  }
}

// TODO remove this shit, comes from a shitty github repo. Makes no sense.
class RecaptchaHandler {
  RecaptchaHandler._();

  static RecaptchaHandler? _instance;
  late WebViewPlusController controller;
  late String _siteKey;

  String get siteKey => _siteKey;

  /// Returns an instance using the default [Env].
  static RecaptchaHandler get instance => _instance ??= RecaptchaHandler._();

  /// updates the Web view controller
  updateController(WebViewPlusController controller) {
    _instance?.controller = controller;
  }

  start() {
    controller.webViewController.runJavascript('readyCaptcha("${_instance?._siteKey}")');
  }

  /// setups the data site key
  setupSiteKey({required String dataSiteKey}) => _instance?._siteKey = dataSiteKey;

  /// Executes and call the  recaptcha API
  static executeV3() => _instance?.controller.webViewController.runJavascript('readyCaptcha("${_instance?._siteKey}")');
}
