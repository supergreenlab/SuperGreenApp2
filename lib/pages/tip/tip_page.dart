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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/tip/tip_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class TipPage extends StatefulWidget {
  @override
  _TipPageState createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  bool dontShow = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TipBloc, TipBlocState>(
        bloc: BlocProvider.of<TipBloc>(context),
        builder: (BuildContext context, TipBlocState state) {
          String title = 'Tips';
          Widget body;
          if (state is TipBlocStateInit) {
            body = FullscreenLoading(title: 'Loading..');
          } else if (state is TipBlocStateLoaded) {
            title = state.tips[currentIndex]['article']['title'];
            body = Column(
              children: <Widget>[
                Expanded(
                  child: Swiper(
                    itemCount: state.tips.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return _renderArticle(context, state.tips[index],
                          state.tips[index]['article']);
                    },
                    onIndexChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    pagination: state.tips.length > 1
                        ? SwiperPagination(
                            builder: new DotSwiperPaginationBuilder(
                                color: Color(0xffdedede),
                                activeColor: Color(0xff3bb30b)),
                          )
                        : null,
                    loop: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.black),
                        child: Checkbox(
                            activeColor: Colors.black,
                            checkColor: Colors.black,
                            value: dontShow,
                            onChanged: (bool value) {
                              setState(() {
                                dontShow = value;
                              });
                            }),
                      ),
                      Text('Don’t show me this again',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            );
          }
          return Scaffold(
            appBar: SGLAppBar(
              title,
              backgroundColor: Colors.teal,
              titleColor: Colors.white,
              iconColor: Colors.white,
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: AnimatedSwitcher(
                      duration: Duration(microseconds: 200), child: body),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                    child: GreenButton(
                      title: state is TipBlocStateLoaded ? 'OK' : 'SKIP',
                      onPressed: () {
                        BlocProvider.of<MainNavigatorBloc>(context)
                            .add(state.nextRoute);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _renderArticle(BuildContext context, Map<String, dynamic> tip,
      Map<String, dynamic> article) {
    List<Widget> sections = [
      _renderSection(tip, article, article['intro']),
    ];
    List<Map<String, dynamic>> ss = article['sections'];
    if (ss != null) {
      sections.addAll(ss.map((e) => _renderSection(tip, article, e)));
    }
    sections.add(Container(height: 30));
    return Column(children: <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: sections),
        ),
      ),
    ]);
  }

  Widget _renderSection(Map<String, dynamic> tip, Map<String, dynamic> article,
      Map<String, dynamic> section) {
    String slug = _slug(article);
    String imagePath =
        'https://tipapi.supergreenlab.com/a/${tip['user']}/${tip['repo']}/${tip['branch']}/s/${slug}/${section['image']['url']}';
    return Column(
      children: <Widget>[
        (section['title'] != null && section['title'].length > 0)
            ? Text(section['title'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            : Container(),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              SizedBox(
                  width: constraints.maxWidth,
                  height: 300,
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: MarkdownBody(
            data: section['text'],
            styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  String _slug(Map<String, dynamic> article) {
    List<String> slug = article['name'].split('_');
    slug = slug.skip(1).toList();
    return slug.join('_');
  }
}
