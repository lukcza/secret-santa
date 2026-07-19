---
name: widget-tree
description: >
  Generuje czytelne drzewo widgetów (widget tree) dla wskazanego pliku Dart
  (Flutter). Użyj gdy użytkownik pyta "wytłumacz widget tree", "pokaż drzewo 
  widgetów", "co robi ten widget" lub wskazuje konkretny plik .dart z widgetami.
---

# Widget Tree Skill

## Kiedy używać

Użyj tego skilla gdy:
- Użytkownik prosi o wyjaśnienie widget tree dla pliku Dart
- Użytkownik pyta co robi dany widget / strona
- Użytkownik chce zrozumieć strukturę UI

## Kroki

### 1. Odczytaj plik

Użyj `view_file` aby przeczytać cały wskazany plik Dart (lub aktywny dokument użytkownika).

### 2. Zidentyfikuj widgety

Znajdź:
- Klasy `StatelessWidget` i `StatefulWidget` (i ich `State`)
- Metody `build()` — to one definiują drzewo
- Conditional rendering (`if`, ternary `? :`)
- Zewnętrzne widgety importowane z innych plików
- Callbacki i przepływ danych (props, BLoC, Provider, itp.)

### 3. Zbuduj drzewo w formacie tekstowym

Używaj notacji z wcięciami i symbolami:

```
RootWidget (typ)
├── ChildA
│   ├── GrandchildA1
│   └── GrandchildA2
└── ChildB
    └── [warunkowo] ChildC
        └── ...
```

Zasady formatowania:
- Każdy poziom wcięcia = jeden poziom zagnieżdżenia w drzewie
- `[warunkowo]` lub `[if condition]` dla warunkowych gałęzi
- `× N` dla list (np. `ListTile × N`)
- Dodaj krótki opis w nawiasach jeśli nazwa widgetu nie jest oczywista
- Zaznacz `(StatefulWidget)` jeśli widget ma własny stan

### 4. Opisz przepływ danych

Po drzewie dodaj sekcję **Przepływ danych** opisującą:
- Skąd pochodzi stan (BLoC, Provider, setState, itp.)
- Jakie eventy/akcje są wysyłane
- Jakie callbacki są przekazywane w dół

### 5. Opcjonalnie: Ważne zależności

Jeśli plik importuje inne pliki z widgetami, wymień je jako linki markdown.

## Format odpowiedzi

Odpowiedź powinna zawierać:

1. **Nagłówek** z nazwą głównego widgetu i ścieżką pliku
2. **Drzewo widgetów** w formacie ASCII tree
3. **Przepływ danych** — krótki opis
4. **Zależności** — lista importowanych widgetów (opcjonalnie)

## Przykład

Dla pliku `matches_page.dart`:

```
MatchesPage (StatefulWidget)
└── BlocConsumer<GroupBloc, GroupState>
    └── Scaffold
        ├── AppBar
        │   └── Text ("Wylosowane pary")
        └── body: Column
            ├── Expanded
            │   └── [warunkowo]
            │       ├── [error] Center > Column > Icon + Text + FilledButton
            │       ├── [loading] CircularProgressIndicator
            │       └── [loaded] ListView.builder
            │           └── MatchTile × N
            └── [if matches.isNotEmpty] _MatchesActions (StatefulWidget)
                └── Container
                    └── Column
                        ├── CustomOutlineButton
                        └── CustomConfirmButton
```

**Przepływ danych:**
- `BlocConsumer` słucha `GroupState`
- `_draw()` → `DrawPairsLocalEvent` → BLoC
- `_confirm()` → `ConfirmDrawEvent` → BLoC
