import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/bloc/feed_media_form_bloc.dart';

class FeedMediaFormPage extends StatefulWidget {
  @override
  _FeedMediaFormPageState createState() => _FeedMediaFormPageState();
}

class _FeedMediaFormPageState extends State<FeedMediaFormPage> {
  final TextEditingController _textController = TextEditingController();

  bool _private = false;
  bool _helpRequest = false;

  KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();
  int _listener;
  bool _keyboardVisible = false;

  @protected
  void initState() {
    super.initState();

    _listener = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        _keyboardVisible = visible;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: Provider.of<FeedMediaFormBloc>(context),
        listener: (BuildContext context, FeedMediaFormBlocState state) {
          if (state is FeedMediaFormBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          }
        },
        child: BlocBuilder<FeedMediaFormBloc, FeedMediaFormBlocState>(
          bloc: Provider.of<FeedMediaFormBloc>(context),
          builder: (context, state) => Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Note creation',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _keyboardVisible
                    ? [_renderTextrea(context, state)]
                    : _renderBody(context, state)),
          ),
        ));
  }

  List<Widget> _renderBody(BuildContext context, FeedMediaFormBlocState state) {
    return [
      _renderMedias(context, state),
      _renderTextrea(context, state),
      _renderOptions(context, state),
      Align(
        alignment: Alignment.centerRight,
        child: RaisedButton(
          color: Color(0xff3bb30b),
          child: Text('OK', style: TextStyle(color: Colors.white)),
          onPressed: () => BlocProvider.of<FeedMediaFormBloc>(context).add(
              FeedMediaFormBlocEventCreate(
                  _textController.text, _private, _helpRequest)),
        ),
      ),
    ];
  }

  Widget _renderMedias(BuildContext context, FeedMediaFormBlocState state) {
    List<Widget> medias = state.medias
        .map((m) => _renderMedia(
              context,
              state,
              () {},
              Image.file(File(m.thumbnailPath.value)),
            ))
        .toList();
    medias.add(_renderMedia(context, state, () {
      BlocProvider.of<MainNavigatorBloc>(context)
          .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
        FeedMediasCompanion fm = await f;
        if (fm != null) {
          BlocProvider.of<FeedMediaFormBloc>(context)
              .add(FeedMediaFormBlocPushMedia(fm));
        }
      }));
    },
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset('assets/feed_form/icon_add.svg'),
        )));
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('Attached medias', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                Container(
                  color: Colors.white12,
                ),
                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: medias,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderTextrea(BuildContext context, FeedMediaFormBlocState state) {
    return Expanded(
      key: Key('TEXTAREA'),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Observations',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      border: Border.all(width: 1, color: Colors.white24),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: null,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      expands: true,
                      maxLines: null,
                      controller: _textController,
                    ),
                  ),
                ),
              ),
            )
          ]),
    );
  }

  Widget _renderMedia(BuildContext context, FeedMediaFormBlocState state,
      Function onPressed, Widget content) {
    return SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: RawMaterialButton(
            onPressed: onPressed,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10)),
                child: content),
          ),
        ),
        height: 100,
        width: 100);
  }

  Widget _renderOptions(BuildContext context, FeedMediaFormBlocState state) {
    return Row(
      children: <Widget>[
        _renderOptionCheckbx(context, state, 'Private note', (bool newValue) {
          setState(() {
            _private = newValue;
          });
        }, _private),
        _renderOptionCheckbx(context, state, 'Help request?', (bool newValue) {
          setState(() {
            _helpRequest = newValue;
          });
        }, _helpRequest),
      ],
    );
  }

  Widget _renderOptionCheckbx(
      BuildContext context,
      FeedMediaFormBlocState state,
      String text,
      Function onChanged,
      bool value) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.white,
            onChanged: onChanged,
            value: value,
          ),
        ),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _textController.dispose();
    super.dispose();
  }
}
