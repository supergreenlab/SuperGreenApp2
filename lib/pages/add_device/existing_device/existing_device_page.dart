import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/existing_device/existing_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class ExistingDevicePage extends StatefulWidget {
  @override
  _ExistingDevicePageState createState() => _ExistingDevicePageState();
}

class _ExistingDevicePageState extends State<ExistingDevicePage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<ExistingDeviceBloc>(context),
      listener: (BuildContext context, ExistingDeviceBlocState state) {
        if (state is ExistingDeviceBlocStateFound) {
          BlocProvider.of<MainNavigatorBloc>(context).add(
              MainNavigateToDeviceSetupEvent(state.ip,
                  futureFn: (future) async {
            Device device = await future;
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(param: device));
          }));
        }
      },
      child: BlocBuilder<ExistingDeviceBloc, ExistingDeviceBlocState>(
          bloc: Provider.of<ExistingDeviceBloc>(context),
          builder: (context, state) {
            final body = <Widget>[
              SectionTitle(
                  title: 'Enter device name or IP',
                  icon: 'assets/box_setup/icon_search.svg'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Please make sure your mobile phone is connected to your home wifi. Then we\'ll search for it by name or by IP, please fill the following text field.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SGLTextField(
                    enabled: !(state is ExistingDeviceBlocStateResolving),
                    hintText: 'Ex: supergreencontroller or IP address',
                    controller: _nameController,
                    onChanged: (_) {
                      setState(() {});
                    }),
              ),
            ];
            if (state is ExistingDeviceBlocStateNotFound) {
              body.add(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Device "${_nameController.value.text}" not found!',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500)),
              ));
            }
            return Scaffold(
              appBar: SGLAppBar('Add device'),
              body: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: body,
                      ),
                    ),
                    (state is ExistingDeviceBlocStateResolving)
                        ? _renderLoading()
                        : _renderButton(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<ExistingDeviceBloc>(context)
        .add(ExistingDeviceBlocEventStartSearch(_nameController.value.text));
  }

  Widget _renderLoading() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 20.0,
              width: 100.0,
              child: Center(
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 4.0,
                ),
              ),
            )));
  }

  Widget _renderButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: GreenButton(
          title: 'SEARCH DEVICE',
          onPressed: _nameController.value.text != ''
              ? () => _handleInput(context)
              : null,
        ),
      ),
    );
  }
}
