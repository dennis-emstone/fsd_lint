/// Feature Sliced Design의 레이어 정의
enum FsdLayer {
  app(0),
  pages(1),
  widgets(2),
  features(3),
  entities(4),
  shared(5);

  const FsdLayer(this.level);

  /// 레이어의 레벨 (낮을수록 상위 레이어)
  final int level;

  /// 파일 경로에서 레이어 추출
  static FsdLayer? fromPath(String path) {
    if (path.contains('/app/')) return FsdLayer.app;
    if (path.contains('/pages/')) return FsdLayer.pages;
    if (path.contains('/widgets/')) return FsdLayer.widgets;
    if (path.contains('/features/')) return FsdLayer.features;
    if (path.contains('/entities/')) return FsdLayer.entities;
    if (path.contains('/shared/')) return FsdLayer.shared;
    return null;
  }

  /// 다른 레이어를 import할 수 있는지 확인
  bool canImport(FsdLayer other) {
    // 같은 레이어는 항상 import 가능
    if (this == other) return true;
    // 하위 레이어(level이 큰)만 import 가능
    return other.level > level;
  }
}

/// Slice 정보를 담는 클래스
class FsdSlice {
  const FsdSlice({required this.layer, required this.name});

  final FsdLayer layer;
  final String name;

  /// 파일 경로에서 Slice 정보 추출
  /// 예: lib/features/server_add/server_add.dart -> FsdSlice(features, server_add)
  /// 예: lib/entities/user.dart -> FsdSlice(entities, user)
  static FsdSlice? fromPath(String path) {
    final layer = FsdLayer.fromPath(path);
    if (layer == null) return null;

    final layerName = layer.name;

    // Find the part of the path that comes after the layer name
    // This handles both '/layerName/sliceName/...' and '/layerName/sliceName.dart'
    final parts = path.split('/');
    final layerSegmentIndex = parts.indexOf(layerName);

    if (layerSegmentIndex != -1 && layerSegmentIndex + 1 < parts.length) {
      final nextSegment = parts[layerSegmentIndex + 1];
      // The slice name is the segment directly after the layer name,
      // stripping any file extension.
      final sliceName = nextSegment.split('.').first;
      if (sliceName.isEmpty) return null;
      return FsdSlice(layer: layer, name: sliceName);
    }

    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsdSlice &&
          runtimeType == other.runtimeType &&
          layer == other.layer &&
          name == other.name;

  @override
  int get hashCode => layer.hashCode ^ name.hashCode;

  @override
  String toString() => '$layer/$name';
}
