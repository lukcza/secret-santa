---
name: Localize Directories
description: Skrót do automatycznego wyszukiwania i przenoszenia zahardkodowanych tekstów z wyznaczonych folderów Dart do pliku lokalizacyjnego app_en.arb.
---

# Skill: Localize Directories

Ten skill automatyzuje proces lokalizacji kodu Flutter w wyznaczonych folderach, przenosząc wszystkie zahardkodowane teksty do pliku `lib/core/l10n/app_en.arb`.

> **BARDZO WAŻNA ZASADA**: Edytuj wyłącznie pliki z rozszerzeniem `.arb` (`lib/core/l10n/app_en.arb`) oraz docelowe pliki widoków/widgetów Dart (zamiana na `context.loc`). **NIGDY NIE EDYTUJ RĘCZNIE** wygenerowanych plików lokalizacji (takich jak `app_localizations.dart` czy `app_localizations_en.dart`). Generowanie klas z pliku `.arb` wykonuje użytkownik za pomocą polecenia `flutter gen-l10n`.

## Instrukcja Krok po Kroku

1. **Wyszukiwanie plików Dart**:
   - Przeszukaj wyznaczony folder w poszukiwaniu plików `.dart`.
   - Zidentyfikuj wszystkie zahardkodowane stringi przyjazne dla użytkownika (np. opisy, teksty przycisków, powiadomienia, błędy, etykiety). Dotyczy to zarówno polskich tekstów, jak i zahardkodowanych angielskich tekstów.

2. **Definiowanie kluczy w ARB**:
   - Dodawaj nowe klucze **TYLKO I WYŁĄCZNIE** w pliku `lib/core/l10n/app_en.arb`.
   - Nie modyfikuj ręcznie żadnych wygenerowanych plików (`app_localizations.dart`, `app_localizations_en.dart` itp.).
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

3. **Aktualizacja kodu Dart (Widoki / Widgety)**:
   - Dodaj import rozszerzenia kontekstu na początku pliku z widokiem/widgetem:
     ```dart
     import 'package:secret_santa/core/extensions/context_extension.dart';
     ```
   - Zastąp zahardkodowane teksty wywołaniem `context.loc.nazwaKlucza` lub `context.loc.nazwaKlucza(parametry)`.

4. **Regeneracja**:
   - Po dodaniu kluczy do `.arb` i zaktualizowaniu widoków Dart, poinformuj użytkownika, aby uruchomił polecenie `flutter gen-l10n` w celu wygenerowania klas lokalizacyjnych.

