import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_water/form/bloc/feed_water_form_bloc.dart';

class FeedWaterFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedWaterFormBloc, FeedWaterFormBlocState>(
        bloc: Provider.of<FeedWaterFormBloc>(context),
        builder: (context, state) => Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Add water change', style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Text('WaterChange', style: TextStyle(color: Colors.white))));
  }
}
