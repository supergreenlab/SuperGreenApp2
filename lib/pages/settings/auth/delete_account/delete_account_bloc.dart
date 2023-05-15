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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/clear_all.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class DeleteAccountBlocEvent extends Equatable {}

class DeleteAccountBlocEventInit extends DeleteAccountBlocEvent {
  @override
  List<Object?> get props => [];
}

class DeleteAccountBlocEventDelete extends DeleteAccountBlocEvent {
  final String nickname;
  final String password;
  final bool deleteLocalData;

  DeleteAccountBlocEventDelete(this.nickname, this.password, this.deleteLocalData);

  @override
  List<Object?> get props => [
        nickname,
        password,
        deleteLocalData,
      ];
}

abstract class DeleteAccountBlocState extends Equatable {}

class DeleteAccountBlocStateInit extends DeleteAccountBlocState {
  @override
  List<Object?> get props => [];
}

class DeleteAccountBlocStateError extends DeleteAccountBlocState {
  @override
  List<Object?> get props => [];
}

class DeleteAccountBlocStateDeletingFiles extends DeleteAccountBlocState {
  final int nFiles;
  final int totalFiles;

  DeleteAccountBlocStateDeletingFiles(this.nFiles, this.totalFiles);

  @override
  List<Object?> get props => [nFiles, totalFiles];
}

class DeleteAccountBlocStateDone extends DeleteAccountBlocState {
  @override
  List<Object?> get props => [];
}

class DeleteAccountBloc extends LegacyBloc<DeleteAccountBlocEvent, DeleteAccountBlocState> {
  DeleteAccountBloc() : super(DeleteAccountBlocStateInit()) {
    add(DeleteAccountBlocEventInit());
  }

  @override
  Stream<DeleteAccountBlocState> mapEventToState(DeleteAccountBlocEvent event) async* {
    if (event is DeleteAccountBlocEventInit) {
    } else if (event is DeleteAccountBlocEventDelete) {
      try {
        await BackendAPI().usersAPI.deleteUser(event.nickname, event.password);
      } catch (e) {
        yield DeleteAccountBlocStateError();
        return;
      }
      AppDB().setJWT(null);
      if (event.deleteLocalData) {
        await for (ClearAllState s in ClearAll.clear()) {
          yield DeleteAccountBlocStateDeletingFiles(s.nFiles, s.totalFiles);
        }
      } else {
        await for (ClearAllState s in ClearAll.clearServerIDs()) {
          yield DeleteAccountBlocStateDeletingFiles(s.nFiles, s.totalFiles);
        }
      }

      yield DeleteAccountBlocStateDone();
    }
  }
}
