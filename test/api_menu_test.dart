import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


import 'package:watch_it/watch_it.dart';
import 'package:ipot/api/api.dart';

import 'package:ipot/state/services.dart';

void main() {
  late DioAdapter dioAdapter;
  // Must be the same as in .env file
  final baseUrl = 'http://192.168.1.2:3000';

  setUpAll(() async {
    configureDependencies();

    // Mock the .env file content
    dotenv.loadFromString(envString: 'API_URL=$baseUrl');


  });

  setUp(() {
    di.pushNewScope(); // Create test scope
    di.registerLazySingleton<ApiService>(()=>ApiService()); // Shadow with mock
    // Initialize the adapter to intercept calls from your global dio instance
    dioAdapter = DioAdapter(dio: di.get<ApiService>().dio);
  });

  tearDown(() async {
    await di.popScope(); // Restore real services
  });

  group('getMenu API Tests', () {
    const String tableId = 'T001';
    final String fullUrl = '$baseUrl/api/v1/menu'; // Ensure this matches your urls.dart definition
    test('returns Success<MenuResponse> on 200 status code', () async {
      final service = di.get<ApiService>();

      // 1. Mock the 200 response with your provided JSON
      dioAdapter.onGet(
        fullUrl,
            (server) => server.reply(200, mockJsonResponse),
        queryParameters: {'table_id': tableId},
      );

      // 2. Execute
      final result = await service.getMenu(tableId);

      // 3. Assert
      expect(result.isSuccess(), true);

      result.onSuccess((menu) {
        expect(menu.restaurant?.name, 'Sushi Zen');
        expect(menu.categories.length, 3);
        expect(menu.items.first.name, 'Edamame');
        // Test nested customization mapping
        expect(menu.items.first.customizationGroups.first.options.length, 3);
        expect(menu.items.first.customizationGroups.first.options[1].name, 'Truffle Salt');
      });
    });

    test('returns Failure with "Table not found" on 404', () async {
      final service = di.get<ApiService>();

      dioAdapter.onGet(
        fullUrl,
            (server) => server.reply(404, {'message': 'Not Found'}),
        queryParameters: {'table_id': 'invalid_id'},
      );

      final result = await service.getMenu('invalid_id');

      expect(result.isError(), true);
      result.onFailure((error) {
        expect(error.toString(), contains('Table not found'));
      });
    });

    test('returns Failure with Server error message on 500', () async {
      final service = di.get<ApiService>();

      dioAdapter.onGet(
        fullUrl,
            (server) => server.reply(500, null),
        queryParameters: {'table_id': tableId},
      );

      final result = await service.getMenu(tableId);

      expect(result.isError(), true);
      result.onFailure((error) {
        expect(error.toString(), contains('problem with our server'));
      });
    });

    test('returns default Failure on unexpected status codes', () async {
      final service = di.get<ApiService>();

      dioAdapter.onGet(
        fullUrl,
            (server) => server.reply(418, null),
        queryParameters: {'table_id': tableId},
      );

      final result = await service.getMenu(tableId);

      expect(result.isError(), true);
      result.onFailure((error) {
        expect(error.toString(), contains('Oops! Something went wrong'));
      });
    });
  });
}

// Helper for the large JSON string
final mockJsonResponse = {
  "restaurant": {
    "id": "R001",
    "name": "Sushi Zen",
    "table_id": "T001"
  },
  "categories": [
    {
      "id": 1,
      "name": "Appetizers",
      "sort_order": 1
    },
    {
      "id": 2,
      "name": "Main Course",
      "sort_order": 2
    },
    {
      "id": 3,
      "name": "Drinks",
      "sort_order": 3
    }
  ],
  "items": [
    {
      "id": 1,
      "name": "Edamame",
      "description": "Steamed soybeans with sea salt",
      "price": 5.99,
      "category_id": 1,
      "image_url": null,
      "customization_groups": [
        {
          "id": 1,
          "name": "Seasoning",
          "required": false,
          "max_selections": 2,
          "options": [
            { "id": 1, "name": "Sea Salt", "price_modifier": 0 },
            { "id": 2, "name": "Truffle Salt", "price_modifier": 1.50 },
            { "id": 3, "name": "Chili Flakes", "price_modifier": 0.50 }
          ]
        }
      ]
    },
    {
      "id": 2,
      "name": "Salmon Sashimi",
      "description": "Fresh Norwegian salmon, 8 pieces",
      "price": 16.99,
      "category_id": 2,
      "image_url": null,
      "customization_groups": [
        {
          "id": 2,
          "name": "Size",
          "required": true,
          "max_selections": 1,
          "options": [
            { "id": 4, "name": "Regular (8pc)", "price_modifier": 0 },
            { "id": 5, "name": "Large (12pc)", "price_modifier": 8.00 }
          ]
        }
      ]
    },
    {
      "id": 3,
      "name": "Green Tea",
      "description": "Hot Japanese green tea",
      "price": 3.50,
      "category_id": 3,
      "image_url": null,
      "customization_groups": []
    },
    {
      "id": 4,
      "name": "Chicken Ramen",
      "description": "Rich chicken broth with chashu, egg, and noodles",
      "price": 14.99,
      "category_id": 2,
      "image_url": null,
      "customization_groups": [
        {
          "id": 3,
          "name": "Spice Level",
          "required": true,
          "max_selections": 1,
          "options": [
            { "id": 6, "name": "Mild", "price_modifier": 0 },
            { "id": 7, "name": "Medium", "price_modifier": 0 },
            { "id": 8, "name": "Spicy", "price_modifier": 0 },
            { "id": 9, "name": "Extra Spicy", "price_modifier": 1.00 }
          ]
        },
        {
          "id": 4,
          "name": "Add-ons",
          "required": false,
          "max_selections": 3,
          "options": [
            { "id": 10, "name": "Extra Egg", "price_modifier": 2.00 },
            { "id": 11, "name": "Extra Chashu", "price_modifier": 4.00 },
            { "id": 12, "name": "Corn", "price_modifier": 1.00 }
          ]
        }
      ]
    }
  ]
};