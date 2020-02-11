import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/app_init_bloc.dart';
import 'package:super_green_app/pages/app_init/welcome_page.dart';

class AppInitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<AppInitBloc>(context),
        listener: (BuildContext context, AppInitBlocState state) {
          if (state is AppInitBlocStateReady) {
            if (state.firstStart == false) {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToHomeEvent());
            }
          }
        },
        child: BlocBuilder<AppInitBloc, AppInitBlocState>(
        bloc: BlocProvider.of<AppInitBloc>(context),
        builder: (BuildContext context, AppInitBlocState state) {
          if (state is AppInitBlocStateReady) {
            return WelcomePage(!state.firstStart);
          }
          return WelcomePage(true);
        },
      ),
    );
  }
}
