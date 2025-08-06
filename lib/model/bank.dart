class Bank {
  final String id;
  final String accountId;
  final String bankProvider;
  final String bankAccountToken;
  final String last4Digit;
  final bool isConnected;

  Bank({
    required this.id,
    required this.accountId,
    required this.bankProvider,
    required this.bankAccountToken,
    required this.last4Digit,
    required this.isConnected,
  });
}