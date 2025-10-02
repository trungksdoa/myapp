// Interface for Account Service
class Account {
  final String accountId;
  final String fullName;
  final String email;
  final String? phone;
  final DateTime? birthDate;
  final String? gender;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Account({
    required this.accountId,
    required this.fullName,
    required this.email,
    this.phone,
    this.birthDate,
    this.gender,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });
}

abstract class IAccountService {
  /// Get current user profile
  Future<Account> getCurrentProfile();

  /// Update user profile
  Future<Account> updateProfile(Account account);

  /// Change password
  Future<void> changePassword(String oldPassword, String newPassword);

  /// Update avatar
  Future<String> updateAvatar(String imagePath);

  /// Get account by ID
  Future<Account?> getAccountById(String accountId);
}
