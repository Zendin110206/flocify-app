// Path: lib/features/onboarding/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/core/screens/main_screen.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      setState(() {});
    }
  }

  void _togglePasswordVisibility() {
    HapticFeedback.lightImpact();
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _handleLogin() async {
    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await ref
        .read(loginControllerProvider.notifier)
        .signIn(email, password);

    if (mounted && success) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;
    // Responsive breakpoints
    final isTablet = size.width >= 768;
    final maxWidth = isTablet ? 400.0 : double.infinity;

    // Enhanced color scheme
    const primaryColor = Color(0xFF2563EB);
    const secondaryColor = Color(0xFF3B82F6);
    const backgroundColor = Color(0xFFFAFBFC);
    const surfaceColor = Colors.white;
    const textPrimary = Color(0xFF0F172A);
    const textSecondary = Color(0xFF475569);
    const textTertiary = Color(0xFF94A3B8);

    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      if (next is AsyncError) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.2*255).round()),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    next.error.toString().replaceFirst("Exception: ", ""),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            elevation: 8,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState is AsyncLoading;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Center(
                      child: Container(
                        width: maxWidth,
                        padding: EdgeInsets.only(
                          left: isTablet ? 32.0 : 24.0,
                          right: isTablet ? 32.0 : 24.0,
                          top: isKeyboardVisible ? 16.0 : 24.0,
                          bottom: isKeyboardVisible ? 16.0 : 0.0,
                        ),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Header section
                                _buildHeader(
                                  context,
                                  isKeyboardVisible,
                                  primaryColor,
                                  textPrimary,
                                  textSecondary,
                                ),

                                SizedBox(height: isKeyboardVisible ? 32 : 40),

                                // Form section
                                _buildFormSection(
                                  isKeyboardVisible,
                                  surfaceColor,
                                  primaryColor,
                                  textPrimary,
                                  textSecondary,
                                  textTertiary,
                                ),

                                SizedBox(height: isKeyboardVisible ? 18 : 24),

                                // Login button
                                _buildLoginButton(
                                  isLoading,
                                  primaryColor,
                                  secondaryColor,
                                ),

                                if (!isKeyboardVisible) ...[
                                  const SizedBox(height: 28),
                                  _buildDividerWithText(textTertiary),
                                  const SizedBox(height: 20),
                                  _buildGoogleButton(
                                    surfaceColor,
                                    textSecondary,
                                  ),
                                  _buildSignupNavigation(
                                    context,
                                    primaryColor,
                                    textSecondary,
                                  ),
                                ],

                                SizedBox(height: isKeyboardVisible ? 16 : 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isKeyboardVisible,
    Color primaryColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Column(
      children: [
        // Back button and app icon row
        Row(
          children: [
            Hero(
              tag: 'back_button',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.06*255).round()),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF64748B),
                    size: 18,
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();

                    FocusScope.of(context).unfocus();
                    await Future.delayed(const Duration(milliseconds: 600));

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
            // const Spacer(),
            // if (!isKeyboardVisible)
            //   Hero(
            //     tag: 'app_logo',
            //     child: AnimatedContainer(
            //       duration: const Duration(milliseconds: 400),
            //       curve: Curves.easeInOut,
            //       width: 52,
            //       height: 52,
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //           colors: [primaryColor, const Color(0xFF1D4ED8)],
            //           begin: Alignment.topLeft,
            //           end: Alignment.bottomRight,
            //         ),
            //         borderRadius: BorderRadius.circular(16),
            //         boxShadow: [
            //           BoxShadow(
            //             color: primaryColor.withAlpha((0.2*255).round()5),
            //             blurRadius: 16,
            //             offset: const Offset(0, 6),
            //           ),
            //         ],
            //       ),
            //       child: const Icon(
            //         Icons.water_drop_rounded,
            //         color: Colors.white,
            //         size: 26,
            //       ),
            //     ),
            //   ),
          ],
        ),

        SizedBox(height: isKeyboardVisible ? 20 : 30),

        // Title and subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isKeyboardVisible ? 28 : 34,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  letterSpacing: -0.8,
                  height: 1.1,
                ),
                child: const Text('Selamat Datang'),
              ),

              const SizedBox(height: 8),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isKeyboardVisible ? 15 : 17,
                  color: textSecondary,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
                child: const Text(
                  'Masuk ke akun Anda untuk melanjutkan\nperjalanan akuakultur modern',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(
    bool isKeyboardVisible,
    Color surfaceColor,
    Color primaryColor,
    Color textPrimary,
    Color textSecondary,
    Color textTertiary,
  ) {
    return Column(
      children: [
        // Email field
        _buildTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          nextFocusNode: _passwordFocusNode,
          label: 'Alamat Email',
          hint: 'nama@contoh.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          surfaceColor: surfaceColor,
          primaryColor: primaryColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          textTertiary: textTertiary,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email wajib diisi';
            }
            if (!RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            ).hasMatch(value)) {
              return 'Format email tidak valid';
            }
            return null;
          },
        ),

        const SizedBox(height: 24),

        // Password field
        _buildTextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          label: 'Kata Sandi',
          hint: 'Masukkan kata sandi',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          surfaceColor: surfaceColor,
          primaryColor: primaryColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          textTertiary: textTertiary,
          suffixIcon: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                key: ValueKey(_obscurePassword),
                color: textTertiary,
                size: 20,
              ),
            ),
            onPressed: _togglePasswordVisibility,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kata sandi wajib diisi';
            }
            if (value.length < 6) {
              return 'Kata sandi minimal 6 karakter';
            }
            return null;
          },
          onSubmitted: (_) => _handleLogin(),
        ),
        // Forgot password
        if (!isKeyboardVisible)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // TODO: Implementasi Lupa Kata Sandi
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Lupa Kata Sandi?',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
    required Color surfaceColor,
    required Color primaryColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color textTertiary,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04*255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onFieldSubmitted:
            onSubmitted ??
            (nextFocusNode != null
                ? (_) => FocusScope.of(context).requestFocus(nextFocusNode)
                : null),
        style: TextStyle(
          fontSize: 16,
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(prefixIcon, color: textTertiary, size: 20),
          ),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffixIcon,
                )
              : null,
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: const Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: const Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          labelStyle: TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: textTertiary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          errorStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    bool isLoading,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Hero(
      tag: 'login_button',
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withAlpha((0.3*255).round()),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isLoading ? null : _handleLogin,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Masuk ke Akun',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithText(Color textTertiary) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  textTertiary.withAlpha((0.3*255).round()),
                  textTertiary.withAlpha((0.3*255).round()),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: textTertiary.withAlpha((0.2*255).round())),
            ),
            child: Text(
              'atau masuk dengan',
              style: TextStyle(
                color: textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  textTertiary.withAlpha((0.3*255).round()),
                  textTertiary.withAlpha((0.3*255).round()),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton(Color surfaceColor, Color textSecondary) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04*255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: Implementasi Login dengan Google
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: const DecorationImage(
                    // In real app, use proper Google logo asset
                    image: NetworkImage(
                      'https://developers.google.com/identity/images/g-logo.png',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Masuk dengan Google',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupNavigation(
    BuildContext context,
    Color primaryColor,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Belum punya akun? ',
            style: TextStyle(
              color: textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const SignupScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                          child: child,
                        );
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Daftar Sekarang',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
