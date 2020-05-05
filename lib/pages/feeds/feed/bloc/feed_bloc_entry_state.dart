/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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

class FeedBlocEntryState extends Equatable {
  final String id;
  final String type;
  final bool synced;
  final DateTime date;

  FeedBlocEntryState(this.id, this.type, this.synced, this.date);

  @override
  List<Object> get props => [id, type, synced, date];
}

class FeedBlocEntryStateNotLoaded extends FeedBlocEntryState {
  FeedBlocEntryStateNotLoaded(String id, String type, bool synced, DateTime date) : super(id, type, synced, date);
}

class FeedBlocEntryStateLoaded extends FeedBlocEntryState {
  final dynamic state;

  FeedBlocEntryStateLoaded(String id, String type, bool synced, DateTime date, this.state)
      : super(id, type, synced, date);

  @override
  List<Object> get props => [id, type, synced, date, state];
}
