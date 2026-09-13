// A small smoke test: it opens the app and taps the first product.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_market/main.dart';

void main() {
  testWidgets('tapping a product opens its detail screen', (tester) async {
    await tester.pumpWidget(const MiniMarketApp());

    // The home screen shows the products.
    expect(find.text('Mini Market'), findsOneWidget);
    expect(find.text('Phone X'), findsOneWidget);

    // Tapping a product opens the detail screen with the "Add to cart" button.
    await tester.tap(find.text('Phone X'));
    await tester.pumpAndSettle();

    expect(find.text('Add to cart'), findsOneWidget);
  });

  testWidgets('the add form shows errors for empty input', (tester) async {
    await tester.pumpWidget(const MiniMarketApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save product'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a title'), findsOneWidget);
    expect(find.text('Enter a price'), findsOneWidget);
  });
}
