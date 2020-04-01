import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/plants/settings_plants_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class SettingsPlantsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsPlantsBloc, SettingsPlantsBlocState>(
      listener: (BuildContext context, SettingsPlantsBlocState state) {},
      child: BlocBuilder<SettingsPlantsBloc, SettingsPlantsBlocState>(
        bloc: BlocProvider.of<SettingsPlantsBloc>(context),
        builder: (BuildContext context, SettingsPlantsBlocState state) {
          Widget body;

          if (state is SettingsPlantsBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsPlantsBlocStateLoaded) {
            body = ListView.builder(
              itemCount: state.plants.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child:
                          SvgPicture.asset('assets/settings/icon_plants.svg')),
                  onLongPress: () {
                    _deletePlant(context, state.plants[index]);
                  },
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToSettingsPlant(state.plants[index]));
                  },
                  title: Text('${index + 1}. ${state.plants[index].name}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Long tap to delete.'),
                );
              },
            );
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Plants settings',
                backgroundColor: Colors.deepOrange,
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: !(state is SettingsPlantsBlocStateLoaded),
              ),
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  void _deletePlant(BuildContext context, Plant plant) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete plant ${plant.name}?'),
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
      BlocProvider.of<SettingsPlantsBloc>(context)
          .add(SettingsPlantsBlocEventDeletePlant(plant));
    }
  }
}
