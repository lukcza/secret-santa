import 'package:flutter/material.dart';
import 'package:secret_santa/features/home/presentation/pages/create_or_join_page.dart';
import 'package:widgetbook/widgetbook.dart';

// ── Helper ─────────────────────────────────────────────────────────────────────

/// CreateOrJoinPage używa context.push() z GoRouter.
/// W Widgetbooku nie ma GoRouter, więc wrapujemy w Navigator żeby
/// przyciski nie crashowały (onTap jest w DecisionCard, ale pop/push
/// biegnie przez MaterialPageRoute).
Widget _wrap(Widget child) => Navigator(
  onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
);

// ── Use-cases ──────────────────────────────────────────────────────────────────

final createOrJoinPageComponent = WidgetbookComponent(
  name: 'CreateOrJoinPage',
  useCases: [
    WidgetbookUseCase(
      name: '① Default – wybór akcji',
      builder:
          (context) => _wrap(const CreateOrJoinPage()),
    ),

    WidgetbookUseCase(
      name: '② Szeroki ekran (tablet)',
      builder:
          (context) => _wrap(
            const MediaQuery(
              data: MediaQueryData(size: Size(768, 1024)),
              child: CreateOrJoinPage(),
            ),
          ),
    ),

    WidgetbookUseCase(
      name: '③ Wąski ekran (SE)',
      builder:
          (context) => _wrap(
            const MediaQuery(
              data: MediaQueryData(size: Size(320, 568)),
              child: CreateOrJoinPage(),
            ),
          ),
    ),

    WidgetbookUseCase(
      name: '④ Duży tekst (accessibility)',
      builder:
          (context) => _wrap(
            MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.5)),
              child: const CreateOrJoinPage(),
            ),
          ),
    ),
  ],
);
