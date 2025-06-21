# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Comprehensive test suite with 99 test cases
- CI/CD pipeline with GitHub Actions
- Automated dependency management
- Version bump automation
- Code coverage reporting

### Changed

- Updated README with comprehensive documentation
- Improved CI/CD workflows
- Enhanced test coverage for validation logic

### Fixed

- Fixed whitespace handling in amount validation
- Updated deprecated GitHub Actions
- Improved error handling in workflows

## [1.0.0] - 2024-01-01

### Added

- Initial release of Expense Tracker App
- Clean Architecture implementation
- BLoC state management
- Local data persistence with Hive
- Real-time currency conversion
- Multi-platform support (Android, iOS, Web)
- Image attachment functionality
- Expense filtering and categorization
- Responsive UI design

### Features

- Add and track expenses with multiple currencies
- View real-time balance, income, and expense summaries
- Filter expenses by date range and categories
- Attach images to expense records
- Convert currencies automatically using live exchange rates
- Store data locally for offline access

### Technical Stack

- Flutter 3.32.4
- Dart 3.8.1
- Hive for local database
- Dio for HTTP requests
- flutter_bloc for state management
- GetIt for dependency injection
