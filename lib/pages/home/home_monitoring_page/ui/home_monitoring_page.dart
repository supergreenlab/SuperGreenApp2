import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/home/home_monitoring_page/bloc/home_monitoring_bloc.dart';

class HomeMonitoringPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMonitoringBloc, HomeMonitoringBlocState>(
      bloc: Provider.of<HomeMonitoringBloc>(context),
      builder: (BuildContext context, HomeMonitoringBlocState state) {
        return Text('HomeMonitoringPage ${state.device.id}');
      },
    );
  }
}
