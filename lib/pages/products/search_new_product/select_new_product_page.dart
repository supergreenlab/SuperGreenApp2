import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/products/products_bloc.dart';
import 'package:super_green_app/pages/products/search_new_product/select_new_product_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

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
      listener: (BuildContext context, SelectNewProductBlocState state) {
        if (state is SelectNewProductBlocStateLoaded) {
          products = state.products;
        }
      },
      child: BlocBuilder<SelectNewProductBloc, SelectNewProductBlocState>(
        builder: (BuildContext context, SelectNewProductBlocState state) {
          List<Widget> content = [renderSearchField(context)];
          if (products.length == 0 && controller.text == '') {
            content.add(renderNoProducts(context));
          } else {
            content.add(renderProductsList(context));
          }
          Widget body = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: content);
          return Scaffold(
              appBar: SGLAppBar(
                '🛠',
                fontSize: 40,
                backgroundColor: Color(0xff0EA9DA),
                titleColor: Colors.white,
                iconColor: Colors.white,
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
                    width: 100, height: 100),
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
      children
          .add(ListTile(title: Text('No search results for "${controller.text}"')));
    }
    children.add(ListTile(
      leading: Icon(Icons.add, size: 50),
      title: Text('Not found?'),
      subtitle: Text('Create new toolbox item',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
      onTap: () {
        print("tap");
      },
    ));
    return Expanded(
      child: ListView(
        children: children,
      ),
    );
  }
}
