import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/products/products_bloc.dart';

class LocalProductsBlocDelegate extends ProductsBlocDelegate {
  @override
  Future<void> close() async {}

  @override
  void loadProducts() {
    add(ProductsBlocEventLoaded([]));
  }

  @override
  Stream<ProductsBlocState> updateProducts(List<Product> products) async* {}
}
