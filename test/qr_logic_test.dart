import 'package:flutter_test/flutter_test.dart';
import 'package:ipot/main.dart';

void main() {
  group('QR Logic Tests', () {
    test('Should return menu_display for valid table URLs', () {
      expect(getRouteForQr('ipot://table/5'), 'menu_display');
    });

    test('Should return wrong_qr for any other string', () {
      expect(getRouteForQr('https://google.com'), 'wrong_qr');
      expect(getRouteForQr(''), 'wrong_qr');
    });
  });
}