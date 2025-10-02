// Account Service Implementation (Mock)
import 'package:myapp/data/repositories/interfaces/i_account_service.dart';
import 'package:myapp/data/mock/account_mock.dart';

class AccountService implements IAccountService {
  // TODO: Replace with actual API calls when backend is ready
  // Currently using mock data

  @override
  Future<Account> getCurrentProfile() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/account/profile');
    // return Account.fromJson(response.data);

    return mockCurrentAccount;
  }

  @override
  Future<Account> updateProfile(Account account) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.put('/api/account/profile', data: account.toJson());
    // return Account.fromJson(response.data);

    // Update mock data
    final index = mockAccounts.indexWhere(
      (a) => a.accountId == account.accountId,
    );
    if (index != -1) {
      final updatedAccount = Account(
        accountId: account.accountId,
        fullName: account.fullName,
        email: account.email,
        phone: account.phone,
        birthDate: account.birthDate,
        gender: account.gender,
        avatar: account.avatar,
        createdAt: account.createdAt,
        updatedAt: DateTime.now(),
      );
      mockAccounts[index] = updatedAccount;
      return updatedAccount;
    }
    throw Exception('Account not found');
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // TODO: Replace with actual API call
    // Example: await httpClient.post('/api/account/change-password',
    //   data: {'oldPassword': oldPassword, 'newPassword': newPassword});

    // Mock validation
    if (oldPassword != 'currentPassword') {
      throw Exception('Mật khẩu hiện tại không đúng');
    }
    if (newPassword.length < 6) {
      throw Exception('Mật khẩu mới phải có ít nhất 6 ký tự');
    }

    // In real implementation, password would be updated in database
  }

  @override
  Future<String> updateAvatar(String imagePath) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // TODO: Replace with actual API call for image upload
    // Example: final response = await httpClient.post('/api/account/avatar',
    //   data: FormData.fromMap({'file': await MultipartFile.fromFile(imagePath)}));
    // return response.data['avatarUrl'];

    // Mock uploaded avatar URL
    final newAvatarUrl = 'assets/images/user_avatar_updated.jpg';

    // Update current account avatar
    final index = mockAccounts.indexWhere(
      (a) => a.accountId == mockCurrentAccount.accountId,
    );
    if (index != -1) {
      mockAccounts[index] = Account(
        accountId: mockCurrentAccount.accountId,
        fullName: mockCurrentAccount.fullName,
        email: mockCurrentAccount.email,
        phone: mockCurrentAccount.phone,
        birthDate: mockCurrentAccount.birthDate,
        gender: mockCurrentAccount.gender,
        avatar: newAvatarUrl,
        createdAt: mockCurrentAccount.createdAt,
        updatedAt: DateTime.now(),
      );
    }

    return newAvatarUrl;
  }

  @override
  Future<Account?> getAccountById(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/accounts/$accountId');
    // return Account.fromJson(response.data);

    try {
      return mockAccounts.firstWhere(
        (account) => account.accountId == accountId,
      );
    } catch (e) {
      return null;
    }
  }
}
