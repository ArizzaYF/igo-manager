import 'package:flutter_test/flutter_test.dart';

import 'package:igo_manager/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const IgoManagerApp());
    expect(find.byType(IgoManagerApp), findsOneWidget);
  });
}
