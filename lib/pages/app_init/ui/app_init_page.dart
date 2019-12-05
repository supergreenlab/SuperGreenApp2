import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/app_init/bloc/app_init_bloc.dart';
import 'package:super_green_app/pages/welcome/ui/welcome_page.dart';

class AppInitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppInitBloc, AppInitState>(
      bloc: Provider.of<AppInitBloc>(context),
      builder: (BuildContext context, AppInitState state) {
        if (state is AppInitStateReady) {
          if (state.firstStart == true) {
            return WelcomePage(true);
          } else {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToHomeEvent());
          }
        }
        return WelcomePage(false);
      },
    );
  }
}
