class Report {
  final String id;
  final String reportedId;
  final String groupId;
  final String reportType;
  final String description;
  final String status;

  Report({
    required this.id,
    required this.reportedId,
    required this.groupId,
    required this.reportType,
    required this.description,
    required this.status,
  });
}