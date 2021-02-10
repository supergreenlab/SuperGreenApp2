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

  static String get saving {
    return Intl.message(
      '''Saving...''',
      name: 'saving',
      desc: 'Saving message usually displayed on the fullscreen overlay',
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

  static String get no {
    return Intl.message(
      '''NO''',
      name: 'no',
      desc: 'Used in confirmation dialogs',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get yes {
    return Intl.message(
      '''YES''',
      name: 'yes',
      desc: 'Used in confirmation dialogs',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get ok {
    return Intl.message(
      '''OK''',
      name: 'ok',
      desc: 'Used in confirmation dialogs',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get or {
    return Intl.message(
      '''OR''',
      name: 'or',
      desc: 'Used in confirmation dialogs',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get cancel {
    return Intl.message(
      '''CANCEL''',
      name: 'cancel',
      desc: 'Used in confirmation dialogs',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get loginCreateAccount {
    return Intl.message(
      '''LOGIN / CREATE ACCOUNT''',
      name: 'loginCreateAccount',
      desc: 'Used in "please login" dialogs',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get loginRequiredDialogTitle {
    return Intl.message(
      '''Login required''',
      name: 'loginRequiredDialogTitle',
      desc: 'Used in "please login" dialogs',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get loginRequiredDialogBody {
    return Intl.message(
      '''Please log in or create an account.''',
      name: 'loginRequiredDialogBody',
      desc: 'Used in "please login" dialogs',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get unsavedChangeDialogTitle {
    return Intl.message(
      '''Unsaved changes''',
      name: 'unsavedChangeDialogTitle',
      desc: 'Title for the "unsaved changes" dialog when pressing back',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get unsavedChangeDialogBody {
    return Intl.message(
      '''Changes will not be saved. Continue?''',
      name: 'unsavedChangeDialogBody',
      desc: 'Body for the "unsaved changes" dialog when pressing back',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get confirmUnRevertableChange {
    return Intl.message(
      'This can\'t be reverted. Continue?',
      name: 'confirmUnRevertableChange',
      desc: 'Body for the delete dialog confirmation',
      locale: SGLLocalizations.current.localeName,
    );
  }
}
