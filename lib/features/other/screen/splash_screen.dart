import 'package:flutter/material.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/service/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthAndNavigate();
  }

  void _initializeAnimations() {
    // Single controller cho tất cả animations - tối ưu performance
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Logo animations - bắt đầu ngay lập tức
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Text animations - sau logo
    _textSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    // Progress animation - cuối cùng
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    // Bắt đầu animation
    _animationController.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Initialize auth service song song với animation
      await AuthService().initialize();

      // Đợi animation hoàn thành (ít nhất 2.5 giây)
      await _animationController.forward().orCancel;

      // Thêm delay ngắn để user nhìn thấy hoàn chỉnh
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigation với animation smooth
      if (AuthService().isAuthenticated) {
        // If authenticated, follow the normal post-login navigation
        NavigateHelper.navigateAfterLogin(context);
      } else {
        // Allow unauthenticated users to browse Home/products first
        NavigateHelper.goToHome(context);
      }
    } catch (e) {
      // Fallback nếu có lỗi - let user browse home
      if (mounted) {
        NavigateHelper.goToHome(context);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              _buildAnimatedLogo(),

              const SizedBox(height: 50),

              // Animated Text
              _buildAnimatedText(),

              const SizedBox(height: 80),

              // Animated Progress
              _buildAnimatedProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _logoRotationAnimation.value * 2 * 3.14159, // Full rotation
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Opacity(
              opacity: _logoFadeAnimation.value,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 15),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pets,
                  size: 90,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _textSlideAnimation.value),
          child: Opacity(
            opacity: _textFadeAnimation.value,
            child: Column(
              children: [
                // App Name với gradient text effect
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Colors.white70],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Text(
                    'CareNest',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Tagline
                const Text(
                  'Chăm sóc thú cưng với tình yêu',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                // Version or additional info
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedProgress() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _progressAnimation.value,
          child: Column(
            children: [
              // Custom progress indicator
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Loading text
              Text(
                'Đang khởi tạo...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
