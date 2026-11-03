import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:et/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExpenseTrackerApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Expense Tracker title is shown
    expect(find.text('Expense Tracker'), findsOneWidget);
    // Verify FAB is present
    expect(find.text('Add Transaction'), findsOneWidget);
  });
}
