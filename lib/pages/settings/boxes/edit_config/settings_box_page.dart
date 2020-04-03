import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device/select_device_page.dart';
import 'package:super_green_app/pages/settings/boxes/edit_config/settings_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsBoxPage extends StatefulWidget {
  @override
  _SettingsBoxPageState createState() => _SettingsBoxPageState();
}

class _SettingsBoxPageState extends State<SettingsBoxPage> {
  TextEditingController _nameController;
  Device _device;
  int _deviceBox;

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
      bloc: BlocProvider.of<SettingsBoxBloc>(context),
      listener: (BuildContext context, SettingsBoxBlocState state) async {
        if (state is SettingsBoxBlocStateLoaded) {
          _nameController = TextEditingController(text: state.box.name);
          _device = state.device;
          _deviceBox = state.deviceBox;
        } else if (state is SettingsBoxBlocStateDone) {
          Timer(const Duration(milliseconds: 2000), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          });
        }
      },
      child: BlocBuilder<SettingsBoxBloc, SettingsBoxBlocState>(
          bloc: BlocProvider.of<SettingsBoxBloc>(context),
          builder: (BuildContext context, SettingsBoxBlocState state) {
            Widget body;
            if (state is SettingsBoxBlocStateDone) {
              body = _renderDone(state);
            } else {
              body = _renderForm(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '⚗️',
                  fontSize: 35,
                  backgroundColor: Colors.yellow,
                  titleColor: Colors.green,
                  iconColor: Colors.green,
                  hideBackButton: state is SettingsBoxBlocStateDone,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderDone(SettingsBoxBlocStateDone state) {
    String subtitle = _device != null
        ? 'Plant ${_nameController.value.text} on box ${_device.name} updated:)'
        : 'Plant ${_nameController.value.text}';
    return Fullscreen(
        title: 'Done!',
        subtitle: subtitle,
        child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm(BuildContext context, SettingsBoxBlocStateLoaded state) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              SectionTitle(
                title: 'Lab name',
                icon: 'assets/settings/icon_lab.svg',
                backgroundColor: Colors.yellow,
                titleColor: Colors.green,
                elevation: 5,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                child: SGLTextField(
                    hintText: 'Ex: Gorilla Kush',
                    controller: _nameController,
                    onChanged: (_) {
                      setState(() {});
                    }),
              ),
              SectionTitle(
                title: 'Lab controller',
                icon: 'assets/box_setup/icon_controller.svg',
                backgroundColor: Color(0xff0b6ab3),
                titleColor: Colors.white,
                elevation: 5,
              ),
              _device != null
                  ? ListTile(
                      leading: SvgPicture.asset(
                          'assets/box_setup/icon_controller.svg'),
                      title: Text('${_device.name} box #${_deviceBox + 1}'),
                      subtitle: Text('Tap to change'),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        _handleChangeController(context);
                      },
                    )
                  : ListTile(
                      leading: SvgPicture.asset(
                          'assets/settings/icon_nocontroller.svg'),
                      title: Text('Lab isn\'t linked to any controller'),
                      subtitle: Text('Tap to add one'),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        _handleChangeController(context);
                      },
                    ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GreenButton(
              title: 'UPDATE LAB',
              onPressed: _nameController.value.text != ''
                  ? () => _handleInput(context)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _handleChangeController(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectDeviceEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is SelectBoxDeviceData) {
        setState(() {
          _device = res.device;
          _deviceBox = res.deviceBox;
        });
      } else if (res is bool && res == false) {
        setState(() {
          _device = null;
          _deviceBox = null;
        });
      }
    }));
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<SettingsBoxBloc>(context).add(SettingsBoxBlocEventUpdate(
      _nameController.text,
      _device,
      _deviceBox,
    ));
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _nameController.dispose();
    super.dispose();
  }
}
