#!/bin/bash

flutter pub pub run intl_translation:extract_to_arb --output-dir=assets/l10n/ $(find lib -name '*.dart')
cp assets/l10n/intl_messages.arb lib/l10n/intl_en.arb && \
cp assets/l10n/intl_messages.arb lib/l10n/intl_es.arb && \
cp assets/l10n/intl_messages.arb lib/l10n/intl_fr.arb
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading $(find lib -name '*.dart') lib/l10n/intl_*.arb
