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
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/products/product/product_type/product_categories.dart';
import 'package:super_green_app/pages/products/search_new_product/select_new_product_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class SelectNewProductPage extends StatefulWidget {
  @override
  _SelectNewProductPageState createState() => _SelectNewProductPageState();
}

class _SelectNewProductPageState extends State<SelectNewProductPage> {
  List<Product> initialProducts = [];
  List<Product> selectedProducts = [];
  List<Product> products = [];
  bool preLoading = false;

  final TextEditingController controller = TextEditingController();
  Timer autocompleteTimer;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectNewProductBloc, SelectNewProductBlocState>(
      listener: (BuildContext context, SelectNewProductBlocState state) async {
        if (state is SelectNewProductBlocStateSelectedProducts) {
          setState(() {
            initialProducts.addAll(state.selectedProducts);
            selectedProducts.addAll(state.selectedProducts);
          });
        } else if (state is SelectNewProductBlocStateLoaded) {
          setState(() {
            products = state.products;
          });
        } else if (state is SelectNewProductBlocStateCreateProductDone) {
          setState(() {
            selectedProducts.add(state.product);
            products = [state.product];
          });
        } else if (state is SelectNewProductBlocStateDone) {
          await Future.delayed(Duration(seconds: 1));
          for (Product product in state.products) {
            for (int i = 0; i < selectedProducts.length; ++i) {
              if (selectedProducts[i].id == product.id) {
                selectedProducts[i] = product;
                break;
              }
            }
          }
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(param: selectedProducts));
        }
      },
      child: BlocBuilder<SelectNewProductBloc, SelectNewProductBlocState>(
        builder: (BuildContext context, SelectNewProductBlocState state) {
          Widget body;
          if (state is SelectNewProductBlocStateCreatingProduct) {
            body = renderCreatingProduct(context);
          } else if (state
              is SelectNewProductBlocStateCreatingProductSuppliers) {
            body = renderCreatingProductSuppliers(context);
          } else if (state is SelectNewProductBlocStateDone) {
            body = renderDone(context);
          } else {
            List<Widget> content = [renderSearchField(context, state)];
            if (products.length == 0 && controller.text == '') {
              content.add(renderNoProducts(context));
            } else {
              List<Product> added =
                  difference(selectedProducts, initialProducts);
              List<Product> removed =
                  difference(initialProducts, selectedProducts);
              content.add(renderProductsList(context, state));
              content.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      '${selectedProducts.length} item${selectedProducts.length > 1 ? 's' : ''}'),
                                  Text(' selected',
                                      style: TextStyle(
                                          color: Color(0xff3bb30b),
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${added.length}'),
                                  Text(' added',
                                      style: TextStyle(
                                          color: Color(0xff3bb30b),
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${removed.length}'),
                                  Text(' removed',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GreenButton(
                        title: 'NEXT',
                        onPressed: selectedProducts.length == 0 &&
                                initialProducts.length == 0
                            ? null
                            : () {
                                List<Product> added = difference(
                                    selectedProducts, initialProducts);
                                if (added.length == 0) {
                                  BlocProvider.of<MainNavigatorBloc>(context)
                                      .add(MainNavigatorActionPop(
                                          param: selectedProducts));
                                  return;
                                }
                                BlocProvider.of<MainNavigatorBloc>(context).add(
                                    MainNavigateToProductSupplierEvent(
                                        added.toList(),
                                        futureFn: (future) async {
                                  List<Product> products = await future;
                                  if (products == null) {
                                    return;
                                  }

                                  BlocProvider.of<SelectNewProductBloc>(context)
                                      .add(
                                          SelectNewProductBlocEventCreateProductSuppliers(
                                              products));
                                }));
                              },
                      ),
                    ],
                  ),
                ),
              );
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

  Widget renderSearchField(
      BuildContext context, SelectNewProductBlocState state) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 24.0, right: 24.0, top: 8, bottom: 16),
      child: Stack(
        children: [
          TextFormField(
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
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
            ),
            style:
                TextStyle(color: Colors.black, decoration: TextDecoration.none),
            controller: controller,
            onChanged: (value) {
              setState(() {
                preLoading = true;
              });
              if (autocompleteTimer != null) {
                autocompleteTimer.cancel();
              }
              autocompleteTimer = Timer(Duration(milliseconds: 500), () {
                BlocProvider.of<SelectNewProductBloc>(context)
                    .add(SelectNewProductBlocEventSearchTerms(value));
                autocompleteTimer = null;
                setState(() {
                  preLoading = false;
                });
              });
            },
          ),
          state is SelectNewProductBlocStateLoading || preLoading
              ? Positioned(
                  right: 5,
                  bottom: 8,
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      )),
                )
              : Container(),
        ],
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

  Widget renderProductsList(
      BuildContext context, SelectNewProductBlocState state) {
    List<Product> added = difference(selectedProducts, initialProducts);
    List<Product> removed = difference(initialProducts, selectedProducts);
    List<Widget> children = products.map<Widget>((p) {
      final ProductCategoryUI categoryUI = productCategories[p.category];
      Color iconColor = Color(0xffececec);
      if (contains(added, p)) {
        iconColor = Color(0xff3bb30b);
      } else if (contains(removed, p)) {
        iconColor = Colors.red;
      } else if (contains(initialProducts, p)) {
        iconColor = Colors.green.shade100;
      }
      return ListTile(
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(FocusNode());
            if (contains(selectedProducts, p)) {
              selectedProducts.removeWhere((sp) => sp.id == p.id);
            } else {
              selectedProducts.add(p);
            }
          });
        },
        leading: SvgPicture.asset(categoryUI.icon),
        title: Text(categoryUI.name),
        subtitle: Text(p.name, style: TextStyle(fontSize: 20)),
        trailing: Icon(Icons.add_box, size: 30, color: iconColor),
      );
    }).toList();

    if (products.length == 0) {
      children.add(ListTile(
          title: Text(state is SelectNewProductBlocStateLoading || preLoading
              ? 'Searching..'
              : 'No search results for "${controller.text}"')));
    }
    children.add(Container(
      color: Color(0xffececec),
      height: 1,
    ));
    children.add(ListTile(
      trailing: Icon(Icons.note_add, size: 30),
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

  Widget renderCreatingProductSuppliers(BuildContext context) {
    return FullscreenLoading(
      title: 'Adding links',
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

  bool contains(List<Product> l, Product p) =>
      l.firstWhere((a) => a.id == p.id, orElse: () => null) != null;

  List<Product> difference(List<Product> l1, List<Product> l2) {
    List<Product> diff = [];
    for (Product p in l1) {
      if (!contains(l2, p)) {
        diff.add(p);
      }
    }
    return diff;
  }
}
