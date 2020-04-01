import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_plant/create_box/create_box_bloc.dart';
import 'package:super_green_app/pages/add_plant/select_device/select_device_page.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class CreateBoxPage extends StatefulWidget {
  @override
  _CreateBoxPageState createState() => _CreateBoxPageState();
}

class _CreateBoxPageState extends State<CreateBoxPage> {
  final _nameController = TextEditingController();

  KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();

  int _listener;

  bool _keyboardVisible = false;

  @protected
  void initState() {
    super.initState();
    _listener = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
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
    return BlocListener(
      bloc: BlocProvider.of<CreateBoxBloc>(context),
      listener: (BuildContext context, CreateBoxBlocState state) async {
        if (state is CreateBoxBlocStateDone) {
          Timer(const Duration(milliseconds: 1500), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(param: state.box));
          });
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
                  'Box creation',
                  hideBackButton: state is CreateBoxBlocStateDone,
                  backgroundColor: Colors.pink,
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderDone(CreateBoxBlocStateDone state) {
    String subtitle =
        'Plant ${_nameController.value.text} on controller ${state.box.name} created:)';
    return Fullscreen(
        title: 'Done!',
        subtitle: subtitle,
        child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _keyboardVisible ? 0 : 100,
          color: Colors.pink,
        ),
        SectionTitle(
          title: 'Give this box a name:',
          icon: 'assets/box_setup/icon_box.svg',
          backgroundColor: Colors.pink,
          titleColor: Colors.white,
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
                  hintText: 'Ex: IkeHigh',
                  controller: _nameController,
                  onChanged: (_) {
                    setState(() {});
                  }),
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GreenButton(
              title: 'CREATE BOX',
              onPressed: _nameController.value.text != ''
                  ? () => _handleInput(context)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectDeviceEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is SelectBoxDeviceData) {
        BlocProvider.of<CreateBoxBloc>(context).add(CreateBoxBlocEventCreate(
            _nameController.text,
            device: res.device,
            deviceBox: res.deviceBox));
      } else if (res == false) {
        BlocProvider.of<CreateBoxBloc>(context)
            .add(CreateBoxBlocEventCreate(_nameController.text));
      }
    }));
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _nameController.dispose();
    super.dispose();
  }
}
