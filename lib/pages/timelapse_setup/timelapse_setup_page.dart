import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/timelapse_setup/timelapse_setup_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class TimelapseSetupPage extends StatefulWidget {
  @override
  _TimelapseSetupPageState createState() => _TimelapseSetupPageState();
}

class _TimelapseSetupPageState extends State<TimelapseSetupPage> {
  final TextEditingController _ssid = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _controllerid = TextEditingController();
  final TextEditingController _dropboxToken = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _strain = TextEditingController();
  final TextEditingController _uploadName = TextEditingController();
  final TextEditingController _rotate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelapseSetupBloc, TimelapseSetupBlocState>(
        bloc: BlocProvider.of<TimelapseSetupBloc>(context),
        builder: (BuildContext context, TimelapseSetupBlocState state) {
          Widget body;

          if (state is TimelapseSetupBlocStateScanning) {
            body = FullscreenLoading(
              title: 'Scanning devices',
            );
          } else if (state is TimelapseSetupBlocStateInit) {
            body = FullscreenLoading(
              title: 'Setting up bluetooth',
            );
          } else if (state is TimelapseSetupBlocStateBleOFF) {
            body = Fullscreen(
                title: 'Bluetooth is OFF',
                child: Icon(Icons.bluetooth_disabled));
          } else if (state is TimelapseSetupBlocStateUnauthorized) {
            body = Fullscreen(
                title: 'Bluetooth is not authorized',
                child: Icon(Icons.bluetooth_disabled));
          } else if (state is TimelapseSetupBlocStateDeviceFound) {
            body = Form(
                child: Column(
              children: <Widget>[
                SectionTitle(
                    title: 'Timelapse configuration',
                    icon: 'assets/feed_card/icon_media.svg'),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      SectionTitle(
                          title: 'Wifi config',
                          icon: 'assets/feed_form/icon_wifi.svg'),
                      _renderInput('Wifi SSID', _ssid),
                      _renderInput('Wifi password', _password),
                      SectionTitle(
                          title: 'Display config',
                          icon: 'assets/feed_form/icon_display.svg'),
                      _renderInput('Controller ID', _controllerid),
                      _renderInput('Rotate (true or false)', _rotate),
                      _renderInput('Name (displayed on frames)', _name),
                      _renderInput('Strain (displayed on frames)', _strain),
                      SectionTitle(
                          title: 'Storage config',
                          icon: 'assets/feed_form/icon_storage.svg'),
                      _renderInput('Dropbox token', _dropboxToken),
                      _renderInput('Upload name', _uploadName),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GreenButton(
                          title: 'OK',
                          onPressed: () {
                            BlocProvider.of<TimelapseSetupBloc>(context).add(
                                TimelapseSetpuBlocEventSetConfig(
                                    ssid: _ssid.value.text,
                                    password: _password.value.text,
                                    controllerID: _controllerid.value.text,
                                    dropboxToken: _dropboxToken.value.text,
                                    name: _name.value.text,
                                    strain: _strain.value.text,
                                    uploadName: _uploadName.value.text,
                                    rotate: _rotate.value.text));
                          },
                        ),
                      ),
                      Container(height: 50),
                    ],
                  ),
                ),
              ],
            ));
          } else if (state is TimelapseSetupBlocStateSettingParams) {
            body = FullscreenLoading(
              title: 'Setting params..',
            );
          } else if (state is TimelapseSetupBlocStateDone) {
            body = Fullscreen(
                title: "Done!",
                child: Icon(
                  Icons.check,
                  color: Color(0xff3bb30b),
                  size: 100,
                ));
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Timelapse',
              ),
              backgroundColor: Colors.white,
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        });
  }

  Widget _renderInput(String name, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: TextFormField(
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(labelText: name),
        controller: controller,
      ),
    );
  }
}
