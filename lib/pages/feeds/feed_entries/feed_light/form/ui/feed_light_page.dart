import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_light/form/bloc/feed_light_bloc.dart';

class FeedLightFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedLightFormBloc, FeedLightFormBlocState>(
        bloc: Provider.of<FeedLightFormBloc>(context),
        builder: (context, state) => Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Add light change', style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Text('LightChange', style: TextStyle(color: Colors.white))));
  }
}
