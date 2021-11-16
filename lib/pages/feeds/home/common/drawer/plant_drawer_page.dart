import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/drawer/plant_drawer_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class PlantDrawerPage extends TraceableStatefulWidget {
  static String get plantDrawerPagePlantList {
    return Intl.message(
      'Plant list',
      name: 'plantDrawerPagePlantList',
      desc: 'Plant list title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantDrawerPageAddPlantLabel {
    return Intl.message(
      'Add new plant',
      name: 'plantDrawerPageAddPlantLabel',
      desc: 'Add plant button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final Plant? selectedPlant;
  final Box? selectedBox;

  const PlantDrawerPage({Key? key, this.selectedPlant, this.selectedBox}) : super(key: key);

  @override
  _PlantDrawerPageState createState() => _PlantDrawerPageState();
}

class _PlantDrawerPageState extends State<PlantDrawerPage> {
  late ScrollController drawerScrollController;

  @override
  void initState() {
    drawerScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantDrawerBloc, PlantDrawerBlocState>(
      builder: (BuildContext context, PlantDrawerBlocState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Color(0xff063047),
              height: 120,
              child: DrawerHeader(
                  child: Row(children: <Widget>[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: SvgPicture.asset("assets/super_green_lab_vertical_white.svg"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(PlantDrawerPage.plantDrawerPagePlantList,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300)),
                ),
              ])),
            ),
            Expanded(
              child: _plantList(context),
            ),
            Divider(),
            Container(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                        child: Column(
                      children: <Widget>[
                        ListTile(
                            leading: Icon(Icons.add_circle),
                            title: Text(PlantDrawerPage.plantDrawerPageAddPlantLabel),
                            onTap: () => _onAddPlant(context)),
                      ],
                    ))))
          ],
        );
      },
    );
  }

  Widget _plantList(BuildContext context) {
    return BlocBuilder<PlantDrawerBloc, PlantDrawerBlocState>(
      buildWhen: (previousState, state) =>
          state is PlantDrawerBlocStateLoadingPlantList || state is PlantDrawerBlocStatePlantListUpdated,
      builder: (BuildContext context, PlantDrawerBlocState state) {
        late Widget content;
        if (state is PlantDrawerBlocStateLoadingPlantList) {
          content = FullscreenLoading(title: CommonL10N.loading);
        } else if (state is PlantDrawerBlocStatePlantListUpdated) {
          List<Plant> plants = state.plants.toList();
          List<Box> boxes = state.boxes;
          content = ListView(
              controller: drawerScrollController,
              key: const PageStorageKey<String>('plants'),
              children: boxes.map((b) {
                List<Widget> content = [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 2))],
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: () {
                        BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToBoxFeedEvent(b));
                      },
                      leading: Container(
                        width: 60,
                        height: 30,
                        child: Row(
                          children: [
                            (widget.selectedBox?.id == b.id)
                                ? Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  )
                                : Icon(Icons.crop_square),
                            SvgPicture.asset('assets/settings/icon_lab.svg'),
                          ],
                        ),
                      ),
                      title: Text(b.name),
                      trailing: InkWell(
                          onTap: () {
                            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsBox(b));
                          },
                          child: Icon(Icons.settings)),
                    ),
                  ),
                ];
                content.addAll(plants.where((p) => p.box == b.id).map((p) {
                  int? nUnseen = 0;
                  try {
                    nUnseen =
                        state.hasPending.where((e) => e.id == p.feed).map<int>((e) => e.nNew).reduce((a, e) => a + e);
                  } catch (e) {}
                  Widget item = Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: ListTile(
                        leading: (widget.selectedPlant?.id == p.id)
                            ? Icon(
                                Icons.check_box,
                                color: Colors.green,
                              )
                            : Icon(Icons.crop_square),
                        trailing: Container(
                            width: 50,
                            height: 30,
                            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                              nUnseen != null && nUnseen > 0 ? _renderBadge(nUnseen) : Container(),
                              InkWell(
                                  onTap: () {
                                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsPlant(p));
                                  },
                                  child: Icon(Icons.settings)),
                            ])),
                        title: Text(p.name),
                        onTap: () => _selectPlant(context, p),
                      ));
                  return item;
                }).toList());
                return Column(
                  children: content,
                );
              }).toList());
        }
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: content,
        );
      },
    );
  }

  Widget _renderBadge(int n) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        child: Text(
          '$n',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _selectPlant(BuildContext context, Plant plant) {
    //ignore: close_sinks
    HomeNavigatorBloc navigatorBloc = BlocProvider.of<HomeNavigatorBloc>(context);
    Navigator.pop(context);
    Timer(Duration(milliseconds: 250), () => navigatorBloc.add(HomeNavigateToPlantFeedEvent(plant)));
  }

  void _onAddPlant(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreatePlantEvent());
  }
}
