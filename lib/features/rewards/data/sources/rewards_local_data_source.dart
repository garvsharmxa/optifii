class RewardsLocalDataSource {
  Future<void> saveVoucherToSecureStorage(String cardNum, String pin) async {
    // Simulating secure storage write
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<Map<String, String>?> getSecuredVoucher(String key) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return null;
  }
}
