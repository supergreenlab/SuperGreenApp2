import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/plants/edit_config/settings_plant_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsPlantPage extends StatefulWidget {
  @override
  _SettingsPlantPageState createState() => _SettingsPlantPageState();
}

class _SettingsPlantPageState extends State<SettingsPlantPage> {
  TextEditingController _nameController;
  Box _box;

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
      bloc: BlocProvider.of<SettingsPlantBloc>(context),
      listener: (BuildContext context, SettingsPlantBlocState state) async {
        if (state is SettingsPlantBlocStateLoaded) {
          _nameController = TextEditingController(text: state.plant.name);
          _box = state.box;
        } else if (state is SettingsPlantBlocStateDone) {
          Timer(const Duration(milliseconds: 2000), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          });
        }
      },
      child: BlocBuilder<SettingsPlantBloc, SettingsPlantBlocState>(
          bloc: BlocProvider.of<SettingsPlantBloc>(context),
          builder: (BuildContext context, SettingsPlantBlocState state) {
            Widget body;
            if (state is SettingsPlantBlocStateDone) {
              body = _renderDone(state);
            } else {
              body = _renderForm(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  'Plant creation',
                  hideBackButton: state is SettingsPlantBlocStateDone,
                  backgroundColor: Color(0xff0bb354),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderDone(SettingsPlantBlocStateDone state) {
    String subtitle =
        'Plant ${_nameController.value.text} on box ${_box.name} updated:)';
    return Fullscreen(
        title: 'Done!',
        subtitle: subtitle,
        child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm(BuildContext context, SettingsPlantBlocStateLoaded state) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              SectionTitle(
                title: 'Plant name',
                icon: 'assets/box_setup/icon_box_name.svg',
                backgroundColor: Color(0xff0bb354),
                titleColor: Colors.white,
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
                title: 'Plant box',
                icon: 'assets/box_setup/icon_box.svg',
                backgroundColor: Color(0xff0bb354),
                titleColor: Colors.white,
                elevation: 5,
              ),
              ListTile(
                leading: SvgPicture.asset('assets/box_setup/icon_box.svg'),
                title: Text(_box.name),
                subtitle: Text('Tap to change'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  _handleChangeBox(context);
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
              title: 'UPDATE PLANT',
              onPressed: _nameController.value.text != ''
                  ? () => _handleInput(context)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _handleChangeBox(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectBoxEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is Box) {
        setState(() {
          _box = res;
        });
      }
    }));
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<SettingsPlantBloc>(context)
        .add(SettingsPlantBlocEventUpdate(
      _nameController.text,
      _box,
    ));
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _nameController.dispose();
    super.dispose();
  }
}
