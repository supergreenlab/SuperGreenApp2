#!/bin/bash

flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n/ lib/l10n.dart
flutter pub run intl_translation:generate_from_arb lib/l10n/*.arb --output-dir=lib/l10n
