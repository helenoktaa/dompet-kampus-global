import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_field.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/feature_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _pw = '';
  bool _showPw = false;
  bool _gLoading = false;

  bool get _valid => _email.contains('@') && _pw.length >= 4;

  Future<void> _loginWithGoogle() async {
    setState(() => _gLoading = true);
    try {
      debugPrint('[Auth] Google sign-in: memulai...');
      final googleSignIn = GoogleSignIn();
      // Keluar dari sesi Google yang ter-cache agar dialog pilih akun selalu muncul
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('[Auth] Google sign-in: dibatalkan user');
        setState(() => _gLoading = false);
        return;
      }
      debugPrint('[Auth] Google sign-in: akun dipilih → ${googleUser.email}');

      final googleAuth = await googleUser.authentication;
      debugPrint(
          '[Auth] Google auth: accessToken=${googleAuth.accessToken != null ? "OK" : "NULL"}, '
          'idToken=${googleAuth.idToken != null ? "OK" : "NULL"}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint(
          '[Auth] Firebase sign-in OK → uid=${userCredential.user?.uid}');

      final idToken = await userCredential.user?.getIdToken();
      debugPrint(
          '[Auth] Firebase ID token: ${idToken != null ? "OK (${idToken.length} chars)" : "NULL"}');

      if (idToken != null && mounted) {
        debugPrint(
            '[Auth] Kirim token ke backend → POST /v1/auth/verify-token');
        context.read<AuthBloc>().add(AuthLoginWithFirebase(idToken));
      }
    } catch (e, st) {
      debugPrint('[Auth] Google sign-in ERROR: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Google gagal: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _gLoading = false);
    }
  }

  Future<void> _loginWithEmail() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _pw,
      );
      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null && mounted) {
        context.read<AuthBloc>().add(AuthLoginWithFirebase(idToken));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login gagal.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthNeedsVerification) {
          context.go('/2fa/smtp');
        } else if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: AppColors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => context.go('/'),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(DkgIcons.arrowLeft,
                          color: AppColors.ink, size: 18),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(26, 24, 26, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      const AppLogo(size: 44),
                      const SizedBox(height: 22),

                      // Title
                      const Text('Sign in',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          )),
                      const SizedBox(height: 5),
                      const Text('Welcome back 👋',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                            color: AppColors.slate400,
                          )),
                      const SizedBox(height: 28),

                      // Google button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final loading = state is AuthLoading || _gLoading;
                          return GestureDetector(
                            onTap: loading ? null : _loginWithGoogle,
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: AppColors.line, width: 1.5),
                                boxShadow: AppColors.shadowSoft,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: loading
                                    ? const [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            valueColor: AlwaysStoppedAnimation(
                                                AppColors.primary),
                                          ),
                                        ),
                                        SizedBox(width: 11),
                                        Text('Connecting…',
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            )),
                                      ]
                                    : const [
                                        _GoogleIcon(),
                                        SizedBox(width: 11),
                                        Text('Continue with Google',
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.ink,
                                            )),
                                      ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22),

                      // Divider
                      Row(children: [
                        const Expanded(child: Divider(color: AppColors.line)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: const Text('or use email',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate400,
                              )),
                        ),
                        const Expanded(child: Divider(color: AppColors.line)),
                      ]),
                      const SizedBox(height: 22),

                      // Email field
                      AppField(
                        label: 'Email',
                        value: _email,
                        onChanged: (v) => setState(() => _email = v),
                        placeholder: 'name@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(DkgIcons.mail, size: 20),
                      ),
                      const SizedBox(height: 14),

                      // Password field
                      AppField(
                        label: 'Password',
                        value: _pw,
                        onChanged: (v) => setState(() => _pw = v),
                        obscureText: !_showPw,
                        placeholder: '••••••••',
                        prefixIcon: const Icon(DkgIcons.lock, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_showPw ? DkgIcons.eyeOff : DkgIcons.eye,
                              size: 20, color: AppColors.slate400),
                          onPressed: () => setState(() => _showPw = !_showPw),
                        ),
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot password?',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              )),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Sign in button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) => AppButton(
                          label: 'Sign in',
                          onPressed: _valid ? _loginWithEmail : null,
                          isLoading: state is AuthLoading,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ",
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                                color: AppColors.slate400,
                              )),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: const Text('Sign up',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 21,
      height: 21,
      child: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/24px-Google_%22G%22_logo.svg.png',
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.g_mobiledata_rounded, size: 24, color: Colors.red),
      ),
    );
  }
}
