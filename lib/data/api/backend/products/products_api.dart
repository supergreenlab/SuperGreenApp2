class ProductsAPI {
  static final ProductsAPI _instance = ProductsAPI._newInstance();

  factory ProductsAPI() => _instance;

  ProductsAPI._newInstance();

  Future createProduct(String name, String url) async {}
}
