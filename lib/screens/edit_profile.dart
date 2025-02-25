import 'package:flutter/material.dart';
import 'package:flutter_gps/constants.dart';
import 'package:flutter_gps/widgets/custom_button.dart';
import 'package:flutter_gps/widgets/custom_textfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_gps/screens/signup_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ตัวแปรสำหรับเก็บค่าที่ผู้ใช้กรอก
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ค่าที่ใช้ตรวจสอบว่าจะแสดงหรือซ่อนรหัสผ่าน
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String? errorMessage; // ใช้เก็บข้อความแจ้งเตือนข้อผิดพลาด

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // โหลดข้อมูลโปรไฟล์เมื่อเปิดหน้านี้
  }

  /// ฟังก์ชันโหลดข้อมูลโปรไฟล์จาก API
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final email =
        prefs.getString('user_email'); // ดึง email จาก SharedPreferences
    if (email == null) return;

    final url = Uri.parse(
        'https://localhost:44327/api/Customers/GetByEmail?email=$email');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          setState(() {
            fnameController.text = data['fname'] ?? '';
            lnameController.text = data['lname'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  /// ฟังก์ชันอัปเดตโปรไฟล์
  Future<void> _updateProfile() async {
    setState(() {
      errorMessage = null; // รีเซ็ตข้อความผิดพลาดก่อน
    });

    if (newPasswordController.text.length < 6) {
      setState(() {
        errorMessage = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
      });
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'New password และ Confirm password ไม่ตรงกัน';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId =
        prefs.getString('user_id'); // ดึง user_id จาก SharedPreferences
    if (userId == null) return;

    final url = Uri.parse('https://localhost:44327/api/Customers/$userId');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'fname': fnameController.text,
      'lname': lnameController.text,
      'currentpassword': currentPasswordController.text,
      'password': newPasswordController.text,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context, true); // ปิดหน้าจอและส่งค่า true กลับไป
        } else {
          setState(() {
            errorMessage = jsonResponse['message'];
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to update profile';
        });
      }
    } catch (e) {
      print("Error updating profile: $e");
      setState(() {
        errorMessage = 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
      });
    }
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId =
        prefs.getString('user_id'); // ดึง userId จาก SharedPreferences

    if (userId == null) {
      print('No userId found in SharedPreferences.');
      return;
    }

    final url = Uri.parse(
        'https://localhost:44327/api/Customers/$userId'); // ใช้ userId ใน URL
    final headers = {'accept': '*/*'}; // หัวข้อคำขอ

    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'This action is irreversible. Your account and all associated data will be permanently deleted.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // ไม่ลบ
              child: Text('Cancel', style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600, // ใช้สีแดงอ่อนลง
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(true), // ยืนยันการลบ
              child: Text('Delete',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        print('Account deleted successfully.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const SignUpScreen()), // ไปที่หน้าลงทะเบียนใหม่
        );
      } else {
        print('Failed to delete account. Status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color:
                  Theme.of(context).colorScheme.onPrimary), // ใช้สี onPrimary
        ),
      ),
      body: SingleChildScrollView(
        //ป้องกันเลย์เอาต์ล้นหน้าจอ
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Section
            Container(
              height: kSpacingUnit.w * 10,
              width: kSpacingUnit.w * 10,
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: kSpacingUnit.w * 5,
                    backgroundImage:
                        const AssetImage('assets/images/avatar.png'),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: kSpacingUnit.w * 2.5,
                        width: kSpacingUnit.w * 2.5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            LineAwesomeIcons.image_solid,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 15.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form Fields Section
            CustomTextField(
                controller: fnameController, hintText: 'First Name'),
            CustomTextField(controller: lnameController, hintText: 'Last Name'),

            CustomTextField(
              controller: currentPasswordController,
              hintText: 'Current Password',
              obscureText: _obscureCurrentPassword,
              toggleObscure: () => setState(
                  () => _obscureCurrentPassword = !_obscureCurrentPassword),
            ),
            CustomTextField(
              controller: newPasswordController,
              hintText: 'New Password',
              obscureText: _obscureNewPassword,
              toggleObscure: () =>
                  setState(() => _obscureNewPassword = !_obscureNewPassword),
            ),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: _obscureConfirmPassword,
              toggleObscure: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),

            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 20),
            const Divider(thickness: 1.2), // 🔥 แบ่งส่วนข้อมูล
            const SizedBox(height: 20),

            _buildUpdateProfileButton(context),
            const SizedBox(height: 8),
            _buildDeleteAccountButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateProfileButton(BuildContext context) {
    return buildButton(
      context: context, // ต้องส่ง context ไปด้วย
      text: "Save Changes",
      onPressed: _updateProfile,
      isOutlined: false,
      isPrimary: true,
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return buildButton(
      context: context,
      text: "Delete Account",
      onPressed: _deleteAccount,
      isOutlined: true,
      isDanger: true, // ใช้สีแดง
    );
  }
}
