import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/config.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/auth/common/captcha.dart';
import 'package:super_green_app/pages/settings/auth/login/settings_login_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsLoginPage extends StatefulWidget {
  @override
  _SettingsLoginPageState createState() => _SettingsLoginPageState();
}

class _SettingsLoginPageState extends State<SettingsLoginPage> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsLoginBloc, SettingsLoginBlocState>(
      listener: (BuildContext context, SettingsLoginBlocState state) {
        if (state is SettingsLoginBlocStateDone) {
          Timer(Duration(seconds: 2), () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: true));
          });
        }
      },
      child: BlocBuilder<SettingsLoginBloc, SettingsLoginBlocState>(
        bloc: BlocProvider.of<SettingsLoginBloc>(context),
        builder: (BuildContext context, SettingsLoginBlocState state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );

          if (state is SettingsLoginBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsLoginBlocStateDone) {
            body = Fullscreen(
              title: 'Done!',
              child: Icon(
                Icons.check,
                color: Color(0xff3bb30b),
                size: 100,
              ),
            );
          } else if (state is SettingsLoginBlocStateError) {
            body = Fullscreen(
              title: 'Error',
              subtitle: 'Couldn\'t login',
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
            );
          } else if (state is SettingsLoginBlocStateLoaded) {
            body = SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.indigo,
                    child: Center(
                      child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        SectionTitle(
                          title: 'Enter your nickname:',
                          icon: 'assets/settings/icon_account.svg',
                          backgroundColor: Colors.indigo,
                          titleColor: Colors.white,
                          elevation: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                          child: SGLTextField(
                              textCapitalization: TextCapitalization.none,
                              focusNode: _nicknameFocusNode,
                              onFieldSubmitted: (_) {
                                _nicknameFocusNode.unfocus();
                                FocusScope.of(context).requestFocus(_passwordFocusNode);
                              },
                              hintText: 'Ex: Bob',
                              controller: _nicknameController,
                              onChanged: (_) {
                                setState(() {});
                              }),
                        ),
                        SectionTitle(
                          title: 'Enter your password:',
                          icon: 'assets/settings/icon_password.svg',
                          backgroundColor: Colors.indigo,
                          titleColor: Colors.white,
                          elevation: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                          child: SGLTextField(
                              textCapitalization: TextCapitalization.none,
                              focusNode: _passwordFocusNode,
                              onFieldSubmitted: (_) {
                                _handleInput(context);
                              },
                              controller: _passwordController,
                              obscureText: true,
                              hintText: '***',
                              onChanged: (_) {
                                setState(() {});
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GreenButton(
                        title: 'LOGIN',
                        onPressed: _nicknameController.value.text != '' && _passwordController.value.text != ''
                            ? () => _handleInput(context)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
              appBar: SGLAppBar(
                '🔐',
                fontSize: 35,
                backgroundColor: Colors.indigo,
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: !(state is SettingsLoginBlocStateLoaded),
              ),
              body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  void _onTokenReceived(String token) {
    Navigator.pop(context);
    BlocProvider.of<SettingsLoginBloc>(context)
        .add(SettingsLoginBlocEventLogin(_nicknameController.value.text, _passwordController.value.text, token));
  }

  void _handleInput(BuildContext context) {
    if (kReleaseMode) {
      showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Captcha(
                webViewColor: null,
                onTokenReceived: _onTokenReceived,
                url: '${BackendAPI().serverHost}/user/captcha',
              ),
            );
          });
    } else {
      BlocProvider.of<SettingsLoginBloc>(context).add(
          SettingsLoginBlocEventLogin(_nicknameController.value.text, _passwordController.value.text, Config.skipCaptchaToken));
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
