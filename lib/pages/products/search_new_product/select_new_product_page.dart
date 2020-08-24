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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/products/products_bloc.dart';
import 'package:super_green_app/pages/products/search_new_product/select_new_product_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class SelectNewProductPage extends StatefulWidget {
  @override
  _SelectNewProductPageState createState() => _SelectNewProductPageState();
}

class _SelectNewProductPageState extends State<SelectNewProductPage> {
  List<Product> products = [];

  final TextEditingController controller = TextEditingController();
  Timer autocompleteTimer;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectNewProductBloc, SelectNewProductBlocState>(
      listener: (BuildContext context, SelectNewProductBlocState state) async {
        if (state is SelectNewProductBlocStateLoaded) {
          products = state.products;
        } else if (state is SelectNewProductBlocStateDone) {
          await Future.delayed(Duration(seconds: 1));
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<SelectNewProductBloc, SelectNewProductBlocState>(
        builder: (BuildContext context, SelectNewProductBlocState state) {
          Widget body;
          if (state is SelectNewProductBlocStateCreatingProduct) {
            body = renderCreatingProduct(context);
          } else if (state is SelectNewProductBlocStateDone) {
            body = renderDone(context);
          } else {
            List<Widget> content = [renderSearchField(context)];
            if (products.length == 0 && controller.text == '') {
              content.add(renderNoProducts(context));
            } else {
              content.add(renderProductsList(context));
            }
            body = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: content);
          }
          return Scaffold(
              appBar: SGLAppBar(
                '🛠',
                fontSize: 40,
                backgroundColor: Color(0xff0EA9DA),
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton:
                    state is SelectNewProductBlocStateCreatingProduct,
              ),
              backgroundColor: Colors.white,
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  Widget renderSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          hintText: 'Ex: BioBizz',
          hintStyle: TextStyle(color: Colors.black38),
          labelText: 'Item search',
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
        controller: controller,
        onChanged: (value) {
          setState(() {});
          if (autocompleteTimer != null) {
            autocompleteTimer.cancel();
          }
          autocompleteTimer = Timer(Duration(milliseconds: 500), () {
            BlocProvider.of<SelectNewProductBloc>(context)
                .add(SelectNewProductBlocEventSearchTerms(value));
            autocompleteTimer = null;
          });
        },
      ),
    );
  }

  Widget renderNoProducts(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/products/toolbox/toolbox.svg',
                    width: 90, height: 90),
              ),
              Text('Search or create\ntoolbox item',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffDFDFDF),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ],
          )),
        ],
      ),
    );
  }

  Widget renderProductsList(BuildContext context) {
    List<Widget> children = products.map((p) {
      return ListTile(
        title: Text('pouet'),
      );
    }).toList();
    if (products.length == 0) {
      children.add(
          ListTile(title: Text('No search results for "${controller.text}"')));
    }
    children.add(ListTile(
      leading: Icon(Icons.add, size: 50),
      title: Text('Not found?'),
      subtitle: Text('Create new toolbox item',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
      onTap: () {
        BlocProvider.of<MainNavigatorBloc>(context)
            .add(MainNavigateToProductTypeEvent(futureFn: (future) async {
          Product product = await future;
          if (product != null) {
            BlocProvider.of<SelectNewProductBloc>(context)
                .add(SelectNewProductBlocEventCreateProduct(product));
          }
        }));
      },
    ));
    return Expanded(
      child: ListView(
        children: children,
      ),
    );
  }

  Widget renderCreatingProduct(BuildContext context) {
    return FullscreenLoading(
      title: 'Creating toolbox item',
    );
  }

  Widget renderDone(BuildContext context) {
    return Fullscreen(
      title: 'Done',
      child: Icon(
        Icons.check,
        color: Color(0xff3bb30b),
        size: 100,
      ),
    );
  }
}
