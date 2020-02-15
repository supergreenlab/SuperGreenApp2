import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_wifi/device_wifi_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class DeviceWifiPage extends StatefulWidget {
  @override
  _DeviceWifiPageState createState() => _DeviceWifiPageState();
}

class _DeviceWifiPageState extends State<DeviceWifiPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _ssidFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<DeviceWifiBloc>(context),
      listener: (BuildContext context, DeviceWifiBlocState state) {
        if (state is DeviceWifiBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<DeviceWifiBloc, DeviceWifiBlocState>(
          bloc: BlocProvider.of<DeviceWifiBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is DeviceWifiBlocStateNotFound) {
              body = _renderNotfound();
            } else if (state is DeviceWifiBlocStateSearching) {
              body = _renderSearching();
            } else {
              body = _renderForm(context);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  'Device Wifi setup',
                  hideBackButton: (state is DeviceWifiBlocStateSearching),
                ),
                body: body);
          }),
    );
  }

  Widget _renderNotfound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Icon(Icons.warning, color: Color(0xff3bb30b), size: 100),
            Text(
              'This device is already added!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        )),
      ],
    );
  }

  Widget _renderForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              _renderInput(
                  context, 'Enter your home wifi SSID', '...', _ssidController,
                  onFieldSubmitted: (term) {
                _ssidFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_passFocusNode);
              }, focusNode: _ssidFocusNode),
              _renderInput(context, 'Enter your home wifi password', '...',
                  _passController, onFieldSubmitted: (term) {
                _handleInput(context);
              }, focusNode: _passFocusNode),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GreenButton(
              onPressed: _ssidController.text.length != 0 &&
                      _passController.text.length != 0
                  ? () => _handleInput(context)
                  : null,
              title: 'OK',
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderSearching() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Searching please wait..'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderInput(BuildContext context, String title, String hint,
      TextEditingController controller,
      {Function(String) onFieldSubmitted, FocusNode focusNode}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SectionTitle(
            title: title, icon: 'assets/box_setup/icon_controller.svg'),
      ),
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SGLTextField(
              hintText: hint,
              focusNode: focusNode,
              controller: controller,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: onFieldSubmitted,
              onChanged: (_) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    ]);
  }

  void _handleInput(BuildContext context) {
    BlocProvider.of<DeviceWifiBloc>(context).add(DeviceWifiBlocEventSetup(
      _ssidController.text,
      _passController.text,
    ));
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
