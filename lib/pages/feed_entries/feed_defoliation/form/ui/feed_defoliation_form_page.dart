import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/form/bloc/feed_defoliation_form_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_media_list.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class FeedDefoliationFormPage extends StatefulWidget {
  @override
  _FeedDefoliationFormPageState createState() =>
      _FeedDefoliationFormPageState();
}

class _FeedDefoliationFormPageState extends State<FeedDefoliationFormPage> {
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
        bloc: Provider.of<FeedDefoliationFormBloc>(context),
        listener: (BuildContext context, FeedDefoliationFormBlocState state) {
          if (state is FeedDefoliationFormBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          }
        },
        child:
            BlocBuilder<FeedDefoliationFormBloc, FeedDefoliationFormBlocState>(
          bloc: Provider.of<FeedDefoliationFormBloc>(context),
          builder: (context, state) => Scaffold(
            appBar: SGLAppBar('Defoliation log'),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _keyboardVisible
                    ? [_renderTextrea(context, state)]
                    : _renderBody(context, state)),
          ),
        ));
  }

  List<Widget> _renderBody(
      BuildContext context, FeedDefoliationFormBlocState state) {
    return [
      FeedFormMediaList(
        title: 'Before pics',
        medias: state.beforeMedias,
        onPressed: (FeedMediasCompanion media) {
          if (media == null) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
              FeedMediasCompanion fm = await f;
              if (fm != null) {
                BlocProvider.of<FeedDefoliationFormBloc>(context)
                    .add(FeedDefoliationFormBlocPushMedia(true, fm));
              }
            }));
          }
        },
      ),
      FeedFormMediaList(
        title: 'After pics',
        medias: state.afterMedias,
        onPressed: (FeedMediasCompanion media) {
          if (media == null) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToImageCaptureEvent(futureFn: (f) async {
              FeedMediasCompanion fm = await f;
              if (fm != null) {
                BlocProvider.of<FeedDefoliationFormBloc>(context)
                    .add(FeedDefoliationFormBlocPushMedia(false, fm));
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
          onPressed: () => BlocProvider.of<FeedDefoliationFormBloc>(context)
              .add(FeedDefoliationFormBlocEventCreate(
                  _textController.text, _helpRequest)),
        ),
      ),
    ];
  }

  Widget _renderTextrea(
      BuildContext context, FeedDefoliationFormBlocState state) {
    return Expanded(
      key: Key('TEXTAREA'),
      child: FeedFormTextarea(
        title: 'Observations',
        textEditingController: _textController,
      ),
    );
  }

  Widget _renderOptions(
      BuildContext context, FeedDefoliationFormBlocState state) {
    return Row(
      children: <Widget>[],
    );
  }

  Widget _renderOptionCheckbx(
      BuildContext context,
      FeedDefoliationFormBlocState state,
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
