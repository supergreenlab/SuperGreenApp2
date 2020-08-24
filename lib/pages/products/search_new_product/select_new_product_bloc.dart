import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/products/products_bloc.dart';

abstract class SelectNewProductBlocEvent extends Equatable {}

class SelectNewProductBlocEventSearchTerms extends SelectNewProductBlocEvent {
  final String searchTerms;

  SelectNewProductBlocEventSearchTerms(this.searchTerms);

  @override
  List<Object> get props => [searchTerms];
}

abstract class SelectNewProductBlocState extends Equatable {}

class SelectNewProductBlocStateInit extends SelectNewProductBlocState {
  @override
  List<Object> get props => [];
}

class SelectNewProductBlocStateLoaded extends SelectNewProductBlocState {
  final List<Product> products;

  SelectNewProductBlocStateLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class SelectNewProductBloc
    extends Bloc<SelectNewProductBlocEvent, SelectNewProductBlocState> {
  final MainNavigateToSelectNewProductEvent args;

  SelectNewProductBloc(this.args) : super(SelectNewProductBlocStateInit());

  @override
  Stream<SelectNewProductBlocState> mapEventToState(
      SelectNewProductBlocEvent event) async* {
    if (event is SelectNewProductBlocEventSearchTerms) {}
  }
}
