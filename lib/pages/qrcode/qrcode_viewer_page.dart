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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/pages/qrcode/qrcode_viewer_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class QRCodeViewerPage extends TraceableStatefulWidget {
  @override
  _QRCodeViewerPageState createState() => _QRCodeViewerPageState();
}

class _QRCodeViewerPageState extends State<QRCodeViewerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRCodeViewerBloc, QRCodeViewerBlocState>(
        bloc: BlocProvider.of<QRCodeViewerBloc>(context),
        builder: (BuildContext context, QRCodeViewerBlocState state) {
          Widget body;
          if (state is QRCodeViewerBlocStateLoaded) {
            body = _renderBody(context, state);
          } else {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          }
          return Scaffold(
              appBar: SGLAppBar(
                'QR Code',
                backgroundColor: Color(0xff063047),
                titleColor: Colors.white,
                iconColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: body);
        });
  }

  Widget _renderBody(BuildContext context, QRCodeViewerBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.plant.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'in ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${state.box.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: QrImage(
            data: "sglapp://supergreenlab.com/plant?id=${state.plant.serverID ?? state.plant.id}",
            version: QrVersions.auto,
            size: 250.0,
          ),
        ),
        Center(
          child: Text(
            '1. Screenshot this page\n2. Print this QR code\n3. Scan with your mobile phone camera\nto open the SGL app.${state.plant.serverID == null ? '\n\nCreate a SGL account to make\nthis QR code universal across devices.' : ''}',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
