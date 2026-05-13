import 'package:flutter_test/flutter_test.dart';
import 'package:level_up/app.dart';
import 'package:provider/provider.dart';
import 'package:level_up/providers/app_state.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const LevelUpApp(),
      ),
    );
    expect(find.byType(LevelUpApp), findsOneWidget);
  });
}