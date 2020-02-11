import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/form/feed_topping_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class FeedToppingFormPage extends StatefulWidget {
  @override
  _FeedToppingFormPageState createState() => _FeedToppingFormPageState();
}

class _FeedToppingFormPageState extends State<FeedToppingFormPage> {
  final List<FeedMediasCompanion> _beforeMedias = [];
  final List<FeedMediasCompanion> _afterMedias = [];
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
        bloc: Provider.of<FeedToppingFormBloc>(context),
        listener: (BuildContext context, FeedToppingFormBlocState state) {
          if (state is FeedToppingFormBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(mustPop: true));
          }
        },
        child: BlocBuilder<FeedToppingFormBloc, FeedToppingFormBlocState>(
          bloc: Provider.of<FeedToppingFormBloc>(context),
          builder: (context, state) => FeedFormLayout(
            title: 'Topping log',
            changed: _afterMedias.length != 0 ||
                _beforeMedias.length != 0 ||
                _textController.value.text != '',
            valid: _afterMedias.length != 0 ||
                _beforeMedias.length != 0 ||
                _textController.value.text != '',
            onOK: () => BlocProvider.of<FeedToppingFormBloc>(context).add(
                FeedToppingFormBlocEventCreate(_beforeMedias, _afterMedias,
                    _textController.text, _helpRequest)),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _keyboardVisible
                    ? [_renderTextrea(context, state)]
                    : _renderBody(context, state)),
          ),
        ));
  }

  List<Widget> _renderBody(
      BuildContext context, FeedToppingFormBlocState state) {
    return [
      FeedFormParamLayout(
        title: 'Before pics',
        icon: 'assets/feed_form/icon_before_pic.svg',
        child: FeedFormMediaList(
          medias: _beforeMedias,
          onPressed: (FeedMediasCompanion media) {
            if (media == null) {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
                FeedMediasCompanion fm = await f;
                if (fm != null) {
                  setState(() {
                    _beforeMedias.add(fm);
                  }); // Why? no idea, but it wont refresh on bloc's state change without that.
                }
              }));
            }
          },
        ),
      ),
      FeedFormParamLayout(
        title: 'After pics',
        icon: 'assets/feed_form/icon_after_pic.svg',
        child: FeedFormMediaList(
          medias: _afterMedias,
          onPressed: (FeedMediasCompanion media) {
            if (media == null) {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
                FeedMediasCompanion fm = await f;
                if (fm != null) {
                  setState(() {
                    _afterMedias.add(fm);
                  }); // Why? no idea, but it wont refresh on bloc's state change without that.
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

  Widget _renderTextrea(BuildContext context, FeedToppingFormBlocState state) {
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

  Widget _renderOptions(BuildContext context, FeedToppingFormBlocState state) {
    return Row(
      children: <Widget>[],
    );
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _textController.dispose();
    super.dispose();
  }
}
