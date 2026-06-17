class BackupModel {
  final int version;
  final String app;
  final String createdAt;

  final Map<String, dynamic> data;

  const BackupModel({
    required this.version,
    required this.app,
    required this.createdAt,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'app': app,
      'created_at': createdAt,
      'data': data,
    };
  }
}
