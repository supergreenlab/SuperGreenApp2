import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device_box/select_device_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SelectDeviceBoxPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectDeviceBoxPageState();
}

class SelectDeviceBoxPageState extends State<SelectDeviceBoxPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectDeviceBoxBloc, SelectDeviceBoxBlocState>(
        bloc: Provider.of<SelectDeviceBoxBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar('Device configuration'),
            body: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SectionTitle(
                        title: 'Available LED channels',
                        icon: 'assets/box_setup/icon_controller.svg',
                      ),
                    ),
                    _renderBoxes(state),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GreenButton(
                          title: 'CREATE BOX',
                          onPressed: () => _handleInput(context),
                        ),
                      ),
                    ),
                  ],
                ))));
  }

  Widget _renderBoxes(state) {
    return Row(
      children: state.leds
          .map<Widget>((led) => _renderBox(
              context,
              () {},
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: SvgPicture.asset('assets/feed_form/icon_add.svg'),
              )))
          .toList(),
    );
  }

  void _handleInput(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigatorActionPop(param: 0));
  }

  Widget _renderBox(BuildContext context, Function onPressed, Widget content) {
    return SizedBox(
        width: 70,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
          child: RawMaterialButton(
            onPressed: onPressed,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: content),
          ),
        ));
  }
}
