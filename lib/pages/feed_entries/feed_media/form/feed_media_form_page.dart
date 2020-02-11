import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/feed_media_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class FeedMediaFormPage extends StatefulWidget {
  @override
  _FeedMediaFormPageState createState() => _FeedMediaFormPageState();
}

class _FeedMediaFormPageState extends State<FeedMediaFormPage> {
  final List<FeedMediasCompanion> _medias = [];
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
        bloc: BlocProvider.of<FeedMediaFormBloc>(context),
        listener: (BuildContext context, FeedMediaFormBlocState state) {
          if (state is FeedMediaFormBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(mustPop: true));
          }
        },
        child: BlocBuilder<FeedMediaFormBloc, FeedMediaFormBlocState>(
          bloc: BlocProvider.of<FeedMediaFormBloc>(context),
          builder: (context, state) => FeedFormLayout(
            title: 'Note creation',
            changed: _medias.length != 0 || _textController.value.text != '',
            valid: _medias.length != 0 || _textController.value.text != '',
            onOK: () => BlocProvider.of<FeedMediaFormBloc>(context).add(
                FeedMediaFormBlocEventCreate(
                    _medias, _textController.text, _helpRequest)),
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
      FeedFormParamLayout(
        title: 'Attached medias',
        icon: 'assets/feed_form/icon_after_pic.svg',
        child: FeedFormMediaList(
          medias: _medias,
          onPressed: (FeedMediasCompanion media) {
            if (media == null) {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
                FeedMediasCompanion fm = await f;
                if (fm != null) {
                  setState(() {
                    _medias.add(fm);
                  });
                }
              }));
            }
          },
        ),
      ),
      _renderTextrea(context, state),
      _renderOptions(context, state),
    ];
  }

  Widget _renderTextrea(BuildContext context, FeedMediaFormBlocState state) {
    return Expanded(
      key: Key('TEXTAREA'),
      child: FeedFormParamLayout(
        title: 'Observations',
        icon: 'assets/feed_form/icon_note.svg',
        child: Expanded(
          child: FeedFormTextarea(
            textEditingController: _textController,
          ),
        ),
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
