#!/bin/bash

flutter pub pub run intl_translation:extract_to_arb --output-dir=assets/l10n/ lib/l10n.dart
cp assets/l10n/intl_messages.arb lib/l10n/intl_en.arb && \
cp assets/l10n/intl_messages.arb lib/l10n/intl_es.arb && \
cp assets/l10n/intl_messages.arb lib/l10n/intl_fr.arb
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n.dart lib/l10n/intl_*.arb
