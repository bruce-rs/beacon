/// Base class for all models in the app.
///
/// All subclasses MUST implement:
/// ```dart
/// factory MyModel.fromJson(Map<String, dynamic> map) {
///   return MyModel(id: map['id'], ...);
/// }
/// ```
abstract class AppModel {
  const AppModel();

  Map<String, dynamic> toJson() => {};

  @override
  String toString() => toJson().toString();
}
