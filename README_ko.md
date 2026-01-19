# Lint rules for FSD

Feature Sliced Design(FSD) 아키텍처를 위한 커스텀 lint 규칙 패키지입니다.

## 규칙 목록

### 1. `fsd_layer_import` (ERROR)

**목적**: FSD 레이어 계층 구조를 강제합니다.

**규칙**: 
- 상위 레이어는 하위 레이어만 import할 수 있습니다
- 하위 레이어가 상위 레이어를 import하면 에러가 발생합니다

**레이어 계층 구조** (상위 → 하위):
```
app > pages > widgets > features > entities > shared
```

// ✅ 허용: pages가 하위 레이어인 entities를 import
// lib/pages/server_list/server_list.dart
import 'package:example/entities/server/server.dart';

// ❌ 에러: entities가 상위 레이어인 pages를 import
// lib/entities/server/server.dart
import 'package:example/pages/server_list/server_list.dart';

### 2. `fsd_slice_import` (ERROR)

**목적**: 같은 레이어 내 slice 간 직접 의존성을 방지합니다.

**규칙**:
- 같은 레이어의 다른 slice를 직접 import할 수 없습니다

**예시**:
```dart
// ❌ 에러: features 레이어 내 다른 slice 직접 import
// lib/features/server_add/server_add.dart
import 'package:example/features/server_list/server_list.dart';
```

## 설치 방법

### 1. 프로젝트 구조

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

### 2. pubspec.yaml 설정

메인 프로젝트의 `pubspec.yaml`에 추가:

```yaml
dev_dependencies:
  custom_lint: ^0.8.1
  fsd_lint: ^0.1.0
```

### 3. analysis_options.yaml 설정

```yaml
analyzer:
  plugins:
    - custom_lint
```

### 4. 의존성 설치

```bash
flutter pub get
```

## 사용 방법

### Lint 실행

```bash
# 모든 lint 규칙 실행
dart run custom_lint

# watch 모드로 실행 (파일 변경 시 자동 실행)
dart run custom_lint --watch
```

### IDE 통합

대부분의 IDE(VS Code, Android Studio 등)는 `analysis_options.yaml`에 설정된 custom_lint를 자동으로 인식하여 실시간으로 lint 경고/에러를 표시합니다.

## FSD 아키텍처 가이드

### 레이어별 역할

- **app**: 앱 전체 설정 (라우팅, 테마 등)
- **pages**: 전체 화면/페이지
- **widgets**: 재사용 가능한 UI 컴포넌트
- **features**: 비즈니스 기능 단위
- **entities**: 비즈니스 엔티티/모델
- **shared**: 공유 유틸리티, API 클라이언트 등

### 의존성 규칙

1. **하향 의존성만 허용**: 상위 레이어 → 하위 레이어
2. **같은 레이어 내 격리**: 같은 레이어의 slice끼리는 직접 의존하지 않음

## 개발

### 새로운 규칙 추가

1. `lib/src/lints/` 디렉토리에 새 lint 파일 생성
2. `DartLintRule`을 상속하는 클래스 작성
3. `lib/fsd_lint.dart`의 `getLintRules`에 추가

## 라이선스

MIT
