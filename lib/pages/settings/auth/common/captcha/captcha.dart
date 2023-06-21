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
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Captcha extends StatelessWidget {
  const Captcha(
      {Key? key,
      required this.url,
      required this.width,
      required this.height,
      required this.onTokenReceived,
      this.webViewColor = Colors.transparent})
      : super(key: key);

  final double width, height;
  final Function(String token) onTokenReceived;
  final Color? webViewColor;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      title: "Device verification",
      child: WebViewPlus(
        backgroundColor: webViewColor,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          controller.loadUrl(url).then((value) =>  Future.delayed(const Duration(seconds: 3))
              .then((value) => _initializeReadyJs(controller)));
    
        },
        javascriptChannels: _initializeJavascriptChannels(),
      ),
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
          onTokenReceived(message.message);
        },
      ),
    };
  }

  void _initializeReadyJs(WebViewPlusController controller) {
    RecaptchaHandler.instance.updateController(controller: controller);
  }
}

class RecaptchaHandler {
  RecaptchaHandler._();

  static RecaptchaHandler? _instance;
  late WebViewPlusController controller;
  late String _siteKey;

  String get siteKey => _siteKey;

  /// Returns an instance using the default [Env].
  static RecaptchaHandler get instance => _instance ??= RecaptchaHandler._();

  /// updates the Web view controller
  updateController({required WebViewPlusController controller}) {
    _instance?.controller = controller;

    controller.webViewController.runJavascript(
        'readyCaptcha("${_instance?._siteKey}")');
  }

  /// setups the data site key
  setupSiteKey({required String dataSiteKey}) =>
      _instance?._siteKey = dataSiteKey;

  /// Executes and call the  recaptcha API
  static executeV3() => _instance?.controller.webViewController
      .runJavascript('readyCaptcha("${_instance?._siteKey}")');
}