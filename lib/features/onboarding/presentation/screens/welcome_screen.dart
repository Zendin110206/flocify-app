// lib/features/onboarding/presentation/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Force hide keyboard when screen loads
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Handle keyboard visibility changes
    super.didChangeMetrics();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;

    // Modern color scheme
    const Color primaryColor = Color(0xFF1E88E5); // Light blue matching splash
    const Color backgroundColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        // Dismiss keyboard when tapping outside
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Container(
            width: size.width,
            height: size.height - MediaQuery.of(context).padding.top,
            child: Stack(
              children: [
                // Main content - fixed position, no scroll
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: isKeyboardVisible ? 16.0 : 40.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Hero section - adapts when keyboard appears
                        Flexible(
                          flex: isKeyboardVisible ? 2 : 3,
                          child: _buildHeroSection(isKeyboardVisible),
                        ),

                        // Action section - always visible
                        _buildActionSection(context, primaryColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isKeyboardVisible) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App icon with improved design matching your screenshot
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isKeyboardVisible ? 80 : 120,
          height: isKeyboardVisible ? 80 : 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E88E5), // Light blue
                Color(0xFF1976D2), // Slightly darker blue
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E88E5).withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: const Color(0xFF1E88E5).withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.water_drop_rounded,
            size: isKeyboardVisible ? 40 : 60,
            color: Colors.white,
          ),
        ),

        SizedBox(height: isKeyboardVisible ? 24 : 40),

        // App title
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: isKeyboardVisible ? 28 : 36,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
          child: const Text('Flocify'),
        ),

        SizedBox(height: isKeyboardVisible ? 8 : 16),

        // Subtitle
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: isKeyboardVisible ? 16 : 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            letterSpacing: 0.1,
          ),
          child: const Text('Solusi Cerdas Akuakultur Modern'),
        ),

        if (!isKeyboardVisible) ...[
          const SizedBox(height: 16),

          // Description - hide when keyboard visible
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isKeyboardVisible ? 0 : 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: const Text(
                'Tingkatkan produktivitas dan\nkeuntungan dengan teknologi terdepan\nuntuk budidaya ikan modern',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF94A3B8),
                  height: 1.5,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionSection(BuildContext context, Color primaryColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary button (Login) - improved design
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                // Ensure keyboard is hidden before navigation
                FocusScope.of(context).unfocus();
                await Future.delayed(const Duration(milliseconds: 100));

                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
              child: const Center(
                child: Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Secondary button (Register)
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryColor.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                // Ensure keyboard is hidden before navigation
                FocusScope.of(context).unfocus();
                await Future.delayed(const Duration(milliseconds: 100));

                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                }
              },
              child: Center(
                child: Text(
                  'Daftar Sekarang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Terms and privacy with clickable links
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
                height: 1.4,
                letterSpacing: 0.1,
              ),
              children: [
                const TextSpan(text: 'Dengan melanjutkan, Anda menyetujui '),
                TextSpan(
                  text: 'Syarat &\nKetentuan',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                const TextSpan(text: ' dan '),
                TextSpan(
                  text: 'Kebijakan Privasi',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                const TextSpan(text: ' kami'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
