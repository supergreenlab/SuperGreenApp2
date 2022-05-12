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
  String search = '';
  final TextEditingController searchController = TextEditingController();
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
              ])),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: _renderSearchField(context),
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
          List<Plant> plants = state.plants.where((p) {
            if (search == '') return true;
            Box box = state.boxes.firstWhere((b) => b.id == p.box);
            return box.name.toLowerCase().indexOf(search) != -1 ||
                p.name.toLowerCase().indexOf(search) != -1 ||
                p.settings.toLowerCase().indexOf(search) != -1;
          }).toList();
          List<Box> boxes = state.boxes;
          content = MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView(
                controller: drawerScrollController,
                key: const PageStorageKey<String>('plants'),
                children: boxes.where((b) => plants.where((p) => p.box == b.id).length != 0).map((b) {
                  // TODO make this like the dashboard
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
                }).toList()),
          );
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

  Widget _renderSearchField(BuildContext context) {
    // TODO DRY with dashboard and explorer
    Widget trailing;
    if (searchController.text == '') {
      trailing = SvgPicture.asset('assets/explorer/icon_search.svg');
    } else {
      trailing = InkWell(
        child: Icon(Icons.clear),
        onTap: () {
          setState(() {
            searchController.text = '';
          });
        },
      );
    }
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xffe9e9e9),
        border: Border.all(width: 1, color: Color(0xffd8d8d8)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: [
          Expanded(
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),
          trailing,
        ]),
      ),
    );
  }
}
