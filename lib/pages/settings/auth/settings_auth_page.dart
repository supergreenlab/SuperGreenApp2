import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/auth/settings_auth_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsAuthPage extends StatefulWidget {
  @override
  _SettingsAuthPageState createState() => _SettingsAuthPageState();
}

class _SettingsAuthPageState extends State<SettingsAuthPage> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsAuthBloc, SettingsAuthBlocState>(
      listener: (BuildContext context, SettingsAuthBlocState state) {
        if (state is SettingsAuthBlocStateDone) {
          Timer(Duration(seconds: 2), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          });
        }
      },
      child: BlocBuilder<SettingsAuthBloc, SettingsAuthBlocState>(
        bloc: BlocProvider.of<SettingsAuthBloc>(context),
        builder: (BuildContext context, SettingsAuthBlocState state) {
          Widget body;

          if (state is SettingsAuthBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsAuthBlocStateDone) {
            body = Fullscreen(
              title: 'Done!',
              child: Icon(
                Icons.check,
                color: Color(0xff3bb30b),
                size: 100,
              ),
            );
          } else if (state is SettingsAuthBlocStateError) {
            body = Fullscreen(
              title: 'Error',
              subtitle: 'Couldn\'t create account',
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
            );
          } else if (state is SettingsAuthBlocStateLoaded) {
            body = ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SectionTitle(
                      title: 'Enter you nickname:',
                      icon: 'assets/settings/icon_account.svg',
                      backgroundColor: Colors.deepOrange,
                      titleColor: Colors.white,
                      large: true,
                      elevation: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 24.0),
                      child: SGLTextField(
                          focusNode: _nicknameFocusNode,
                          onFieldSubmitted: (_) {
                            _nicknameFocusNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          hintText: 'Ex: Bob',
                          controller: _nicknameController,
                          onChanged: (_) {
                            setState(() {});
                          }),
                    ),
                    SectionTitle(
                      title: 'Enter your password:',
                      icon: 'assets/box_setup/icon_box_name.svg',
                      backgroundColor: Colors.deepOrange,
                      titleColor: Colors.white,
                      large: true,
                      elevation: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 24.0),
                      child: SGLTextField(
                          focusNode: _passwordFocusNode,
                          onFieldSubmitted: (_) {
                            _handleInput(context);
                          },
                          controller: _passwordController,
                          obscureText: true,
                          onChanged: (_) {
                            setState(() {});
                          }),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GreenButton(
                      title: 'CREATE ACCOUNT',
                      onPressed: _nicknameController.value.text != '' &&
                              _passwordController.value.text != ''
                          ? () => _handleInput(context)
                          : null,
                    ),
                  ),
                ),
              ],
            );
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Create your account',
                backgroundColor: Colors.deepOrange,
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: !(state is SettingsAuthBlocStateLoaded),
              ),
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  void _handleInput(BuildContext context) {
    BlocProvider.of<SettingsAuthBloc>(context).add(
        SettingsAuthBlocEventCreateAccount(
            _nicknameController.value.text, _passwordController.value.text));
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
