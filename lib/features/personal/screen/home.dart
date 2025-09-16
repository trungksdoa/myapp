import 'package:flutter/material.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/widgets/common/custom_elevated_button.dart';

class PersonalHomeWidget extends StatelessWidget {
  const PersonalHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User greeting section
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
              ),
              const SizedBox(width: 12),
              const Text(
                'Mèo thần chết',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Menu grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMenuItem(
                  icon: Icons.shopping_bag,
                  title: 'Đơn hàng',
                  onTap: () => _navigateToOrders(context),
                ),
                _buildMenuItem(
                  icon: Icons.calendar_today,
                  title: 'Cuộc hẹn',
                  onTap: () => _navigateToAppointments(context),
                ),
                _buildMenuItem(
                  icon: Icons.article,
                  title: 'Bài viết',
                  onTap: () => _navigateToPosts(context),
                ),
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'Tài khoản',
                  onTap: () => _navigateToAccount(context),
                ),
                _buildMenuItem(
                  icon: Icons.pets,
                  title: 'Gói dịch vụ',
                  onTap: () => _navigateToServices(context),
                ),
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: 'Thú cưng',
                  onTap: () => _navigateToPets(context),
                ),
                _buildMenuItem(
                  icon: Icons.notifications,
                  title: 'Thông báo',
                  onTap: () => _navigateToNotifications(context),
                ),
                _buildMenuItem(
                  icon: Icons.assessment,
                  title: 'Báo cáo',
                  onTap: () => _navigateToReports(context),
                ),
              ],
            ),
          ),

          // Logout button
          CustomElevatedButton(
            text: 'Đăng xuất',
            onPressed: () => _logout(context),
            backgroundColor: Colors.red,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF4A9B8E)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOrders(BuildContext context) {
    NavigateHelper.goToPersonalOrders(context);
  }

  void _navigateToAppointments(BuildContext context) {
    NavigateHelper.goToAppointmentBooking(context);
  }

  void _navigateToPosts(BuildContext context) {
    // Navigate to family blog or posts section
    NavigateHelper.goToFamilyBlog(context);
  }

  void _navigateToAccount(BuildContext context) {
    NavigateHelper.goToAccountProfile(context);
  }

  void _navigateToServices(BuildContext context) {
    NavigateHelper.goToServicesPackage(context);
  }

  void _navigateToPets(BuildContext context) {
    NavigateHelper.goToPetList(context);
  }

  void _navigateToNotifications(BuildContext context) {
    NavigateHelper.goToNotifications(context);
  }

  void _navigateToReports(BuildContext context) {
    // Navigate to reports/analytics screen
    // NavigateHelper.goToReports(context); // Method chưa có, có thể thêm sau
  }

  void _logout(BuildContext context) {
    // Create NavigateHelper instance for non-static methods
    final navigateHelper = NavigateHelper();
    navigateHelper.logoutAndNavigateToLogin(context);
  }
}
