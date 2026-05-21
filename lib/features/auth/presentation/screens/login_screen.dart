// lib/features/auth/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/providers/language_provider.dart';
import '../providers/admin_auth_provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  static const String _testEmail = 'test@medilevel.com';
  static const String _testPassword = 'password123';

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Route by account type from a single login form.
    if (email.toLowerCase() == AdminAuthProvider.adminRegistrationEmail) {
      final adminAuthProvider = context.read<AdminAuthProvider>();
      final isAdmin = await adminAuthProvider.loginAdmin(email, password);

      if (!mounted) return;

      if (isAdmin) {
        Navigator.of(context).pushReplacementNamed('/admin_dashboard');
      } else {
        setState(() {
          _errorMessage = adminAuthProvider.errorMessage ?? 'Email ou mot de passe incorrect';
          _isLoading = false;
        });
      }
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final isValid = await authProvider.loginUser(
      email: email,
      password: password,
    );
    
    if (!mounted) return;
    
    if (isValid) {
      Navigator.of(context).pushReplacementNamed('/patient_id');
    } else {
      setState(() {
        _errorMessage = 'Email ou mot de passe incorrect';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Stack(
            children: [
              // ── decorative header arc ──────────────────────────────────
              Positioned(
                top: 0, left: 0, right: 0,
                child: CustomPaint(
                  size: const Size(double.infinity, 260),
                  painter: _ArcPainter(),
                ),
              ),

              // ── main content ───────────────────────────────────────────
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideUp,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.language,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: () => showLanguageSelector(context),
                              tooltip: 'Select Language / اختر اللغة / Sélectionner la langue',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Logo area
                          Center(
                            child: Container(
                              width: 160,
                              height: 140,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.35),
                                    blurRadius: 32,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            AppTranslations.get('appTitle', languageProvider.currentLanguage),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppTranslations.get('appSubtitle', languageProvider.currentLanguage),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.85),
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 48),

                          // ── card ──────────────────────────────────────
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 32,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(28),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    AppTranslations.get('loginTitle', languageProvider.currentLanguage),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A2B4A),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Email
                                  _StyledField(
                                    controller: _emailController,
                                    label: AppTranslations.get('email', languageProvider.currentLanguage),
                                    hint: AppTranslations.get('email_hint', languageProvider.currentLanguage),
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return AppTranslations.get('nameRequired', languageProvider.currentLanguage);
                                      if (!v.contains('@')) return AppTranslations.get('emailInvalid', languageProvider.currentLanguage);
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Password
                                  _StyledField(
                                    controller: _passwordController,
                                    label: AppTranslations.get('password', languageProvider.currentLanguage),
                                    hint: AppTranslations.get('password_hint', languageProvider.currentLanguage),
                                    icon: Icons.lock_outline_rounded,
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        color: const Color(0xFF8FA3BF),
                                        size: 20,
                                      ),
                                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return AppTranslations.get('passwordTooShort', languageProvider.currentLanguage);
                                      if (v.length < 6) return AppTranslations.get('passwordTooShort', languageProvider.currentLanguage);
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  // Error
                                  if (_errorMessage != null) ...[
                                    _ErrorBanner(message: _errorMessage!),
                                    const SizedBox(height: 16),
                                  ],

                                  // Login button
                                  _GradientButton(
                                    label: AppTranslations.get('login', languageProvider.currentLanguage),
                                    isLoading: _isLoading,
                                    onPressed: _handleLogin,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Demo credentials
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded,
                                        color: AppColors.primary, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      AppTranslations.get('demo_credentials', languageProvider.currentLanguage),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Email: $_testEmail\nMot de passe: $_testPassword',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    color: Color(0xFF5A6E8C),
                                    height: 1.7,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Register link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppTranslations.get('no_account', languageProvider.currentLanguage),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF8FA3BF),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pushNamed('/register'),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppTranslations.get('register', languageProvider.currentLanguage),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Decorative arc painter ────────────────────────────────────────────────────
class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = const LinearGradient(
      colors: [Color(0xFF0A7E6E), Color(0xFF0FA08C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..lineTo(0, size.height - 60)
      ..quadraticBezierTo(
        size.width / 2, size.height + 30,
        size.width, size.height - 60,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);

    // subtle circle decoration
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.25),
      50,
      Paint()..color = Colors.white.withOpacity(0.06),
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.5),
      30,
      Paint()..color = Colors.white.withOpacity(0.06),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Styled text field ─────────────────────────────────────────────────────────
class _StyledField extends StatelessWidget {
  const _StyledField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1A2B4A),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBDCAD8), fontSize: 13),
        labelStyle: const TextStyle(color: Color(0xFF8FA3BF), fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4EBF5), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE05C5C), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE05C5C), width: 2),
        ),
      ),
    );
  }
}

// ── Gradient button ───────────────────────────────────────────────────────────
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A7E6E), Color(0xFF0DC9A8)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Error banner ──────────────────────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE05C5C).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFE05C5C), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFB94040),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}