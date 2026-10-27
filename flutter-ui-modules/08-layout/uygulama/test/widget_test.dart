import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dayplanner/main.dart';
import 'package:dayplanner/providers/planner_provider.dart';

void main() {
  testWidgets('DayPlannerApp loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PlannerProvider(),
        child: const DayPlannerApp(),
      ),
    );

    // Verify app launches without throwing errors
    expect(find.byType(DayPlannerApp), findsOneWidget);
  });
}
