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

import 'dart:convert';
import 'dart:math' as math;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class TimeSeriesAPI {
  static List<dynamic> multiplyMetric(List<dynamic> metric, List<int> values) {
    int i = 0;
    return metric
        .map<dynamic>((d) => [
              d[0],
              d[1] *
                  values[i >= values.length ? values.length - 1 : i++]
                      .toDouble() /
                  100.0
            ])
        .toList();
  }

  static List<int> avgMetrics(List<List<dynamic>> metrics) {
    int maxN = 0;
    metrics.forEach((m) {
      maxN = math.max(m.length, maxN);
    });
    List<int> result = List<int>.generate(maxN, (index) {
      int value = 0;
      int n = 0;
      metrics.forEach((m) {
        if (index < m.length) {
          value += m[index][1];
          n += 1;
        }
      });
      return value ~/ n;
    });
    return result;
  }

  static Future<charts.Series<Metric, DateTime>> fetchTimeSeries(Plant plant,
      String controllerID, String graphID, String name, charts.Color color,
      {Function(double) transform}) async {
    List<dynamic> values = await fetchMetric(plant, controllerID, name);
    return toTimeSeries(values, graphID, color, transform: transform);
  }

  static Future<List<dynamic>> fetchMetric(
      Plant plant, String controllerID, String name) async {
    List<dynamic> data;
    ChartCache cache =
        await RelDB.get().plantsDAO.getChartCache(plant.id, name);
    Duration diff = cache?.date?.difference(DateTime.now());
    if (cache == null || -diff.inSeconds >= 30) {
      if (cache != null) {
        await RelDB.get().plantsDAO.deleteChartCacheForPlant(cache.plant);
      }
      Response resp = await get(
          '${BackendAPI().serverHost}/metrics?cid=$controllerID&q=$name&t=72&n=50');
      Map<String, dynamic> res = JsonDecoder().convert(resp.body);
      data = res['metrics'];
      await RelDB.get().plantsDAO.addChartCache(ChartCachesCompanion.insert(
          plant: plant.id,
          name: name,
          date: DateTime.now(),
          values: Value(JsonEncoder().convert(data))));
    } else {
      data = JsonDecoder().convert(cache.values);
    }
    return data;
  }

  static charts.Series<Metric, DateTime> toTimeSeries(
      List<dynamic> values, String graphID, charts.Color color,
      {Function(double) transform}) {
    return charts.Series<Metric, DateTime>(
      id: graphID,
      strokeWidthPxFn: (_, __) => 3,
      colorFn: (_, __) => color,
      domainFn: (Metric metric, _) => metric.time,
      measureFn: (Metric metric, _) => metric.metric,
      data: values.map<Metric>((v) {
        double value = v[1].toDouble();
        if (transform != null) {
          value = transform(value);
        }
        return Metric(
            DateTime.fromMillisecondsSinceEpoch(v[0] * 1000), value.toDouble());
      }).toList(),
    );
  }

  static Metric min(List<Metric> values) {
    return values.reduce((acc, v) => acc.metric < v.metric ? acc : v);
  }

  static Metric max(List<Metric> values) {
    return values.reduce((acc, v) => acc.metric > v.metric ? acc : v);
  }
}

class Metric {
  final DateTime time;
  final double metric;

  Metric(this.time, this.metric);
}
