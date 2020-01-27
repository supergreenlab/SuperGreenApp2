import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/bloc/feed_media_form_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class FeedMediaFormPage extends StatefulWidget {
  @override
  _FeedMediaFormPageState createState() => _FeedMediaFormPageState();
}

class _FeedMediaFormPageState extends State<FeedMediaFormPage> {
  final TextEditingController _textController = TextEditingController();

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
        setState(() {
          _keyboardVisible = visible;
        });
        if (!_keyboardVisible) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }
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
            appBar: SGLAppBar('Note creation'),
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
      FeedFormMediaList(
        title: 'Attached medias',
        medias: state.medias,
        onPressed: (FeedMediasCompanion media) {
          if (media == null) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
              FeedMediasCompanion fm = await f;
              if (fm != null) {
                BlocProvider.of<FeedMediaFormBloc>(context)
                    .add(FeedMediaFormBlocPushMedia(fm));
              }
            }));
          }
        },
      ),
      _renderTextrea(context, state),
      _renderOptions(context, state),
      Align(
        alignment: Alignment.centerRight,
        child: RaisedButton(
          color: Color(0xff3bb30b),
          child: Text('OK', style: TextStyle(color: Colors.white)),
          onPressed: () => BlocProvider.of<FeedMediaFormBloc>(context).add(
              FeedMediaFormBlocEventCreate(_textController.text, _helpRequest)),
        ),
      ),
    ];
  }

  Widget _renderTextrea(BuildContext context, FeedMediaFormBlocState state) {
    return Expanded(
      key: Key('TEXTAREA'),
      child: FeedFormTextarea(
        title: 'Observations',
        textEditingController: _textController,
      ),
    );
  }

  Widget _renderOptions(BuildContext context, FeedMediaFormBlocState state) {
    return Row(
      children: <Widget>[
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
        Checkbox(
          onChanged: onChanged,
          value: value,
        ),
        Text(text),
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
