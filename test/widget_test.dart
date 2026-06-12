// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:product/main.dart';

void main() {
  testWidgets('Smoke test - App runs and displays store name', (WidgetTester tester) async {
    // Setup temporary directory for Hive in test environment
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);

    final cartBox = await Hive.openBox('cart_box');
    final ordersBox = await Hive.openBox('orders_box');

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      cartBox: cartBox,
      ordersBox: ordersBox,
    ));

    // Verify that our app starts and displays the Store header.
    expect(find.text('NOVA STORE'), findsOneWidget);

    // Clean up
    await cartBox.close();
    await ordersBox.close();
    tempDir.deleteSync(recursive: true);
  });
}
