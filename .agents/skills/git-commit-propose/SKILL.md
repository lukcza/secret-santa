---
name: git-commit-propose
description: >-
  Analizuje zmiany w kodzie i proponuje nazwę brancha oraz wiadomość commita. NIE wykonuje żadnych komend automatycznie — wyświetla gotowe polecenia do samodzielnego uruchomienia przez użytkownika. Używaj zamiast git-branch-commit-push gdy chcesz uniknąć zawieszeń w terminalu.
---

# Git Commit Propose — Skill

## Cel
Przeanalizuj zmiany w repozytorium i zaproponuj:
- Nazwę gałęzi (branch) w stylu Conventional Commits
- Krótką wiadomość commita (do 50 znaków)
- Długą wiadomość commita z bulletami

Następnie wyświetl gotowe komendy git do skopiowania — **nie uruchamiaj ich samodzielnie**.

---

## WAŻNE: Zasady działania

- NIGDY nie uruchamiaj komend git przez terminal / PowerShell / run_command
- Analizuj zmiany przez narzędzia do odczytu plików: grep_search, view_file, list_dir
- Wyświetl gotowe komendy — użytkownik sam je uruchomi
- Jeśli musisz sprawdzić status przez skrypt helper, ustaw WaitMsBeforeAsync=8000 i nie czekaj na wynik — po 8 sekundach kontynuuj bez niego

---

## Workflow krok po kroku

### Krok 1: Odczytaj ścieżkę repozytorium

Ustal katalog główny repozytorium na podstawie kontekstu użytkownika (aktywne pliki, workspace).
Domyślnie dla tego projektu: `c:\Users\lukcz\Desktop\secret-santa\secret-santa`

### Krok 2: Zbierz informacje o zmianach

Priorytet 1 — Przejrzyj aktywne pliki użytkownika i historię rozmowy:
- Jakie pliki są aktualnie otwarte?
- Co było ostatnio modyfikowane w tej rozmowie?
- Czy są widoczne zmiany w plikach Dart, ARB, widgetbook?

Priorytet 2 — Użyj skryptu helper TYLKO do odczytu, jeśli potrzeba dokładniejszego diff:
```
uv run C:\Users\lukcz\.gemini\config\plugins\science\skills\git_branch_commit_push\scripts\git_helper.py status --cwd <REPO_PATH> --output <OUTPUT_JSON>
```
Ustaw WaitMsBeforeAsync=8000. Jeśli skrypt nie wróci — kontynuuj bez niego, bazując na kontekście.

### Krok 3: Przeanalizuj zmiany

Na podstawie zebranych danych:

1. **Kategoryzuj typ zmian**:
   - `feature/` → nowe funkcjonalności, nowe ekrany, nowe widgety
   - `fix/` lub `bugfix/` → poprawki błędów
   - `chore/` → refactoring, lokalizacja, konfiguracja, zależności
   - `docs/` → tylko dokumentacja

2. **Określ zakres** (scope): nazwa feature'a lub modułu, np. `groups`, `auth`, `l10n`

3. **Zaproponuj nazwę brancha**: `<kategoria>/<scope>-<opis-kebab-case>`
   - Przykład: `chore/groups-l10n-strings`
   - Przykład: `feature/groups-match-tile-ui`

4. **Zaproponuj krótką wiadomość commita** (do 50 znaków):
   - Format: `<typ>(<scope>): <opis>`
   - Przykład: `chore(l10n): localize groups presentation strings`

5. **Zaproponuj długą wiadomość commita**:
   - Pierwsza linia = krótka wiadomość
   - Pusta linia
   - Bullet points z opisem zmian

### Krok 4: Wyświetl propozycje i gotowe komendy

Przedstaw wynik w tym formacie:

---

## Propozycja git commit

**Branch:** `<nazwa-brancha>`

**Krótki commit:** `<krótka-wiadomość>`

**Długi commit:**
```
<krótka-wiadomość>

- <bullet 1>
- <bullet 2>
```

---

### Gotowe komendy (skopiuj i uruchom w terminalu):

```powershell
git add .
git checkout -b <nazwa-brancha>
git commit -m "<krótka-wiadomość>" -m "<długa-wiadomość-body>"
git push -u origin <nazwa-brancha>
```

> Czy zatwierdzasz te propozycje, czy chcesz coś zmienić?

---

### Krok 5: Modyfikacje na żądanie

Jeśli użytkownik chce zmiany — dostosuj i wyświetl zaktualizowane komendy.
Nie uruchamiaj żadnych komend automatycznie.

---

## Konwencje nazewnictwa (dla tego projektu)

| Typ zmiany | Branch prefix | Commit prefix |
|---|---|---|
| Nowy widget / ekran | `feature/` | `feat(scope):` |
| Poprawka buga | `fix/` | `fix(scope):` |
| Lokalizacja (l10n) | `chore/` | `chore(l10n):` |
| Refactoring | `chore/` | `refactor(scope):` |
| Konfiguracja / deps | `chore/` | `chore(config):` |
| Widgetbook | `chore/` | `chore(widgetbook):` |

## Przykłady dla tego projektu (secret-santa)

```
feature/groups-reveal-animation     → feat(groups): add reveal animation to match tile
fix/groups-bloc-null-check          → fix(groups): handle null group in bloc state  
chore/l10n-groups-strings           → chore(l10n): localize hardcoded strings in groups feature
chore/widgetbook-confirm-button     → chore(widgetbook): add confirm button widget story
```
