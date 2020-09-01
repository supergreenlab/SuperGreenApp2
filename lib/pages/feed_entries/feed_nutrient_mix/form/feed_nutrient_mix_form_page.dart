/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_nutrient_mix.dart';
import 'package:super_green_app/pages/feed_entries/feed_nutrient_mix/form/feed_nutrient_mix_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/feed_form/number_form_param.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedNutrientMixFormPage extends StatefulWidget {
  @override
  _FeedNutrientMixFormPageState createState() =>
      _FeedNutrientMixFormPageState();
}

class _FeedNutrientMixFormPageState extends State<FeedNutrientMixFormPage> {
  List<NutrientProduct> nutrientProducts = [];

  double volume = 10;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<FeedNutrientMixFormBloc>(context),
      listener: (BuildContext context, FeedNutrientMixFormBlocState state) {
        if (state is FeedNutrientMixFormBlocStateLoaded) {
          setState(() {
            for (Product product in state.products) {
              if (nutrientProducts.singleWhere(
                      (pi) => pi.product.id == product.id,
                      orElse: () => null) ==
                  null) {
                nutrientProducts.add(
                    NutrientProduct(product: product, quantity: 0, unit: 'g'));
              }
            }
          });
        } else if (state is FeedNutrientMixFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<FeedNutrientMixFormBloc, FeedNutrientMixFormBlocState>(
          cubit: BlocProvider.of<FeedNutrientMixFormBloc>(context),
          builder: (BuildContext context, FeedNutrientMixFormBlocState state) {
            Widget body;
            bool changed = false;
            bool valid = true;
            if (state is FeedNutrientMixFormBlocStateLoading) {
              body = FullscreenLoading(
                title: 'Saving..',
              );
            } else if (state is FeedNutrientMixFormBlocStateInit) {
              body = FullscreenLoading(
                title: 'Loading..',
              );
            } else if (state is FeedNutrientMixFormBlocStateLoaded) {
              body = renderBody(context, state);
            }
            return FeedFormLayout(
                title: '🧪',
                changed: changed,
                valid: valid,
                onOK: () => BlocProvider.of<FeedNutrientMixFormBloc>(context)
                    .add(FeedNutrientMixFormBlocEventCreate(nutrientProducts)),
                body: AnimatedSwitcher(
                  child: body,
                  duration: Duration(milliseconds: 200),
                ));
          }),
    );
  }

  Widget renderBody(
      BuildContext context, FeedNutrientMixFormBlocStateLoaded state) {
    bool freedomUnits = AppDB().getAppData().freedomUnits == true;
    List<Widget> children = [
      NumberFormParam(
        icon: 'assets/feed_form/icon_volume.svg',
        title: 'Water quantity',
        value: volume,
        step: 1,
        displayMultiplier: freedomUnits ? 0.25 : 1,
        unit: freedomUnits ? ' gal' : ' L',
        onChange: (newValue) {
          setState(() {
            if (newValue > 0) {
              volume = newValue;
            }
          });
        },
      ),
    ];
    int i = 0;
    for (NutrientProduct productIntake in nutrientProducts) {
      children.add(FeedFormParamLayout(
          child: renderFertilizer(context, productIntake,
              (NutrientProduct newProductIntake) {
            setState(() {
              nutrientProducts[i] = newProductIntake;
            });
          }),
          icon: 'assets/products/toolbox/icon_fertilizer.svg',
          title: productIntake.product.name));
      ++i;
    }
    return ListView(
      children: children,
    );
  }

  Widget renderFertilizer(BuildContext context, NutrientProduct productIntake,
      Function(NutrientProduct) onChange) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Switch(
            onChanged: (bool value) {},
            value: true,
          ),
        ],
      ),
    );
  }
}
