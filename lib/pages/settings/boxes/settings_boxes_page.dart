import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/settings/boxes/settings_boxes_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

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
              title: 'Cannot delete box',
              subtitle: 'Move all plants to another box first.',
            );
          } else if (state is SettingsBoxesBlocStateLoaded) {
            body = ListView.builder(
              itemCount: state.boxes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child:
                          SvgPicture.asset('assets/settings/icon_box.svg')),
                  onLongPress: () {
                    _deleteBox(context, state.boxes[index]);
                  },
                  title: Text('${index + 1}. ${state.boxes[index].name}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Long tap to delete.'),
                );
              },
            );
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Boxes settings',
                backgroundColor: Colors.deepOrange,
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: !(state is SettingsBoxesBlocStateLoaded),
              ),
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        },
      ),
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
