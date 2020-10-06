import 'dart:async';

import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/products/products_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/settings/plant_settings.dart';

class RemoteProductsBlocDelegate extends ProductsBlocDelegate {
  final String plantID;

  RemoteProductsBlocDelegate(this.plantID);

  @override
  void loadProducts() async {
    Map<String, dynamic> plant =
        await BackendAPI().feedsAPI.publicPlant(plantID);
    productsLoaded(PlantSettings.fromJSON(plant['settings']),
        BoxSettings.fromJSON(plant['boxSettings']));
  }

  @override
  Stream<ProductsBlocState> updateProducts(List<Product> products) async* {}

  @override
  Future<void> close() async {}
}
