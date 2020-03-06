import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieHelper extends StatefulWidget {
  final RouteSettings settings;

  const TowelieHelper({Key key, @required this.settings}) : super(key: key);

  @override
  _TowelieHelperState createState() => _TowelieHelperState();

  static Widget wrapWidget(
      RouteSettings settings, BuildContext context, Widget widget) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<TowelieBloc>(context)
            .add(TowelieBlocEventRoutePop(settings));
        return true;
      },
      child: Stack(children: [
        widget,
        TowelieHelper(settings: settings),
      ]),
    );
  }
}

class _TowelieHelperState extends State<TowelieHelper> {
  String text = '';
  bool visible = false;
  double y = 300;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TowelieBloc, TowelieBlocState>(
      listener: (BuildContext context, TowelieBlocState state) {
        if (state is TowelieBlocStateHelper &&
            state.settings.name == widget.settings.name) {
          _prepareShow(state);
        } else if (state is TowelieBlocStateHelperPop &&
            state.settings.name == widget.settings.name) {
          _prepareHide();
        }
      },
      child: BlocBuilder<TowelieBloc, TowelieBlocState>(
        condition: (context, state) => state is TowelieBlocStateHelper && state.settings.name == widget.settings.name,
        builder: (BuildContext context, TowelieBlocState state) {
          if (visible) {
            return _renderBody(state as TowelieBlocStateHelper);
          }
          return Container();
        },
      ),
    );
  }

  Widget _renderBody(TowelieBlocStateHelper state) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          curve: Curves.elasticInOut,
          duration: Duration(milliseconds: 1500),
          transform: Matrix4.translationValues(0, y, 0),
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Dismissible(
            direction: DismissDirection.down,
            key: Key('Towelie'),
            onDismissed: (direction) {
              setState(() {
                visible = false;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffdedede), width: 2),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 16),
                        child: MarkdownBody(
                          data: state.text,
                          styleSheet: MarkdownStyleSheet(
                              p: TextStyle(color: Colors.black, fontSize: 16)),
                        )),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffdedede), width: 2),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.asset(
                                'assets/feed_card/icon_towelie.png'))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _prepareShow(TowelieBlocStateHelper state) {
    setState(() {
      text = state.text;
      visible = true;
      y = 300;
    });
    Timer(Duration(milliseconds: 300), () {
      setState(() {
        y = 0;
      });
    });
  }

  void _prepareHide() {
    setState(() {
      y = 300;
    });
    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        visible = false;
      });
    });
  }
}
