import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/timelapse/timelapse_connect/timelapse_connect_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class TimelapseConnectPage extends StatefulWidget {
  @override
  _TimelapseConnectPageState createState() => _TimelapseConnectPageState();
}

class _TimelapseConnectPageState extends State<TimelapseConnectPage> {
  final TextEditingController _dropboxToken = TextEditingController();
  final TextEditingController _uploadName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimelapseConnectBloc, TimelapseConnectBlocState>(
      listener: (BuildContext context, TimelapseConnectBlocState state) {
        if (state is TimelapseConnectBlocStateDone) {
          Timer(Duration(seconds: 3), () {
            BlocProvider.of<MainNavigatorBloc>(context).add(
                MainNavigateToTimelapseViewer(state.plant,
                    pushAsReplacement: true));
          });
        }
      },
      child: BlocBuilder<TimelapseConnectBloc, TimelapseConnectBlocState>(
          bloc: BlocProvider.of<TimelapseConnectBloc>(context),
          builder: (BuildContext context, TimelapseConnectBlocState state) {
            Widget body;

            if (state is TimelapseConnectBlocStateDone) {
              body = Fullscreen(
                  title: "Done!",
                  child: Icon(
                    Icons.check,
                    color: Color(0xff3bb30b),
                    size: 100,
                  ));
            } else if (state is TimelapseConnectBlocState) {
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
                            title: 'Storage config',
                            icon: 'assets/feed_form/icon_storage.svg'),
                        _renderInput('Dropbox token', _dropboxToken),
                        _renderInput('Upload name', _uploadName),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GreenButton(
                            title: 'OK',
                            onPressed: () {
                              BlocProvider.of<TimelapseConnectBloc>(context)
                                  .add(TimelapseConnectBlocEventSaveConfig(
                                      dropboxToken: _dropboxToken.value.text,
                                      uploadName: _uploadName.value.text));
                            },
                          ),
                        ),
                        Container(height: 50),
                      ],
                    ),
                  ),
                ],
              ));
            }
            return Scaffold(
                appBar: SGLAppBar(
                  'Timelapse',
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
          }),
    );
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
