# Example Project for FSD Lint

This project serves as a test case suite for verifying the `fsd_lint` rules.

## Structure

It follows a standard FSD structure:
- `app`
- `pages`
- `features`
- `entities`
- `shared`

## Test Cases

### Valid Imports
- `lib/features/login/login_flow.dart`: Imports `entities` (Higher -> Lower).
- `lib/pages/home/home_page.dart`: Imports `features` (Higher -> Lower).

### Invalid Imports (Should trigger lints)
- `lib/entities/user/bad_layer_import.dart`: Imports `features` (Lower -> Higher hierarchy violation).
  - Triggers: `fsd_layer_import`
- `lib/features/login/bad_slice_import.dart`: Imports another feature slice directly.
  - Triggers: `fsd_slice_import`

## Usage

Run the lint check manually:

```bash
dart run custom_lint
```
