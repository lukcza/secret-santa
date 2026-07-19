---
name: Localize Directories
description: Skrót do automatycznego wyszukiwania i przenoszenia zahardkodowanych tekstów z wyznaczonych folderów Dart do pliku lokalizacyjnego app_en.arb.
---

# Skill: Localize Directories

Ten skill automatyzuje proces lokalizacji kodu Flutter w wyznaczonych folderach, przenosząc wszystkie zahardkodowane teksty do pliku `lib/core/l10n/app_en.arb`.

## Instrukcja Krok po Kroku

1. **Wyszukiwanie plików Dart**:
   - Przeszukaj wyznaczony folder w poszukiwaniu plików `.dart`.
   - Zidentyfikuj wszystkie zahardkodowane stringi przyjazne dla użytkownika (np. opisy, teksty przycisków, powiadomienia, błędy, etykiety). Dotyczy to zarówno polskich tekstów, jak i zahardkodowanych angielskich tekstów.

2. **Definiowanie kluczy w ARB**:
   - Dla każdego znalezionego tekstu dodaj unikalny klucz w `lib/core/l10n/app_en.arb`.
   - Jeśli tekst zawiera parametry dynamiczne (np. `Profil: ${user.name}`), użyj placeholderów:
     ```json
     "profileNavigationMock": "Profile: {name}",
     "@profileNavigationMock": {
       "placeholders": {
         "name": {
           "type": "String"
         }
       }
     }
     ```
   - Jeśli tekst wymaga liczby mnogiej (np. `1 Elf` / `5 Elves`), zastosuj format liczby mnogiej:
     ```json
     "membersCountText": "{count, plural, =1{1 Elf} other{{count} Elves}}",
     "@membersCountText": {
       "placeholders": {
         "count": {
           "type": "num"
         }
       }
     }
     ```

3. **Aktualizacja kodu Dart**:
   - Dodaj import rozszerzenia kontekstu na początku pliku:
     ```dart
     import 'package:secret_santa/core/extensions/context_extension.dart';
     ```
   - Zastąp zahardkodowane teksty wywołaniem `context.loc.nazwaKlucza` lub `context.loc.nazwaKlucza(parametry)`.

4. **Regeneracja**:
   - Poinformuj użytkownika o konieczności uruchomienia polecenia `flutter gen-l10n` (lub zaproponuj polecenie w terminalu) w celu wygenerowania zaktualizowanych klas Dart.
   - Zweryfikuj projekt komendą `flutter analyze`.
