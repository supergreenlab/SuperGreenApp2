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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/settings/auth/delete_account/delete_account_bloc.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/red_button.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  TextEditingController nickname = TextEditingController();
  TextEditingController password = TextEditingController();
  bool deleteLocalData = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAccountBloc, DeleteAccountBlocState>(
        listener: (BuildContext context, DeleteAccountBlocState state) {},
        child: BlocBuilder<DeleteAccountBloc, DeleteAccountBlocState>(
            bloc: BlocProvider.of<DeleteAccountBloc>(context),
            builder: (BuildContext context, DeleteAccountBlocState state) {
              if (state is DeleteAccountBlocStateDeletingFiles) {
                return _renderDeleting(context, state);
              } else if (state is DeleteAccountBlocStateError) {
                return _renderError(context, state);
              }
              return _renderForm();
            }));
  }

  Widget _renderDeleting(BuildContext context, DeleteAccountBlocStateDeletingFiles state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Deleting'),
        ),
      ],
    );
  }

  Widget _renderError(BuildContext context, DeleteAccountBlocStateError state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Deleting'),
        ),
      ],
    );
  }

  Widget _renderForm() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 80.0,
          left: 16,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Please enter your nickname and password to confirm.\nAll your account data will be totally deleted after a quick verification.',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text('Username:'),
            ),
            TextField(
              controller: nickname,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text('Password:'),
            ),
            TextField(
              controller: password,
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      value: deleteLocalData,
                      onChanged: (bool? checked) {
                        setState(() {
                          deleteLocalData = !deleteLocalData;
                        });
                      }),
                  InkWell(
                    child: Text('Delete local data too?'),
                    onTap: () {
                      setState(() {
                        deleteLocalData = !deleteLocalData;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RedButton(
                    title: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GreenButton(
                      title: 'Confirm delete',
                      onPressed: nickname.text != '' && password.text != ''
                          ? () {
                              BlocProvider.of<DeleteAccountBloc>(context)
                                  .add(DeleteAccountBlocEventDelete(nickname.text, password.text, deleteLocalData));
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
