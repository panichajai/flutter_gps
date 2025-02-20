import 'package:flutter/material.dart';
import 'package:flutter_gps/widgets/custom_button.dart';
import 'package:flutter_gps/widgets/custom_textfield.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gps/screens/signup_screen.dart';
import 'package:flutter_gps/widgets/custom_scaffold.dart';
import 'package:flutter_gps/screens/tab_menu_screen.dart';
import '../theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool rememberPassword = true;

  Future<void> _login() async {
    final url = Uri.parse('https://localhost:44327/api/Customers/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(
        {'email': _emailController.text, 'password': _passwordController.text});

    try {
      final response = await http.post(url, headers: headers, body: body);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSnackBar(jsonResponse['message']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', _emailController.text);

        if (mounted) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TabMenuScreen()),
          );
        }
      } else {
        _showSnackBar(jsonResponse['message'] ?? 'Login failed');
      }
    } catch (error) {
      _showSnackBar('An error occurred. Please try again later.');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Spacer(),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                          controller: _emailController, hintText: 'Email'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: _obscurePassword,
                        toggleObscure: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      const SizedBox(height: 24),
                      _buildRememberMeAndForgotPassword(),
                      const SizedBox(height: 25),
                      _buildSignInButton(context),
                      const SizedBox(height: 25),
                      _buildDivider(),
                      const SizedBox(height: 25),
                      _buildSocialLoginButtons(),
                      const SizedBox(height: 25),
                      _buildSignUpOption(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRememberMeAndForgotPassword() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           Checkbox(
  //             value: rememberPassword,
  //             onChanged: (value) {
  //               setState(() {
  //                 rememberPassword = value!;
  //               });
  //             },
  //           ),
  //           const Text('Remember me'),
  //         ],
  //       ),
  //       TextButton(
  //         onPressed: () {},
  //         child: Text('Forgot password?',
  //             style: TextStyle(color: lightColorScheme.primary)),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildRememberMeAndForgotPassword() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 4), // ✅ ปรับให้ตรงกับฟิลด์
      child: Row(
        children: [
          Expanded(
            // ✅ ทำให้ Checkbox + Text เต็มพื้นที่
            child: Row(
              children: [
                SizedBox(
                  height: 24, width: 24, // ✅ กำหนดขนาด Checkbox
                  child: Checkbox(
                    value: rememberPassword,
                    onChanged: (value) {
                      setState(() {
                        rememberPassword = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8), // ✅ เพิ่มระยะห่างให้เหมือน TextField
                const Text('Remember me'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Forgot password?',
              style: TextStyle(color: lightColorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return buildButton(
      context: context,
      text: 'Sign in',
      onPressed: _login,
      isOutlined: false,
      isPrimary: true,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider()),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Sign in with'),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FaIcon(FontAwesomeIcons.facebookF),
        FaIcon(FontAwesomeIcons.twitter),
        FaIcon(FontAwesomeIcons.google),
        FaIcon(FontAwesomeIcons.apple),
      ],
    );
  }

  Widget _buildSignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen())),
          child: Text('Sign up',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: lightColorScheme.primary)),
        ),
      ],
    );
  }
}
