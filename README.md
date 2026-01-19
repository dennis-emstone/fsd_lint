# Lint rules for FSD

[한국어 버전 (Korean Version)](./README_ko.md)

A custom lint rules package for the Feature Sliced Design (FSD) architecture.

## Rules List

### 1. `fsd_layer_import` (ERROR)

**Purpose**: Enforce the FSD layer hierarchy.

**Rule**: 
- Upper layers can only import from lower layers.
- An error occurs if a lower layer attempts to import from an upper layer.

**Layer Hierarchy** (Top → Bottom):
```
app > pages > widgets > features > entities > shared
```

**Examples**:
```dart
// ✅ Allowed: 'pages' imports from 'entities' (lower layer)
// lib/pages/server_list/server_list.dart
import 'package:example/entities/server/server.dart';

// ❌ Error: 'entities' imports from 'pages' (upper layer)
// lib/entities/server/server.dart
import 'package:example/pages/server_list/server_list.dart';
```

### 2. `fsd_slice_import` (ERROR)

**Purpose**: Prevent direct dependencies between slices within the same layer.

**Rule**:
- Direct imports between different slices in the same layer are not allowed.

**Example**:
```dart
// ❌ Error: Direct import of another slice within the 'features' layer
// lib/features/server_add/server_add.dart
import 'package:example/features/server_list/server_list.dart';
```

## Installation

### 1. Project Structure

```
your_project/
├── lib/
│   ├── app/
│   ├── pages/
│   ├── widgets/
│   ├── features/
│   ├── entities/
│   └── shared/
├── analysis_options.yaml
└── pubspec.yaml
```

### 2. pubspec.yaml Configuration

Add to your main project's `pubspec.yaml`:

```yaml
dev_dependencies:
  custom_lint: ^0.8.1
  fsd_lint: ^0.1.0
```

### 3. analysis_options.yaml Configuration

```yaml
analyzer:
  plugins:
    - custom_lint
```

### 4. Install Dependencies

```bash
flutter pub get
```

## Usage

### Running the Lint

```bash
# Run all lint rules
dart run custom_lint

# Run in watch mode (auto-refresh on file changes)
dart run custom_lint --watch
```

### IDE Integration

Most IDEs (VS Code, Android Studio, etc.) will automatically recognize `custom_lint` configured in `analysis_options.yaml` and display lint warnings/errors in real-time.

## FSD Architecture Guide

### Role of Each Layer

- **app**: App-wide settings (routing, themes, etc.)
- **pages**: Full screens/pages
- **widgets**: Reusable UI components
- **features**: Business logic units
- **entities**: Business entities/models
- **shared**: Shared utilities, API clients, etc.

### Dependency Rules

1. **Downward Dependencies Only**: Upper layer → Lower layer
2. **Isolation within Layers**: Slices within the same layer should not depend on each other directly.

## Development

### Adding New Rules

1. Create a new lint file in the `lib/src/lints/` directory.
2. Write a class inheriting from `DartLintRule`.
3. Add it to `getLintRules` in `lib/fsd_lint.dart`.

## License

MIT
