class GroupInvitation {
  final int id;
  final String inviteeId;
  final String inviterId;
  final int groupId;
  final bool status;
  final DateTime invitedAt;

  GroupInvitation({
    required this.id,
    required this.inviteeId,
    required this.inviterId,
    required this.groupId,
    required this.status,
    required this.invitedAt,
  });
}
