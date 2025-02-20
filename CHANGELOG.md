# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
-   New feature: Geo-spatial anomaly detection capabilities using Biquery functions.
-   Added the ability to capture custom events with the `captureEvent` method.
-   Added the ability to create generic database to include other events other than `SaleEvent`.

### Changed
-   Refactored database operations into `EventDatabaseHelper` class.
-   Refactored _captureSaleEvent` to accept parameters instead of objects.
-   Increased the batch size for sending events to the API to 50.

### Deprecated

### Removed

### Fixed
-   Fixed a bug where events were not being properly deleted from the local database after being sent to the API.
-   Location services now gracefully handle when location permissions are denied
### Security

## [1.1.0] - 2023-10-27

### Added

-   Added a helper function to retrieve the apiKey from a path.
-   Added new parameter to the SaleEvents such as the couponCode

### Changed

-   Refactored the captureSaleEvent` function to use `Product` objects instead of individual parameters.
-   Used the `device_info_plus` to gather device model, make, OS version (Android, iOS, Web).
-   Used `getCurrentPosition` from geolocator to retrieve the current location of the device.
-   Replaced `List<Product>` with `events` as parameter to send sales Events to bigquery in batch to.

### Deprecated

### Removed

### Fixed
-   Fixes session Id in `SaleEvent.fromMap` method.

### Security

## [1.0.0] - 2023-10-26

### Added

-   Initial release of the Mapospace Flutter SDK.
-   Provides functionality to capture sale events and store them locally.
-   Includes mechanism for sending events to a remote API in batches.
-   Supports API key-based authentication.
-   Stores the `apiKey` ,`deviceId`, `sessionID`, `deviceSpecs` and `useragent`
### Changed

### Deprecated

### Removed

### Fixed

### Security