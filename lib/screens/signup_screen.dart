import 'package:flutter/material.dart'; // ใช้สำหรับสร้าง UI ใน Flutter
import 'dart:convert'; // ใช้สำหรับแปลงข้อมูล JSON (jsonEncode และ jsonDecode)
import 'package:http/http.dart' as http; // ใช้สำหรับการเรียก API ผ่าน HTTP
import 'package:flutter_gps/screens/signin_screen.dart'; // นำเข้าหน้าจอสำหรับ "Sign In"
import 'package:flutter_gps/theme/theme.dart'; // นำเข้าธีมของแอป เช่น สีหลัก
import 'package:flutter_gps/widgets/custom_scaffold.dart'; // นำเข้า CustomScaffold ที่เป็นโครงสร้างหน้าจอ
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// หน้าจอสำหรับ "Sign Up" (สมัครสมาชิก)
class SignUpScreen extends StatefulWidget {
  const SignUpScreen(
      {super.key}); // ใช้สำหรับกำหนดคีย์ให้ widget เพื่อระบุได้ชัดเจน

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState(); // สร้าง State (สถานะ) สำหรับหน้าจอ
}

// สถานะของหน้าจอ SignUpScreen
class _SignUpScreenState extends State<SignUpScreen> {
  // สร้างตัวแปรสำหรับควบคุมฟอร์มและช่องกรอกข้อความ
  final _formSignupKey =
      GlobalKey<FormState>(); // ใช้ตรวจสอบสถานะฟอร์ม (Valid หรือไม่)
  final _fnameController =
      TextEditingController(); // ควบคุมช่องกรอก "First Name"
  final _lnameController =
      TextEditingController(); // ควบคุมช่องกรอก "Last Name"
  final _emailController = TextEditingController(); // ควบคุมช่องกรอก "Email"
  final _passwordController =
      TextEditingController(); // ควบคุมช่องกรอก "Password"

  // ฟังก์ชันสำหรับการสมัครสมาชิก
  Future<void> _register() async {
    final url = Uri.parse(
        'https://localhost:44327/api/Customers/signup'); // URL สำหรับ API สมัครสมาชิก
    final header = {
      'Content-Type': 'application/json'
    }; // กำหนด Header สำหรับ API (บอกว่าใช้ JSON)
    final body = jsonEncode({
      // แปลงข้อมูลจากฟอร์มเป็น JSON
      'fname': _fnameController.text, // ดึงค่า First Name
      'lname': _lnameController.text, // ดึงค่า Last Name
      'email': _emailController.text, // ดึงค่า Email
      'password': _passwordController.text // ดึงค่า Password
    });

    final response = await http.post(url,
        headers: header, body: body); // เรียก API ด้วย POST Request

    // ตรวจสอบสถานะการตอบกลับจาก API
    if (response.statusCode == 200) {
      // ถ้าสำเร็จ
      final jsonResponse =
          jsonDecode(response.body); // แปลงข้อมูลตอบกลับเป็น JSON
      if (jsonResponse['success']) {
        // ถ้าการสมัครสำเร็จ
        _showSnackBar('Registration successful!'); // แสดงข้อความสำเร็จ
        Navigator.push(
          // เปลี่ยนหน้าไปที่ "Sign In"
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } else {
        _showSnackBar(jsonResponse['message']); // แสดงข้อความข้อผิดพลาดจาก API
      }
    } else {
      // ถ้าเกิดข้อผิดพลาด
      final jsonResponse = jsonDecode(response.body); // แปลงข้อมูลตอบกลับ
      _showSnackBar(jsonResponse['message'] ??
          'An error occurred.'); // แสดงข้อความข้อผิดพลาด
    }
  }

  // ฟังก์ชันสำหรับแสดงข้อความ SnackBar
  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message), // ข้อความที่จะแสดง
      duration: const Duration(seconds: 2), // เวลาที่ SnackBar แสดง (2 วินาที)
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); // แสดง SnackBar
  }

  bool agreePersonalData = true; // ตัวแปรตรวจสอบว่า User ยอมรับข้อกำหนดหรือไม่

  @override
  Widget build(BuildContext context) {
    // ส่วนที่สร้าง UI ของหน้าจอ
    return CustomScaffold(
      // ใช้ CustomScaffold เป็นโครงสร้างพื้นฐานของหน้าจอ
      child: Column(
        // ใช้ Column เพื่อจัดเรียง Widget ในแนวตั้ง
        children: [
          const Expanded(
            // เว้นระยะด้านบน
            flex: 1,
            child: SizedBox(
              height: 10, // เว้นที่ว่าง 10px
            ),
          ),
          Expanded(
            // ส่วนฟอร์มสมัครสมาชิก
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                  25.0, 50.0, 25.0, 20.0), // กำหนด Padding รอบฟอร์ม
              decoration: const BoxDecoration(
                // การตกแต่งพื้นหลัง
                color: Colors.white, // พื้นหลังสีขาว
                borderRadius: BorderRadius.only(
                  // มุมโค้งด้านบน
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // ทำให้ฟอร์ม Scroll ได้
                child: Form(
                  // ฟอร์มสำหรับกรอกข้อมูล
                  key: _formSignupKey, // กำหนด Key ให้ฟอร์ม
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // จัดชิดกึ่งกลางในแนวนอน
                    children: [
                      Text(
                        // ข้อความหัวข้อ "Get Started"
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0, // ขนาดตัวอักษร
                          fontWeight: FontWeight.w900, // น้ำหนักตัวอักษร
                          color: primaryColor, // สีข้อความ
                        ),
                      ),
                      const SizedBox(height: 40.0), // เว้นระยะห่าง
                      TextFormField(
                        // ช่องกรอก First Name
                        controller: _fnameController,
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                        validator: (value) {
                          // ตรวจสอบความถูกต้อง
                          if (value!.isEmpty) {
                            return 'Please enter your first name'; // แจ้งเตือนถ้าเว้นว่าง
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        // ช่องกรอก Last Name
                        controller: _lnameController,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        // ช่องกรอก Email
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            // ตรวจสอบรูปแบบ Email
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        // ช่องกรอก Password
                        controller: _passwordController,
                        obscureText: true, // ซ่อนข้อความที่พิมพ์
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            // ตรวจสอบความยาวของรหัสผ่าน
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        // Checkbox ยอมรับข้อกำหนด
                        children: [
                          Checkbox(
                            // สร้างช่อง Checkbox
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              // เมื่อมีการเปลี่ยนสถานะ
                              setState(() {
                                agreePersonalData = value!; // อัปเดตสถานะ
                              });
                            },
                            activeColor:
                                primaryColor, // สีของ Checkbox เมื่อถูกเลือก
                          ),
                          const Text(
                            'I agree to the processing of ', // ข้อความ
                            style: TextStyle(color: Colors.black45),
                          ),
                          Text(
                            'Personal data', // ข้อความเน้น
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        // ปุ่ม "Register"
                        onPressed: () {
                          if (_formSignupKey.currentState!.validate()) {
                            // ตรวจสอบความถูกต้องของฟอร์ม
                            _register(); // เรียกฟังก์ชันสมัครสมาชิก
                          }
                        },
                        child: const Text('Register'),
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        // ข้อความ "Sign up with" พร้อมเส้นคั่น
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
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
                      const SizedBox(height: 30.0),
                      Row(
                        // ไอคอนโซเชียลมีเดีย
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FaIcon(FontAwesomeIcons.facebookF),
                          FaIcon(FontAwesomeIcons.twitter),
                          FaIcon(FontAwesomeIcons.google),
                          FaIcon(FontAwesomeIcons.apple),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        // ข้อความ "Already have an account?"
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            // ลิงก์ไปยังหน้า "Sign In"
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
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
