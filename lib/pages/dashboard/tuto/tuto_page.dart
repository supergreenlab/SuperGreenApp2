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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/dashboard/tuto/tuto_bloc.dart';
import 'package:super_green_app/pages/dashboard/tuto/tuto_item.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class TutoPage extends StatefulWidget {
  @override
  State<TutoPage> createState() => _TutoPageState();
}

class _TutoPageState extends State<TutoPage> {
  String search = '';
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TutoBloc, TutoBlocState>(
      listener: (BuildContext context, TutoBlocState state) {
        if (state is TutoBlocStateLoaded) {}
      },
      child: BlocBuilder<TutoBloc, TutoBlocState>(
          bloc: BlocProvider.of<TutoBloc>(context),
          builder: (context, state) {
            Widget body = _renderLoading(context, state);
            if (state is TutoBlocStateLoaded) {
              body = _renderLoaded(context, state);
            }
            return Container(
              child: body,
            );
          }),
    );
  }

  Widget _renderLoading(BuildContext context, TutoBlocState state) {
    return FullscreenLoading();
  }

  Widget _renderLoaded(BuildContext context, TutoBlocStateLoaded state) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text("Welcome to", style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 30,
              )),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: SvgPicture.asset('assets/tutos/logo-tuto.svg', fit: BoxFit.contain,
                  width: 300,),
              ),
              Text("What brings you here?", style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20,
              )),
            ],
          ),
        ),
        TutoItem(
          image: 'assets/tutos/icon-looking-around.svg',
          title: 'JUST LOOKING AROUND',
          description: 'Go to the community tab to see what others are growing with SuperGreenLab!',
          label: 'Open community tab >',
          action: () {
            BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToExplorerEvent());
          },
        ),
        TutoItem(
          image: 'assets/tutos/icon-setup-bundle.png',
          title: 'I’M READY TO SETUP MY SGL BUNDLE!',
          description: 'Ok let’s get started by creating a first plant and a lab.',
          label: 'Setup bundle >',
          action: () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreatePlantEvent());
          },
        ),
        TutoItem(
          image: 'assets/tutos/icon-start-diary.svg',
          title: 'LOOKING FOR A DIARY APP FOR MY GROW',
          description: 'Create your first plant to start your first diary!',
          label: 'Start diary >',
          action: () {
           BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreatePlantEvent());
          },
        ),
        TutoItem(
          image: 'assets/tutos/icon-get-advice.png',
          title: 'GET ADVICE',
          description: 'Join the discord server to get help and advice!',
          label: 'Open discord >',
          action: () {
            launchUrl(Uri.parse('https://supergreenlab.com/discord'));
          },
        ),
      ],
    );
  }
}
