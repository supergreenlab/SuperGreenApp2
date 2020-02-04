import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/appbar.dart';

class FeedFormLayout extends StatelessWidget {
  final Widget body;
  final bool valid;
  final bool changed;
  final void Function() onOK;
  final String title;

  const FeedFormLayout(
      {@required this.body,
      @required this.onOK,
      @required this.title,
      this.valid = true,
      this.changed = false});

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (this.onOK != null) {
      actions.add(IconButton(
        icon: Icon(
          Icons.check,
          color: Color(this.valid ? 0xff3bb30b : 0xffcdcdcd),
        ),
        onPressed: this.valid ? onOK : null,
      ));
    }
    return WillPopScope(
      onWillPop: () async {
        if (this.changed) {
          return await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Unsaved changed'),
                  content: Text('Changed will not be saved. Continue?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('NO'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('YES'),
                    ),
                  ],
                );
              });
        }
        return true;
      },
      child: Scaffold(
          appBar: SGLAppBar(
            title,
            actions: actions,
          ),
          body:
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: this.body),
          ]),
              )),
    );
  }
}
