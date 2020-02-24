import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class BoxFeedBlocEvent extends Equatable {}

class BoxFeedBlocEventLoadBox extends BoxFeedBlocEvent {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocEventBoxUpdated extends BoxFeedBlocEvent {
  final Box box;

  BoxFeedBlocEventBoxUpdated(this.box);

  @override
  List<Object> get props => [box];
}

abstract class BoxFeedBlocState extends Equatable {}

abstract class BoxFeedBlocStateBox extends BoxFeedBlocState {
  final Box box;
  final List<charts.Series<LinearSales, int>> graphData;

  BoxFeedBlocStateBox(this.box, this.graphData);
}

class BoxFeedBlocStateInit extends BoxFeedBlocState {
  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateNoBox extends BoxFeedBlocState {
  BoxFeedBlocStateNoBox() : super();

  @override
  List<Object> get props => [];
}

class BoxFeedBlocStateBoxLoaded extends BoxFeedBlocStateBox {
  BoxFeedBlocStateBoxLoaded(Box box, List<charts.Series<LinearSales, int>> graphData) : super(box, graphData);

  @override
  List<Object> get props => [box, graphData];
}

class BoxFeedBloc extends Bloc<BoxFeedBlocEvent, BoxFeedBlocState> {
  final HomeNavigateToBoxFeedEvent _args;
  final List<charts.Series<LinearSales, int>> _graphData = [];

  BoxFeedBloc(this._args) {
    this.add(BoxFeedBlocEventLoadBox());
  }

  @override
  BoxFeedBlocState get initialState => BoxFeedBlocStateInit();

  @override
  Stream<BoxFeedBlocState> mapEventToState(BoxFeedBlocEvent event) async* {
    if (event is BoxFeedBlocEventLoadBox) {
      _graphData.addAll(_createDummyData());

      AppDB _db = AppDB();
      if (event is BoxFeedBlocEventLoadBox) {
        Box box = _args.box;
        if (box == null) {
          AppData appData = _db.getAppData();
          if (appData.lastBoxID == null) {
            yield BoxFeedBlocStateNoBox();
            return;
          }
          box = await RelDB.get().boxesDAO.getBox(appData.lastBoxID);
        } else {
          _db.setLastBox(box.id);
        }
        RelDB.get().boxesDAO.watchBox(box.id).listen(_onBoxUpdated);
      }
    } else if (event is BoxFeedBlocEventBoxUpdated) {
      yield BoxFeedBlocStateBoxLoaded(event.box, _graphData);
    }
  }

  void _onBoxUpdated(Box box) {
    add(BoxFeedBlocEventBoxUpdated(box));
  }

  List<charts.Series<LinearSales, int>> _createDummyData() {
    final tempData = List.generate(
        50,
        (index) => LinearSales(
            index, (cos(index / 100) * 20).toInt() + Random().nextInt(7) + 20));
    final humiData = List.generate(
        50,
        (index) => LinearSales(
            index, (sin(index / 100) * 5).toInt() + Random().nextInt(3) + 20));
    final lightData = List.generate(
        50,
        (index) => LinearSales(
            index, (cos(index / 100) * 10).toInt() + Random().nextInt(5) + 20));

    return [
      charts.Series<LinearSales, int>(
        id: 'Temperature',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: tempData,
      ),
      charts.Series<LinearSales, int>(
        id: 'Humidity',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: humiData,
      ),
      charts.Series<LinearSales, int>(
        id: 'Light',
        strokeWidthPxFn: (_, __) => 3,
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: lightData,
      ),
    ];
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
