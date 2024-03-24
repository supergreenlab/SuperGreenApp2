import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device/select_device_page.dart';
import 'package:super_green_app/pages/add_plant/create_box/create_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class CreateBoxPage extends StatefulWidget {
  static String get createBoxPageNewLabLabel {
    return Intl.message(
      'New green lab\'s name:',
      name: 'createBoxPageNewLabLabel',
      desc: 'New lab label for the name input',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get createBoxPageNewLabHint {
    return Intl.message(
      'Ex: IkeHigh',
      name: 'createBoxPageNewLabHint',
      desc: 'New lab hint for the name input',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get createBoxPageNewLabButton {
    return Intl.message(
      'CREATE LAB',
      name: 'createBoxPageNewLabButton',
      desc: 'New lab button for the name input',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  _CreateBoxPageState createState() => _CreateBoxPageState();
}

class _CreateBoxPageState extends State<CreateBoxPage> {
  final _nameController = TextEditingController();

  final KeyboardVisibilityController _keyboardVisibility =
      KeyboardVisibilityController();
  late StreamSubscription<bool> _listener;
  bool _keyboardVisible = false;

  @protected
  void initState() {
    super.initState();
    _listener = _keyboardVisibility.onChange.listen(
      (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
        if (!_keyboardVisible) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBoxBloc, CreateBoxBlocState>(
      bloc: BlocProvider.of<CreateBoxBloc>(context),
      listener: (BuildContext context, CreateBoxBlocState state) async {
        if (state is CreateBoxBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(param: state.box));
        }
      },
      child: BlocBuilder<CreateBoxBloc, CreateBoxBlocState>(
          bloc: BlocProvider.of<CreateBoxBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is CreateBoxBlocStateDone) {
              body = _renderDone(state);
            } else {
              body = _renderForm();
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '💬',
                  fontSize: 40,
                  hideBackButton: state is CreateBoxBlocStateDone,
                  backgroundColor: Colors.yellow,
                  titleColor: Colors.green,
                  iconColor: Colors.green,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderDone(CreateBoxBlocStateDone state) {
    return Fullscreen(
        title: 'Done!',
        child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _keyboardVisible ? 0 : 100,
          color: Colors.yellow,
        ),
        SectionTitle(
          title: CreateBoxPage.createBoxPageNewLabLabel,
          icon: 'assets/box_setup/icon_box.svg',
          backgroundColor: Colors.yellow,
          titleColor: Colors.green,
          large: true,
          elevation: 5,
        ),
        Expanded(
            child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
              child: SGLTextField(
                  hintText: CreateBoxPage.createBoxPageNewLabHint,
                  controller: _nameController,
                  onChanged: (_) {
                    setState(() {});
                  }),
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: SafeArea(
              child: GreenButton(
                title: CreateBoxPage.createBoxPageNewLabButton,
                onPressed: _nameController.value.text != ''
                    ? () => _handleInput(context)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectDeviceEvent(
            isController: true,
            futureFn: (future) async {
              dynamic res = await future;
              if (res is SelectBoxDeviceData) {
                BlocProvider.of<CreateBoxBloc>(context).add(
                    CreateBoxBlocEventCreate(_nameController.text,
                        device: res.device, deviceBox: res.deviceBox));
              } else if (res == false) {
                BlocProvider.of<CreateBoxBloc>(context)
                    .add(CreateBoxBlocEventCreate(_nameController.text));
              }
            }));
  }

  @override
  void dispose() {
    _listener.cancel();
    _nameController.dispose();
    super.dispose();
  }
}
