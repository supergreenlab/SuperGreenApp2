import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/auth/common/captcha.dart';
import 'package:super_green_app/pages/settings/auth/create_account/settings_create_account_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsCreateAccountPage extends TraceableStatefulWidget {
  @override
  _SettingsCreateAccountPageState createState() => _SettingsCreateAccountPageState();
}

class _SettingsCreateAccountPageState extends State<SettingsCreateAccountPage> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String? token;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCreateAccountBloc, SettingsCreateAccountBlocState>(
      listener: (BuildContext context, SettingsCreateAccountBlocState state) {
        if (state is SettingsCreateAccountBlocStateDone) {
          Timer(Duration(seconds: 2), () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: true));
          });
        }
      },
      child: BlocBuilder<SettingsCreateAccountBloc, SettingsCreateAccountBlocState>(
        bloc: BlocProvider.of<SettingsCreateAccountBloc>(context),
        builder: (BuildContext context, SettingsCreateAccountBlocState state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );

          if (state is SettingsCreateAccountBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsCreateAccountBlocStateDone) {
            body = Fullscreen(
              title: 'Done!',
              child: Icon(
                Icons.check,
                color: Color(0xff3bb30b),
                size: 100,
              ),
            );
          } else if (state is SettingsCreateAccountBlocStateError) {
            body = Fullscreen(
              title: 'Error',
              subtitle: 'Couldn\'t create account',
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
            );
          } else if (state is SettingsCreateAccountBlocStateLoaded) {
            body = SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.indigo,
                    child: Center(
                      child: Text('Create account', style: TextStyle(color: Colors.white, fontSize: 20)),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Captcha(
                            webViewColor: null,
                            onTokenReceived: _onTokenReceived,
                            url: '${BackendAPI().serverHost}/user/captcha',
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GreenButton(
                        title: 'CREATE ACCOUNT',
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
                hideBackButton: !(state is SettingsCreateAccountBlocStateLoaded),
              ),
              body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  void _onTokenReceived(String token) {
    setState(() {
      this.token = token;
    });
  }

  void _handleInput(BuildContext context) {
    BlocProvider.of<SettingsCreateAccountBloc>(context).add(
        SettingsCreateAccountBlocEventCreateAccount(_nicknameController.value.text, _passwordController.value.text));
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
