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

import 'package:super_green_app/pages/feed_entries/feed_care/feed_bending/form/feed_bending_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/form/feed_care_common_form_page.dart';

class FeedBendingFormPage extends FeedCareCommonFormPage<FeedBendingFormBloc> {
  @override
  String title() {
    return '💪';
  }
}
