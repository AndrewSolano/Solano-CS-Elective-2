
import 'package:flutter_test/flutter_test.dart';
import 'package:myfluttersactivity/main.dart';

void main() {
  testWidgets('Dashboard renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ResponsiveAdaptiveApp());
    await tester.pumpAndSettle();

    expect(find.text('responsivedashboard'), findsOneWidget);
  });
}
