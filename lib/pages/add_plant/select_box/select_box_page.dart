import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_plant/select_box/select_box_bloc.dart';
import 'package:super_green_app/pages/add_plant/select_device/select_device_page.dart';
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
                'Select plant\'s box',
                backgroundColor: Colors.pink,
                titleColor: Colors.white,
                iconColor: Colors.white,
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
            Text('No box yet.'),
            GreenButton(
              title: 'Create box',
              onPressed: () {
                _createNewBox(context);
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
            title: Text('Add new box'),
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
