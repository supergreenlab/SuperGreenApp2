import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/tip/bloc/tip_bloc.dart';

class TipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TipBloc, TipBlocState>(
        bloc: Provider.of<TipBloc>(context),
        builder: (context, state) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Watering tips',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'How to tell when a plant is thirsty?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white10,
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                            data: "<h1>hello</h1><br />pouet",
                            defaultTextStyle: TextStyle(color: Colors.white)),
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.white,
                            value: false,
                            onChanged: (bool value) {},
                          ),
                        ),
                        Text('Don’t show me this again',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Color(0xff3bb30b),
                        textColor: Colors.white,
                        child: Text('OK'),
                        onPressed: () =>
                            BlocProvider.of<MainNavigatorBloc>(context)
                                .add(state.nextRoute),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
