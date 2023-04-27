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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/products/products_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_tab.dart';
import 'package:super_green_app/pages/products/product/product_category/product_categories.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsPage extends TraceableStatefulWidget {
  static String get productsPageLoadingPlantData {
    return Intl.message(
      'Loading plant data',
      name: 'productsPageLoadingPlantData',
      desc: 'Products page loading plant data',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get productsPageTitle {
    return Intl.message(
      'Toolbox',
      name: 'productsPageTitle',
      desc: 'Products page title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get productsPageToolboxEmptyOwnPlant {
    return Intl.message(
      'Toolbox is empty\nuse the “+” above to add your first item.',
      name: 'productsPageToolboxEmptyOwnPlant',
      desc: 'Products page empty toolbox message when looking at own plant',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get productsPageToolboxEmpty {
    return Intl.message(
      'Toolbox is empty',
      name: 'productsPageToolboxEmpty',
      desc: 'Products page empty toolbox message when looking at another plant',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get productsPageToolboxInstructions {
    return Intl.message(
      'List the items you used for this grow for future reference and/or kowledge sharing.',
      name: 'productsPageToolboxInstructions',
      desc: 'Products toolbox instructions',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get productsPageToolboxBy {
    return Intl.message(
      'by ',
      name: 'productsPageToolboxBy',
      desc: 'Products toolbox "by " prefix for brand name',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final bool editable;

  const ProductsPage({Key? key, this.editable = true}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late List<Product> products;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsBlocState>(
      listener: (BuildContext context, ProductsBlocState state) {
        if (state is ProductsBlocStateLoaded) {
          setState(() {
            products = state.products;
          });
        }
      },
      child: BlocBuilder<ProductsBloc, ProductsBlocState>(
          bloc: BlocProvider.of<ProductsBloc>(context),
          builder: (BuildContext context, ProductsBlocState state) {
            if (state is ProductsBlocStateLoading) {
              return AppBarTab(child: _renderLoading(context, state));
            }
            return AppBarTab(child: _renderLoaded(context, state as ProductsBlocStateLoaded));
          }),
    );
  }

  Widget _renderLoading(BuildContext context, ProductsBlocStateLoading state) {
    return FullscreenLoading(
      title: ProductsPage.productsPageLoadingPlantData,
    );
  }

  Widget _renderLoaded(BuildContext context, ProductsBlocStateLoaded state) {
    List<Widget> topBar = [
      Text(
        ProductsPage.productsPageTitle,
        style: TextStyle(color: Color(0xFF494949), fontSize: 20),
      ),
    ];
    if (widget.editable) {
      topBar.addAll([
        Expanded(
          child: Container(),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Color(0xFF494949),
            size: 40,
          ),
          onPressed: () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToSelectNewProductEvent(products, futureFn: (future) async {
              List<Product>? products = await future;
              if (products == null) {
                return;
              }
              BlocProvider.of<ProductsBloc>(context).add(ProductsBlocEventUpdate(products));
            }));
          },
        ),
      ]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: topBar,
        ),
        Container(
          height: 1,
          color: Color(0xFF494949),
        ),
        state.products.length == 0 ? _renderEmptyList(context) : _renderList(context, state),
      ]),
    );
  }

  Widget _renderEmptyList(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: Text(
                widget.editable ? ProductsPage.productsPageToolboxEmptyOwnPlant : ProductsPage.productsPageToolboxEmpty,
                style: TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SvgPicture.asset('assets/products/toolbox/toolbox.svg'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(ProductsPage.productsPageToolboxInstructions, style: TextStyle(color: Color(0xFF494949))),
                ),
              ),
            ]),
          ],
        )),
      ],
    );
  }

  Widget _renderList(BuildContext context, ProductsBlocStateLoaded state) {
    return Expanded(
      child: ListView(
        children: state.products.map<Widget>((p) {
          final ProductCategoryUI categoryUI = productCategories[p.category]!;
          List<Widget> subtitle = [Text(p.name, style: TextStyle(fontSize: 20, color: Color(0xFF494949)))];
          if (p.specs?.by != null) {
            subtitle.addAll([
              Row(children: [
                Text(ProductsPage.productsPageToolboxBy, style: TextStyle(color: Color(0xFF494949))),
                Text(p.specs!.by!, style: TextStyle(color: Color(0xff3bb30b))),
              ])
            ]);
          }
          return ListTile(
            leading: SvgPicture.asset(categoryUI.icon),
            title: Text(categoryUI.name, style: TextStyle(color: Color(0xFF494949))),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: subtitle),
            trailing: p.supplier?.url != null
                ? InkWell(
                    child: Icon(
                      Icons.open_in_browser,
                      color: Color(0xFF494949),
                      size: 30,
                    ),
                    onTap: () {
                      launchUrl(Uri.dataFromString(p.supplier!.url));
                    },
                  )
                : null,
          );
        }).toList(),
      ),
    );
  }
}
