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

import 'dart:convert';
import 'dart:math' as math;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart';
import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class TimeSeriesAPI {
  static List<dynamic> multiplyMetric(List<dynamic> metric, List<int> values) {
    if (metric.length == 0 || values.length == 0) {
      return [];
    }
    int i = 0;
    return metric
        .map<dynamic>((d) => [d[0], d[1] * values[i >= values.length ? values.length - 1 : i++].toDouble() / 100.0])
        .toList();
  }

  static List<int> avgMetrics(List<List<dynamic>> metrics) {
    int maxN = 0;
    metrics.forEach((m) {
      maxN = math.max(m.length, maxN);
    });
    if (maxN == 0) {
      return [];
    }
    List<int> result = List<int>.generate(maxN, (index) {
      int value = 0;
      int n = 0;
      metrics.forEach((m) {
        if (index < m.length) {
          value += m[index][1] as int;
          n += 1;
        }
      });
      if (n == 0) {
        return 0;
      }
      return value ~/ n;
    });
    return result;
  }

  static Future<charts.Series<Metric, DateTime>> fetchTimeSeries(
      Box box, String controllerID, String graphID, String name, charts.Color color, int min, int max,
      {Function(double, int)? transform}) async {
    List<dynamic> values = await fetchMetric(box, controllerID, name, min, max);
    if (values.where((v) => v[1] != 0).length == 0) {
      values = [];
    }
    return toTimeSeries(values, graphID, color, transform: transform);
  }

  static Future<List<dynamic>> fetchMetric(Box box, String controllerID, String name, int min, int max,) async {
    List<dynamic> data;
    ChartCache? cache = await RelDB.get().plantsDAO.getChartCache(box.id, name);
    if (cache == null || -(cache.date.difference(DateTime.now()).inSeconds) >= 30) {
      if (cache != null) {
        await RelDB.get().plantsDAO.deleteChartCacheForBox(cache.box);
      }
      Response resp = await get(Uri.parse('${BackendAPI().serverHost}/metrics?cid=$controllerID&q=$name&t=72&n=50&min=$min&max=$max'));
      Map<String, dynamic> res = JsonDecoder().convert(resp.body);
      data = res['metrics'];
      await RelDB.get().plantsDAO.addChartCache(ChartCachesCompanion.insert(
          box: box.id, name: name, date: DateTime.now(), values: Value(JsonEncoder().convert(data))));
    } else {
      data = JsonDecoder().convert(cache.values);
    }
    return data;
  }

  static charts.Series<Metric, DateTime> toTimeSeries(List<dynamic> values, String graphID, charts.Color color,
      {Function(double, int)? transform}) {
    return charts.Series<Metric, DateTime>(
      id: graphID,
      strokeWidthPxFn: (_, __) => 3,
      colorFn: (_, __) => color,
      domainFn: (Metric metric, _) => metric.time,
      measureFn: (Metric metric, _) => metric.metric,
      data: values.asMap().map<int, Metric>((i, v) {
        double value = v[1].toDouble();
        if (transform != null) {
          value = transform(value, i);
        }
        return MapEntry(i, Metric(DateTime.fromMillisecondsSinceEpoch(v[0] * 1000), value.toDouble()));
      }).values.toList(),
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
