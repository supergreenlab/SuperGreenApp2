import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/plants/settings_plants_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class SettingsPlantsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsPlantsBloc, SettingsPlantsBlocState>(
      listener: (BuildContext context, SettingsPlantsBlocState state) {},
      child: BlocBuilder<SettingsPlantsBloc, SettingsPlantsBlocState>(
        bloc: BlocProvider.of<SettingsPlantsBloc>(context),
        builder: (BuildContext context, SettingsPlantsBlocState state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );
          int i = 0;

          if (state is SettingsPlantsBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsPlantsBlocStateLoaded) {
            if (state.plants.length == 0) {
              body = _renderNoPlant(context);
            } else {
              body = ListView.builder(
                itemCount: state.boxes.length,
                itemBuilder: (BuildContext context, int index) {
                  Box box = state.boxes[index];
                  List<Widget> content = [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0, 2))
                        ],
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading:
                            SvgPicture.asset('assets/settings/icon_lab.svg'),
                        title: Text(box.name),
                      ),
                    ),
                  ];
                  content.addAll(
                      state.plants.where((p) => p.box == box.id).map((p) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ListTile(
                        leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: SvgPicture.asset(
                                'assets/settings/icon_plants.svg')),
                        onLongPress: () {
                          _deletePlant(context, p);
                        },
                        onTap: () {
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(MainNavigateToSettingsPlant(p));
                        },
                        title: Text('${++i}. ${p.name}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Tap to open, Long press to delete.'),
                        trailing: SizedBox(
                            width: 30,
                            height: 30,
                            child: SvgPicture.asset(
                                'assets/settings/icon_${p.synced ? '' : 'un'}synced.svg')),
                      ),
                    );
                  }).toList());
                  return Column(
                    children: content,
                  );
                },
              );
            }
          }
          return Scaffold(
              appBar: SGLAppBar(
                '🍁',
                fontSize: 40,
                backgroundColor: Color(0xff0bb354),
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: !(state is SettingsPlantsBlocStateLoaded),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigateToCreatePlantEvent());
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
                elevation: 10,
              ),
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  Widget _renderNoPlant(BuildContext context) {
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
                    child: Text('You have no plant yet.',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text('Add your first',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text('PLANT',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w200,
                          color: Color(0xff3bb30b))),
                ],
              ),
            ),
            GreenButton(
              title: 'START',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToCreatePlantEvent());
              },
            ),
          ],
        )),
      ],
    );
  }

  void _deletePlant(BuildContext context, Plant plant) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text('Delete plant ${plant.name}?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<SettingsPlantsBloc>(context)
          .add(SettingsPlantsBlocEventDeletePlant(plant));
    }
  }
}
