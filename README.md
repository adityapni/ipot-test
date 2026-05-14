# ipot

IPOT test project.

## Getting Started

A Customer QR Ordering mobile app.
This is the core customer-facing flow: 
1. scan QR
2. browse menu
3. add items to cart
4. submit order  
5. track status.

A working apk is here: https://drive.google.com/drive/folders/1fCferdWD9vK5icOrPolMAO1OijcSRSfK?usp=sharing
To use this apk, you need to change your server ip to be the same as in .env file.
Otherwise, change the ip in .env file and run the app.

## Running 
- To change API base url, replace API_URL in .env file.
- Run `flutter pub get` to install dependencies.
- Run `flutter run` to start the app.

## Architecture
Follows folder structure as in the assignment:

src/
├── api/            # API client & endpoints
├── components/     # Reusable UI components
├── screens/        # Screen-level components
├── navigation/     # Navigation configuration
├── state/          # State management (store, slices)
├── models/         # Type definitions / data models
└── utils/          # Helpers, formatters

State management library: watch_it
API library: dio
Navigation library: go_router

## Testing
To run api_menu_test.dart, ensure baseUrl is the same as API_URL in .env file.