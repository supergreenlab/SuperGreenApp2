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

import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';

class CommonL10N {
  static String get loading {
    return Intl.message(
      '''Loading...''',
      name: 'loading',
      desc: 'Loading message usually displayed on the fullscreen overlay',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get done {
    return Intl.message(
      '''Done!''',
      name: 'done',
      desc: 'Success message usually displayed on the fullscreen overlay',
      locale: SGLLocalizations.current.localeName,
    );
  }
}
