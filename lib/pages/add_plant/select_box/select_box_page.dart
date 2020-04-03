import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_plant/select_box/select_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class SelectBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectBoxBloc, SelectBoxBlocState>(
        bloc: BlocProvider.of<SelectBoxBloc>(context),
        builder: (BuildContext context, SelectBoxBlocState state) {
          Widget body;
          if (state is SelectBoxBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SelectBoxBlocStateLoaded) {
            if (state.boxes.length == 0) {
              body = _renderNoBox(context);
            } else {
              body = _renderBoxList(context, state);
            }
          }
          return Scaffold(
              appBar: SGLAppBar(
                '🧪',
                fontSize: 35,
                backgroundColor: Colors.yellow,
                titleColor: Colors.green,
                iconColor: Colors.green,
                elevation: 10,
              ),
              body: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: body,
              ));
        });
  }

  Widget _renderNoBox(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text('You have no lab yet',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text('Create your first',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text('GREEN LAB',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w200,
                          color: Color(0xff3bb30b))),
                ],
              ),
            ),
            GreenButton(
              title: 'CREATE',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToCreateBoxEvent());
              },
            ),
          ],
        )),
      ],
    );
  }

  Widget _renderBoxList(BuildContext context, SelectBoxBlocStateLoaded state) {
    return ListView.builder(
      itemCount: state.boxes.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= state.boxes.length) {
          return ListTile(
            leading: Icon(Icons.add),
            title: Text('Add new green lab'),
            onTap: () {
              _createNewBox(context);
            },
          );
        }
        return ListTile(
          leading: SvgPicture.asset('assets/box_setup/icon_box.svg'),
          title: Text(state.boxes[index].name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Tap to select'),
          onTap: () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(param: state.boxes[index]));
          },
        );
      },
    );
  }

  void _createNewBox(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToCreateBoxEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is Box) {
        BlocProvider.of<MainNavigatorBloc>(context)
            .add(MainNavigatorActionPop(param: res));
      }
    }));
  }
}
