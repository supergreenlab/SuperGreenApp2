/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/api/backend/products/specs/seed_specs.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_tab.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_title.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/forms/plant_infos_dimensions.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/forms/plant_infos_medium.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/forms/plant_infos_phase_since.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/forms/plant_infos_plant_type.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/forms/plant_infos_strain.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/widgets/plant_infos_widget.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class PlantInfosPage<PlantInfosBloc> extends TraceableStatefulWidget {
  PlantInfosPage({Key? key}) : super(key: key);

  @override
  _PlantInfosPageState createState() => _PlantInfosPageState();
}

class _PlantInfosPageState extends State<PlantInfosPage> {
  String? form;
  late ScrollController infosScrollController;

  @override
  void initState() {
    infosScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantInfosBloc, PlantInfosBlocState>(
        bloc: BlocProvider.of<PlantInfosBloc>(context),
        builder: (BuildContext context, PlantInfosBlocState state) {
          Widget body = Container();
          if (state is PlantInfosBlocStateLoading) {
            body = _renderLoading(context, state);
          } else {
            if (form == null) {
              body = _renderLoaded(context, state as PlantInfosBlocStateLoaded);
            } else {
              body = Stack(
                children: <Widget>[
                  _renderLoaded(context, state as PlantInfosBlocStateLoaded),
                  _renderForm(context, state),
                ],
              );
            }
          }
          return AppBarTab(
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      AppBarTitle(title: 'Infos', showDate: false),
                      Expanded(child: body),
                    ],
                  )));
        });
  }

  Widget _renderLoading(BuildContext context, PlantInfosBlocStateLoading state) {
    return FullscreenLoading(
      title: "Loading plant data",
    );
  }

  Widget _renderLoaded(BuildContext context, PlantInfosBlocStateLoaded state) {
    String? strain;
    double strainHeight = 65;

    if (state.plantInfos.plantSettings?.strain != null && state.plantInfos.plantSettings?.seedbank != null) {
      strain =
          '# ${state.plantInfos.plantSettings!.strain}\nfrom **${state.plantInfos.plantSettings!.seedbank!.trim()}**';
      strainHeight = 85;
    } else if (state.plantInfos.plantSettings?.strain != null) {
      strain = '# ${state.plantInfos.plantSettings!.strain}';
    }

    String format = AppDB().getUserSettings().freedomUnits! ? 'MM/dd/yyyy' : 'dd/MM/yyyy';

    String? dimensions;
    if (state.plantInfos.boxSettings?.width != null &&
        state.plantInfos.boxSettings?.height != null &&
        state.plantInfos.boxSettings?.depth != null) {
      dimensions =
          '${state.plantInfos.boxSettings!.width}x${state.plantInfos.boxSettings!.height}x${state.plantInfos.boxSettings!.depth} ${state.plantInfos.boxSettings!.unit}';
    }

    return ListView(controller: infosScrollController, key: const PageStorageKey<String>('infos'), children: [
      PlantInfosWidget(
          color: Color(0xFFBA9650),
          icon: 'assets/plant_infos/icon_seed.svg',
          title: 'Strain name',
          value: strain,
          height: strainHeight,
          onEdit: state.plantInfos.editable == false
              ? null
              : () {
                  BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSelectNewProductEvent([],
                      categoryID: ProductCategoryID.SEED, futureFn: (future) async {
                    List<Product>? products = await future;
                    if (products == null || products.length == 0) {
                      return;
                    }
                    SeedSpecs specs = products[0].specs as SeedSpecs;
                    updatePlantSettings(
                        context,
                        state,
                        state.plantInfos.plantSettings!.copyWith(
                            products: state.plantInfos.plantSettings!.products!..add(products[0]),
                            strain: products[0].name,
                            seedbank: specs.bank));
                  }));
                }),
      PlantInfosWidget(
          color: Color(0xFF5F5F5F),
          icon: 'assets/plant_infos/icon_plant_type.svg',
          title: 'Plant type',
          value: state.plantInfos.plantSettings!.plantType,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('PLANT_TYPE')),
      PlantInfosWidget(
          color: Color(0xFF51220E),
          icon: 'assets/plant_infos/icon_medium.svg',
          title: 'Medium',
          value: state.plantInfos.plantSettings!.medium,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('MEDIUM')),
      PlantInfosWidget(
          color: Color(0xFF20BBDD),
          icon: 'assets/plant_infos/icon_dimension.svg',
          title: 'Lab dimensions',
          value: dimensions,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('DIMENSIONS')),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Text('Life event dates',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF494949))),
      ),
      PlantInfosWidget(
          color: Color.fromARGB(255, 45, 117, 17),
          icon: FeedEntryIcons[FE_LIFE_EVENT]!,
          title: 'Cloning',
          value: state.plantInfos.plantSettings!.cloningDate != null
              ? DateFormat(format).format(state.plantInfos.plantSettings!.cloningDate!)
              : null,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('CLONING_DATE')),
      PlantInfosWidget(
          color: Color(0xFF3BB30B),
          icon: FeedEntryIcons[FE_LIFE_EVENT]!,
          title: 'Germination',
          value: state.plantInfos.plantSettings!.germinationDate != null
              ? DateFormat(format).format(state.plantInfos.plantSettings!.germinationDate!)
              : null,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('GERMINATION_DATE')),
      PlantInfosWidget(
          color: Color(0xFFFAC13C),
          icon: 'assets/plant_infos/icon_vegging_since.svg',
          title: 'Vegging',
          value: state.plantInfos.plantSettings!.veggingStart != null
              ? DateFormat(format).format(state.plantInfos.plantSettings!.veggingStart!)
              : null,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('VEGGING_START')),
      PlantInfosWidget(
          color: Color(0xFFE859DA),
          icon: 'assets/plant_infos/icon_blooming_since.svg',
          title: 'Blooming',
          value: state.plantInfos.plantSettings!.bloomingStart != null
              ? DateFormat(format).format(state.plantInfos.plantSettings!.bloomingStart!)
              : null,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('BLOOMING_START')),
      PlantInfosWidget(
          color: Color(0xFF7E7CE3),
          icon: 'assets/plant_infos/icon_drying_since.svg',
          title: 'Drying',
          value: state.plantInfos.plantSettings!.dryingStart != null
              ? DateFormat(format).format(state.plantInfos.plantSettings!.dryingStart!)
              : null,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('DRYING_START')),
      PlantInfosWidget(
          color: Color(0xFFD93483),
          icon: 'assets/plant_infos/icon_curing_since.svg',
          title: 'Curing',
          value: state.plantInfos.plantSettings!.curingStart != null
              ? DateFormat(format).format(state.plantInfos.plantSettings!.curingStart!)
              : null,
          onEdit: state.plantInfos.editable == false ? null : () => _openForm('CURING_START')),
    ]);
  }

  Widget _renderPicture(BuildContext context, PlantInfosBlocStateLoaded state) {
    return SizedBox(
        height: 100,
        child: state.plantInfos.thumbnailPath!.startsWith("http")
            ? Image.network(
                state.plantInfos.thumbnailPath!,
                headers: {'Host': BackendAPI().storageServerHostHeader},
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return FullscreenLoading(
                      percent: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!);
                },
              )
            : Image.file(File(state.plantInfos.thumbnailPath!), fit: BoxFit.fill));
  }

  Widget _renderForm(BuildContext context, PlantInfosBlocStateLoaded state) {
    final forms = {
      'STRAIN': () => PlantInfosStrain(
            strain: state.plantInfos.plantSettings!.strain,
            seedbank: state.plantInfos.plantSettings!.seedbank,
            onCancel: () => _openForm(null),
            onSubmit: (String? strain, String? seedbank) => updatePlantSettings(
                context, state, state.plantInfos.plantSettings!.copyWith(strain: strain, seedbank: seedbank)),
          ),
      'PLANT_TYPE': () => PlantInfosPlantType(
            plantType: state.plantInfos.plantSettings!.plantType,
            onCancel: () => _openForm(null),
            onSubmit: (String? plantType) =>
                updatePlantSettings(context, state, state.plantInfos.plantSettings!.copyWith(plantType: plantType)),
          ),
      'CLONING_DATE': () => PlantInfosPhaseSince(
          title: 'Cloning date',
          icon: 'icon_cloning_date.svg',
          date: state.plantInfos.plantSettings!.cloningDate,
          onCancel: () => _openForm(null),
          onSubmit: (DateTime date) {
            updatePhase(context, PlantPhases.CLONING, date);
          }),
      'GERMINATION_DATE': () => PlantInfosPhaseSince(
          title: 'Germination date',
          icon: 'icon_germination_date.svg',
          date: state.plantInfos.plantSettings!.germinationDate,
          onCancel: () => _openForm(null),
          onSubmit: (DateTime date) {
            updatePhase(context, PlantPhases.GERMINATING, date);
          }),
      'VEGGING_START': () => PlantInfosPhaseSince(
          title: 'Vegging started at',
          icon: 'icon_vegging_since.svg',
          date: state.plantInfos.plantSettings!.veggingStart,
          onCancel: () => _openForm(null),
          onSubmit: (DateTime date) {
            updatePhase(context, PlantPhases.VEGGING, date);
          }),
      'BLOOMING_START': () => PlantInfosPhaseSince(
          title: 'Blooming started at',
          icon: 'icon_blooming_since.svg',
          date: state.plantInfos.plantSettings!.bloomingStart,
          onCancel: () => _openForm(null),
          onSubmit: (DateTime date) {
            updatePhase(context, PlantPhases.BLOOMING, date);
          }),
      'DRYING_START': () => PlantInfosPhaseSince(
          title: 'Drying started at',
          icon: 'icon_drying_since.svg',
          date: state.plantInfos.plantSettings!.dryingStart,
          onCancel: () => _openForm(null),
          onSubmit: (DateTime date) {
            updatePhase(context, PlantPhases.DRYING, date);
          }),
      'CURING_START': () => PlantInfosPhaseSince(
          title: 'Curing started at',
          icon: 'icon_curing_since.svg',
          date: state.plantInfos.plantSettings!.curingStart,
          onCancel: () => _openForm(null),
          onSubmit: (DateTime date) {
            updatePhase(context, PlantPhases.CURING, date);
            updatePlantSettings(context, state, state.plantInfos.plantSettings!.copyWith(curingStart: date));
          }),
      'MEDIUM': () => PlantInfosMedium(
            medium: state.plantInfos.plantSettings!.medium,
            onCancel: () => _openForm(null),
            onSubmit: (String? medium) =>
                updatePlantSettings(context, state, state.plantInfos.plantSettings!.copyWith(medium: medium)),
          ),
      'DIMENSIONS': () => PlantInfosDimensions(
            width: state.plantInfos.boxSettings!.width,
            height: state.plantInfos.boxSettings!.height,
            depth: state.plantInfos.boxSettings!.depth,
            onCancel: () => _openForm(null),
            onSubmit: (int width, int height, int depth, String unit) => updateBoxSettings(context, state,
                state.plantInfos.boxSettings!.copyWith(width: width, height: height, depth: depth, unit: unit)),
          ),
    };
    return Container(
      color: Colors.white.withAlpha(127),
      child: Column(
        children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xff063047),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Colors.white)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: forms[form]!(),
                )),
          )),
        ],
      ),
    );
  }

  void _openForm(String? form) {
    setState(() {
      this.form = form;
    });
  }

  void updatePlantSettings(BuildContext context, PlantInfosBlocStateLoaded state, PlantSettings settings) {
    updatePlantInfos(
        context,
        state.plantInfos.copyWith(
          plantSettings: settings,
        ));
  }

  void updateBoxSettings(BuildContext context, PlantInfosBlocStateLoaded state, BoxSettings settings) {
    updatePlantInfos(
        context,
        state.plantInfos.copyWith(
          boxSettings: settings,
        ));
  }

  void updatePhase(BuildContext context, PlantPhases phase, DateTime date) {
    BlocProvider.of<PlantInfosBloc>(context).add(PlantInfosEventUpdatePhase(phase, date));
    _openForm(null);
  }

  void updatePlantInfos(BuildContext context, PlantInfos plantInfos) {
    BlocProvider.of<PlantInfosBloc>(context).add(PlantInfosEventUpdate(plantInfos));
    _openForm(null);
  }
}
