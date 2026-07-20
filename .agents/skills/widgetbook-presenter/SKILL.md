---
name: widgetbook-presenter
description: >
  Tworzy lub aktualizuje prezentację strony/widgetu w Widgetbooku projektu Secret Santa.
  Użyj gdy użytkownik prosi o "pokaż w widgetbooku", "dodaj do widgetbooka", "zrób prezentację",
  "stwórz usecase dla widgetbooka" lub po stworzeniu nowej strony/widgetu.
  Skill zawsze tworzy oddzielne use-case'y dla KAŻDEGO stanu UI z mockowanymi danymi.
---

# Widgetbook Presenter Skill

## Kiedy używać

Użyj gdy:
- Użytkownik prosi o prezentację strony lub widgetu w Widgetbooku
- Po stworzeniu nowej strony (Page) lub widgetu (Widget)
- Użytkownik mówi "pokaż w widgetbooku", "dodaj do widgetbooka"

## Struktura projektu Widgetbook

```
widgetbook/lib/
  main.dart                         ← główna konfiguracja (NIC nie zmieniaj bez potrzeby)
  usecases/
    groups/
      groups_directory.dart          ← katalog główny sekcji groups
      groups_pages_directory.dart    ← lista stron (WidgetbookFolder 'Pages')
      groups_widgets_directory.dart  ← lista widgetów (WidgetbookFolder 'Widgets')
      <nazwa>_usecase.dart           ← plik z use-case'ami dla strony/widgetu
```

## Zasady tworzenia use-case'ów

### 1. Zawsze pokrywaj WSZYSTKIE stany

Każda strona/widget musi mieć oddzielny `WidgetbookUseCase` dla każdego stanu:

**Dla Page:**
- Stan A (np. `– Recruiting` / przed losowaniem)
- Stan B (np. `– Drawn` / po losowaniu)
- Stan C (np. `– Empty` / pusta lista)
- Stan D (np. `– User view` / widok uczestnika)
- Knobs do interaktywnej edycji danych

**Dla Widget:**
- Każdy wariant wizualny (np. expanded/collapsed, confirmed/unconfirmed)
- Wariant z długim tekstem / edge case'ami

### 2. Fake BLoC pattern

Widgetbook nie może używać prawdziwych repozytoriów Firestore.
Używaj **_FakeGroupBloc** który:
- Przyjmuje `GroupEntity` i `List<UserEntity>` w konstruktorze
- Ustawia je w `initialState` bez żadnych wywołań sieciowych
- Rejestruje handlery dla eventów lokalnych (GetGroupParticipantsEvent, UpdateGroupEvent itp.)

```dart
class _FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  _FakeGroupBloc(GroupEntity group, [List<UserEntity>? participants])
    : super(GroupState(
        status: GroupStatus.draft,
        group: group,
        inviteCode: group.inviteCode,
        participants: participants ?? _fakeParticipants,
      )) {
    on<GetGroupParticipantsEvent>((event, emit) {
      // no-op – dane już w initialState
    });
    on<UpdateGroupEvent>((event, emit) {
      emit(state.copyWith(group: event.group));
    });
    // dodaj inne handlery wg potrzeb
  }
}
```

### 3. Fake AuthBloc pattern

```dart
AuthBloc _buildFakeAuthBloc({String uid = 'admin_uid'}) {
  final repo = _FakeAuthRepository(uid: uid);
  return AuthBloc(
    loginUser: LoginUser(repo),
    registerUser: RegisterUser(repo),
    signOutUser: SignOutUser(repo),
    getCurrentUser: GetCurrentUser(repo),
  )..emit(AuthState(status: AuthStatus.authenticated, user: UserEntity(uid: uid, email: '$uid@example.com')));
}
```

### 4. Wrapping strony w Navigator

Strony używające GoRouter/Navigation wymagają wrappera:
```dart
Navigator(
  onGenerateRoute: (_) => MaterialPageRoute(
    builder: (_) => MojaStrona(group: group),
  ),
)
```

### 5. MultiBlocProvider pattern

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc()),
    BlocProvider<GroupBloc>(create: (_) => _FakeGroupBloc(group)),
  ],
  child: Navigator(...),
)
```

### 6. Knobs dla interaktywności

Zawsze dodaj knobs do głównego use-case'u:
```dart
context.knobs.string(label: 'Group Title', initialValue: 'Team Santa 🎅')
context.knobs.int.input(label: 'Budget', initialValue: 100)
context.knobs.boolean(label: 'Has Matches', initialValue: false)
```

## Kroki implementacji

### Krok 1: Zbadaj plik źródłowy

Odczytaj plik strony/widgetu aby zrozumieć:
- Jakie parametry przyjmuje
- Z których BLoC'ów korzysta
- Jakie stany renderuje (if/else, hasMatches, isAdmin itp.)

### Krok 2: Zbadaj istniejący usecase (jeśli istnieje)

Sprawdź czy plik `<nazwa>_usecase.dart` już istnieje w `widgetbook/lib/usecases/groups/`.
Jeśli tak – zaktualizuj go zamiast tworzyć nowy.

### Krok 3: Stwórz/zaktualizuj plik usecase

Naming convention: `<snake_case_nazwa>_usecase.dart`

Struktura pliku:
```dart
// ── Fake data ──────────────────────────────────────────────────────────────────
// Stałe mockowane encje

// ── Fake repos/blocs ───────────────────────────────────────────────────────────
// _FakeAuthRepository, _buildFakeAuthBloc, _FakeGroupBloc

// ── Use-cases ──────────────────────────────────────────────────────────────────
final mojaPlanetComponent = WidgetbookComponent(
  name: 'NazwaStrony',
  useCases: [
    WidgetbookUseCase(name: 'Stan A – opis', builder: ...),
    WidgetbookUseCase(name: 'Stan B – opis', builder: ...),
    // ...
  ],
);
```

### Krok 4: Zarejestruj w directory

Dodaj import i wpis do odpowiedniego pliku `*_directory.dart`:
- Strony → `groups_pages_directory.dart`
- Widgety → `groups_widgets_directory.dart`

### Krok 5: Nie ruszaj main.dart

`main.dart` widgetbooka zmienia się rzadko – tylko jeśli dodajesz całkowicie nową sekcję (nowy WidgetbookFolder w `directories`).

## Mockowane dane wielokrotnego użytku

W każdym pliku usecase definiuj lokalne fake data:

```dart
const _adminUser = UserEntity(uid: 'admin_uid', email: 'admin@example.com', nickname: 'Mikołaj Admin');
const _annaUser = UserEntity(uid: 'user_anna', email: 'anna@example.com', nickname: 'Anna Kowalska');
const _piotrUser = UserEntity(uid: 'user_piotr', email: 'piotr@example.com', nickname: 'Piotr Nowak');
const _juliaUser = UserEntity(uid: 'user_julia', email: 'julia@example.com', nickname: 'Julia Wiśniewska');

final _fakeParticipants = [_adminUser, _annaUser, _piotrUser, _juliaUser];

final _fakeMatches = {
  'admin_uid': 'user_anna',
  'user_anna': 'user_piotr',
  'user_piotr': 'user_julia',
  'user_julia': 'admin_uid',
};
```

## Przykład kompletnego use-case'u dla strony z dwoma widokami (admin/user)

```dart
final detailsGroupAdminComponent = WidgetbookComponent(
  name: 'DetailsGroupAdmin',
  useCases: [
    WidgetbookUseCase(
      name: '① Admin – Recruiting (before draw)',
      builder: (context) { ... },
    ),
    WidgetbookUseCase(
      name: '② Admin – Drawn (pairs revealed)',
      builder: (context) { ... },
    ),
    WidgetbookUseCase(
      name: '③ User – Waiting Room (no matches)',
      builder: (context) { ... },
    ),
    WidgetbookUseCase(
      name: '④ User – Match Revealed',
      builder: (context) { ... },
    ),
  ],
);
```

## Numerowanie use-case'ów

Zawsze numeruj use-case'y używając emotikonów/cyfr żeby były posortowane w UI:
`①`, `②`, `③`, `④` lub `1.`, `2.`, `3.`
