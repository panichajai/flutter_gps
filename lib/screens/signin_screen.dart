import 'package:flutter/material.dart'; // ใช้สำหรับการสร้าง UI ของ Flutter
import 'package:icons_plus/icons_plus.dart'; // ใช้สำหรับการใช้งานไอคอนต่างๆ เช่น Facebook, Twitter
import 'dart:convert'; // สำหรับการเข้ารหัสและถอดรหัส JSON
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // สำหรับการเรียก API ผ่าน HTTP
import 'package:flutter_gps/screens/signup_screen.dart'; // import ไฟล์หน้าสมัครสมาชิก
import 'package:flutter_gps/widgets/custom_scaffold.dart'; // import custom widget สำหรับ scaffold (โครงสร้างหน้าหลัก)
import 'package:flutter_gps/screens/tab_menu_page.dart';
import '../theme/theme.dart'; // import ธีมสีของแอปพลิเคชัน

// Widget ที่เป็นหน้าหลักของการเข้าสู่ระบบ
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key}); // กำหนด constructor แบบ immutable

  @override
  State<SignInScreen> createState() =>
      _SignInScreenState(); // เชื่อม Widget กับ State
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>(); // ใช้สำหรับเก็บสถานะของฟอร์ม
  final _emailController =
      TextEditingController(); // ตัวควบคุมข้อความในช่องกรอก email
  final _passwordController =
      TextEditingController(); // ตัวควบคุมข้อความในช่องกรอก password

  // ฟังก์ชันสำหรับเข้าสู่ระบบ (เรียก API)
  Future<void> _login() async {
    final url = Uri.parse('https://localhost:44327/api/Customers/login');
    final header = {'Content-Type': 'application/json'};
    final body = jsonEncode(
        {'email': _emailController.text, 'password': _passwordController.text});

    final response = await http.post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      _showSnackBar(jsonResponse['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabMenuPage()),
      );
      // บันทึก email ใน SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', _emailController.text);
      print('Saved email: ${prefs.getString('user_email')}');

      // ใช้ await ใน Navigator
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabMenuPage()),
      );
    } else if (response.statusCode == 401) {
      final jsonResponse = jsonDecode(response.body);
      _showSnackBar(jsonResponse['message']);
    }
  }

  // ฟังก์ชันสำหรับแสดง SnackBar
  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message), // ข้อความที่จะถูกแสดงใน SnackBar
      duration: const Duration(seconds: 2), // ระยะเวลาแสดง SnackBar
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); // แสดง SnackBar
  }

  bool rememberPassword = true; // ตัวแปรสำหรับ checkbox "Remember me"

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // ใช้ CustomScaffold เป็นโครงสร้างหลักของหน้า
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10), // ช่องว่างด้านบน
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                  25.0, 50.0, 25.0, 20.0), // ระยะห่างรอบๆ Container
              decoration: const BoxDecoration(
                color: Colors.white, // สีพื้นหลังของ Container
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0), // มุมโค้งด้านบนซ้าย
                  topRight: Radius.circular(40.0), // มุมโค้งด้านบนขวา
                ),
              ),
              child: SingleChildScrollView(
                // ใช้สำหรับเลื่อนหน้าจอในกรณีที่เนื้อหายาวเกิน
                child: Form(
                  key: _formSignInKey, // เชื่อมฟอร์มกับ GlobalKey
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30.0, // ขนาดตัวอักษร
                          fontWeight: FontWeight.w900, // น้ำหนักตัวอักษร
                          color: lightColorScheme.primary, // สีตัวอักษร
                        ),
                      ),
                      const SizedBox(height: 40.0), // เว้นระยะห่าง
                      TextFormField(
                        controller: _emailController, // ควบคุมช่องกรอก email
                        decoration: const InputDecoration(
                            labelText: 'Email'), // ป้ายกำกับ "Username"
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name'; // ตรวจสอบหากช่องว่าง
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25.0), // เว้นระยะห่าง
                      TextFormField(
                        controller:
                            _passwordController, // ควบคุมช่องกรอก password
                        obscureText: true, // ซ่อนรหัสผ่าน
                        decoration: const InputDecoration(
                            labelText: 'Password'), // ป้ายกำกับ "Password"
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password'; // ตรวจสอบหากช่องว่าง
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24), // เว้นระยะห่าง
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword, // เช็คสถานะ checkbox
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!; // อัปเดตสถานะ
                                  });
                                },
                                activeColor: lightColorScheme
                                    .primary, // สีของ checkbox เมื่อถูกเลือก
                              ),
                              const Text(
                                'Remember me', // ข้อความข้าง checkbox
                                style: TextStyle(color: Colors.black45),
                              ),
                            ],
                          ),
                          GestureDetector(
                            // สำหรับคลิกข้อความ
                            child: Text(
                              'Forget password?', // ข้อความลิงก์
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0), // เว้นระยะห่าง
                      SizedBox(
                        width: double.infinity, // ปุ่มกว้างเต็มหน้าจอ
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignInKey.currentState!.validate() &&
                                rememberPassword) {
                              // หากฟอร์มถูกต้อง และ checkbox ถูกเลือก
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Processing Data')), // แสดงข้อความ
                              );
                              _login(); // เรียกฟังก์ชันเข้าสู่ระบบ
                            } else if (!rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree to the processing of personal data')), // ข้อความกรณีไม่กด remember
                              );
                            }
                          },
                          child: const Text('Sign up'), // ข้อความในปุ่ม
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7, // ความหนา
                              color: Colors.grey.withOpacity(0.5), // สีจางๆ
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Logo(Logos.facebook_f), // ไอคอน Facebook
                          Logo(Logos.twitter), // ไอคอน Twitter
                          Logo(Logos.google), // ไอคอน Google
                          Logo(Logos.apple), // ไอคอน Apple
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.black45),
                          ),
                          GestureDetector(
                            onTap: () {
                              // เมื่อคลิก "Sign up"
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) =>
                                      const SignUpScreen(), // ไปหน้าสมัครสมาชิก
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
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
}
