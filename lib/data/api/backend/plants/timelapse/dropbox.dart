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

import 'package:super_green_app/data/api/backend/plants/timelapse/timelapse_settings.dart';

class DropboxSettings extends TimelapseSettings {
  final String? ssid;
  final String? password;
  final String? controllerID;
  final String? rotate;
  final String? name;
  final String? strain;
  final String? dropboxToken;
  final String? uploadName;

  DropboxSettings(
      {this.ssid,
      this.password,
      this.controllerID,
      this.rotate,
      this.name,
      this.strain,
      this.dropboxToken,
      this.uploadName});

  @override
  List<Object?> get props => [
        ssid,
        password,
        controllerID,
        rotate,
        name,
        strain,
        dropboxToken,
        uploadName,
      ];

  factory DropboxSettings.fromMap(Map<String, dynamic> map) {
    return DropboxSettings(
      ssid: map['ssid'],
      password: map['password'],
      controllerID: map['controllerID'],
      rotate: map['rotate'],
      name: map['name'],
      strain: map['strain'],
      dropboxToken: map['dropboxToken'],
      uploadName: map['uploadName'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ssid': this.ssid,
      'password': this.password,
      'controllerID': this.controllerID,
      'rotate': this.rotate,
      'name': this.name,
      'strain': this.strain,
      'dropboxToken': this.dropboxToken,
      'uploadName': this.uploadName,
    };
  }
}
