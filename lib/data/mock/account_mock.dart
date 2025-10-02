// Mock data for account
import 'package:myapp/data/repositories/interfaces/i_account_service.dart';

final mockCurrentAccount = Account(
  accountId: 'user001',
  fullName: 'Mèo thần chết',
  email: 'meotthanchet@example.com',
  phone: '0912345678',
  birthDate: DateTime(1995, 6, 15),
  gender: 'Nữ',
  avatar: 'assets/images/user_avatar.jpg',
  createdAt: DateTime(2023, 1, 1),
  updatedAt: DateTime.now(),
);

final mockAccounts = [
  mockCurrentAccount,
  Account(
    accountId: 'user002',
    fullName: 'Nguyễn Văn A',
    email: 'nguyenvana@example.com',
    phone: '0987654321',
    birthDate: DateTime(1990, 3, 20),
    gender: 'Nam',
    avatar: 'assets/images/user2.jpg',
    createdAt: DateTime(2023, 2, 1),
    updatedAt: DateTime.now(),
  ),
  Account(
    accountId: 'user003',
    fullName: 'Trần Thị B',
    email: 'tranthib@example.com',
    phone: '0901234567',
    birthDate: DateTime(1992, 8, 10),
    gender: 'Nữ',
    avatar: 'assets/images/user3.jpg',
    createdAt: DateTime(2023, 3, 1),
    updatedAt: DateTime.now(),
  ),
];
