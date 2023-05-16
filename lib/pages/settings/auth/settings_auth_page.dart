/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/feed_entries/common/widgets/user_avatar.dart';
import 'package:super_green_app/pages/image_picker/picker_widget.dart';
import 'package:super_green_app/pages/settings/auth/delete_account/delete_account_bloc.dart';
import 'package:super_green_app/pages/settings/auth/delete_account/delete_account_page.dart';
import 'package:super_green_app/pages/settings/auth/settings_auth_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class SettingsAuthPage extends TraceableStatefulWidget {
  @override
  _SettingsAuthPageState createState() => _SettingsAuthPageState();
}

class _SettingsAuthPageState extends State<SettingsAuthPage> {
  bool _syncOverGSM = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsAuthBloc, SettingsAuthBlocState>(
      listener: (BuildContext context, SettingsAuthBlocState state) {
        if (state is SettingsAuthBlocStateLoaded) {
          setState(() {
            _syncOverGSM = state.syncOverGSM;
          });
        } else if (state is SettingsAuthBlocStateDone) {
          Timer(Duration(seconds: 2), () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop());
          });
        }
      },
      child: BlocBuilder<SettingsAuthBloc, SettingsAuthBlocState>(
        bloc: BlocProvider.of<SettingsAuthBloc>(context),
        builder: (BuildContext context, SettingsAuthBlocState state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );

          if (state is SettingsAuthBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsAuthBlocStateLoaded) {
            if (state.isAuth) {
              body = _renderAuthBody(context, state);
            } else {
              body = _renderUnauthBody(context, state);
            }
          } else if (state is SettingsAuthBlocStateDone) {
            body = Fullscreen(
              title: 'Done!',
              child: Icon(
                Icons.check,
                color: Color(0xff3bb30b),
                size: 100,
              ),
            );
          } else if (state is SettingsAuthBlocStateError) {
            body = Fullscreen(
              title: state.message,
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
            );
          }
          return Scaffold(
              appBar: SGLAppBar(
                '🔐',
                fontSize: 35,
                backgroundColor: Colors.indigo,
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: !(state is SettingsAuthBlocStateLoaded),
              ),
              body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  Widget _renderAuthBody(BuildContext context, SettingsAuthBlocStateLoaded state) {
    String? pic = state.user?.pic;
    if (pic != null) {
      pic = BackendAPI().feedsAPI.absoluteFileURL(pic);
    }
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Expanded(child: Container()),
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: InkWell(
            onTap: () {
              _checkPermission().then((granted) {
                if (!granted) return;
                _buildPicker(context);
              });
            },
            child: Column(
              children: [
                UserAvatar(icon: pic, size: 150),
                Text(
                  "Tap to change",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            )),
      ),
      Text(
        'Connected to your',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child:
            Text('SGL ACCOUNT', style: TextStyle(fontSize: 45, fontWeight: FontWeight.w200, color: Color(0xff3bb30b))),
      ),
      state.user != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Connected as '),
                Text(state.user!.nickname, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            )
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
              ),
              Text('Loading user data..')
            ]),
      _renderOptionCheckbx(context, 'Sync over mobile data too', (bool? newValue) {
        setState(() {
          _syncOverGSM = newValue ?? false;
          BlocProvider.of<SettingsAuthBloc>(context).add(SettingsAuthBlocEventSetSyncedOverGSM(_syncOverGSM));
        });
      }, _syncOverGSM == true),
      !state.notificationEnabled
          ? GreenButton(
              title: 'ACTIVATE NOTIFICATION',
              onPressed: () {
                BlocProvider.of<NotificationsBloc>(context).add(NotificationsBlocEventRequestPermission());
              },
            )
          : Container(),
      Expanded(child: Container()),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {_requestDelete(context);},
            child: Text(
              'Request account deletion',
              style: TextStyle(decoration: TextDecoration.underline, color: Color(0xffff0000)),
            )),
      ),
    ]);
  }

  Widget _renderUnauthBody(BuildContext context, SettingsAuthBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Text(
              'create your',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('SGL ACCOUNT',
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.w200, color: Color(0xff3bb30b))),
            ),
            GreenButton(
              title: 'LOGIN',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsLogin(futureFn: (future) async {
                  dynamic res = await future;
                  if (res == true) {
                    BlocProvider.of<SettingsAuthBloc>(context).add(SettingsAuthBlocEventInit());
                    //BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: res));
                  }
                }));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('OR', style: TextStyle(fontWeight: FontWeight.normal)),
            ),
            GreenButton(
              title: 'CREATE ACCOUNT',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToSettingsCreateAccount(futureFn: (future) async {
                  dynamic res = await future;
                  if (res == true) {
                    BlocProvider.of<SettingsAuthBloc>(context).add(SettingsAuthBlocEventInit());
                    //BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: res));
                  }
                }));
              },
            )
          ],
        )),
      ],
    );
  }

  Widget _renderOptionCheckbx(BuildContext context, String text, Function(bool?) onChanged, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          onChanged: onChanged,
          value: value,
        ),
        InkWell(
          onTap: () {
            onChanged(!value);
          },
          child: MarkdownBody(
            fitContent: true,
            data: text,
            styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  void _buildPicker(BuildContext context) {
    showModalBottomSheet<Set<MediaFile>>(
      context: context,
      builder: (BuildContext c) {
        return PickerWidget(
          withImages: true,
          withVideos: true,
          multiple: false,
          onDone: (Set<MediaFile?> selectedFiles) {
            Timer(Duration(milliseconds: 500), () {
              BlocProvider.of<SettingsAuthBloc>(context)
                  .add(SettingsAuthBlocEventUpdatePic(File(selectedFiles.toList()[0]!.path)));
            });
            Navigator.pop(c);
          },
          onCancel: () {
            Navigator.pop(c);
          },
        );
      },
    );
  }

  void _requestDelete(BuildContext pageContext) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => DeleteAccountBloc(),
            child: DeleteAccountPage(onDone: () {
              //BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop());
              BlocProvider.of<SettingsAuthBloc>(pageContext).add(SettingsAuthBlocEventInit());
            }),
          );
        });
  }

  Future<bool> _checkPermission() async {
    final permissionStorageGroup = Platform.isIOS ? Permission.photos : Permission.storage;
    Map<Permission, PermissionStatus> res = await [
      permissionStorageGroup,
    ].request();
    return res[permissionStorageGroup] == PermissionStatus.granted;
  }
}
