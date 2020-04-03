import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/boxes/settings_boxes_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class SettingsBoxesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBoxesBloc, SettingsBoxesBlocState>(
      listener: (BuildContext context, SettingsBoxesBlocState state) {},
      child: BlocBuilder<SettingsBoxesBloc, SettingsBoxesBlocState>(
        bloc: BlocProvider.of<SettingsBoxesBloc>(context),
        builder: (BuildContext context, SettingsBoxesBlocState state) {
          Widget body;

          if (state is SettingsBoxesBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsBoxesBlocStateNotEmptyBox) {
            body = Fullscreen(
              child: Icon(Icons.do_not_disturb, color: Colors.red, size: 100),
              title: 'Cannot delete lab',
              subtitle: 'Move all plants to another lab first.',
            );
          } else if (state is SettingsBoxesBlocStateLoaded) {
            if (state.boxes.length == 0) {
              body = _renderNoBox(context);
            } else {
              body = ListView.builder(
                itemCount: state.boxes.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: SizedBox(
                        width: 40,
                        height: 40,
                        child:
                            SvgPicture.asset('assets/settings/icon_lab.svg')),
                    onLongPress: () {
                      _deleteBox(context, state.boxes[index]);
                    },
                    onTap: () {
                      BlocProvider.of<MainNavigatorBloc>(context).add(
                          MainNavigateToSettingsBox(state.boxes[index]));
                    },
                    title: Text('${index + 1}. ${state.boxes[index].name}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Long tap to delete.'),
                  );
                },
              );
            }
          }
          return Scaffold(
              appBar: SGLAppBar(
                '⚗️',
                fontSize: 35,
                backgroundColor: Colors.yellow,
                titleColor: Colors.green,
                iconColor: Colors.green,
                hideBackButton: !(state is SettingsBoxesBlocStateLoaded),
              ),
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  Widget _renderNoBox(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text('You have no lab yet',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text('Create your first',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text('GREEN LAB',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w200,
                          color: Color(0xff3bb30b))),
                ],
              ),
            ),
            GreenButton(
              title: 'CREATE',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToCreateBoxEvent());
              },
            ),
          ],
        )),
      ],
    );
  }

  void _deleteBox(BuildContext context, Box box) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete box ${box.name}?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<SettingsBoxesBloc>(context)
          .add(SettingsBoxesBlocEventDeleteBox(box));
    }
  }
}
