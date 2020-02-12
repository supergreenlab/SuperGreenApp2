import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/settings/settings_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsBlocState>(
        bloc: BlocProvider.of<SettingsBloc>(context),
        builder: (context, state) => Scaffold(
              appBar: SGLAppBar('Settings'),
              body: Text('WiFi settings'),
            ));
  }
}
