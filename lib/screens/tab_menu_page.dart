import 'dart:convert'; // ใช้สำหรับแปลง JSON
import 'package:flutter/material.dart'; // เครื่องมือ UI จาก Flutter
import 'package:http/http.dart' as http; // ใช้เรียก API ผ่าน HTTP
import 'package:shared_preferences/shared_preferences.dart'; // สำหรับจัดเก็บข้อมูลในเครื่อง
import 'package:flutter_gps/screens/signin_screen.dart'; // ไฟล์หน้าจอ Sign In

class TabMenuPage extends StatefulWidget {
  const TabMenuPage({super.key}); // กำหนด widget แบบ Stateful

  @override
  State<StatefulWidget> createState() => _TabMenuPageState(); // สร้าง State
}

class _TabMenuPageState extends State<TabMenuPage> {
  Map<String, dynamic>? _profileData; // ตัวแปรเก็บข้อมูลโปรไฟล์

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // โหลดข้อมูลโปรไฟล์เมื่อหน้าจอเริ่มต้น
  }

  Future<void> _loadProfileData() async {
    final data = await fetchProfileData(); // เรียกข้อมูลจาก API
    if (data != null) {
      setState(() {
        _profileData = data; // บันทึกข้อมูลโปรไฟล์
      });
    }
  }

  Future<Map<String, dynamic>?> fetchProfileData() async {
    final prefs =
        await SharedPreferences.getInstance(); // โหลด SharedPreferences
    final email =
        prefs.getString('user_email'); // ดึง email จาก SharedPreferences

    if (email == null) {
      print('No email found in SharedPreferences.');
      return null;
    }

    final url = Uri.parse(
        'https://localhost:44327/api/Customers/GetByEmail?email=$email'); // API URL
    final headers = {'Content-Type': 'application/json'}; // หัวของคำขอ HTTP

    final response =
        await http.get(url, headers: headers); // เรียก API ด้วย GET

    if (response.statusCode == 200) {
      final jsonResponse =
          jsonDecode(response.body) as Map<String, dynamic>; // แปลง JSON
      if (jsonResponse['success'] == true) {
        return jsonResponse['data']; // ส่งข้อมูลโปรไฟล์กลับ
      }
    }
    return null; // กรณีมีข้อผิดพลาด
  }

  Future<void> _updateProfile(String fname, String lname,
      String currentPassword, String newPassword) async {
    final prefs =
        await SharedPreferences.getInstance(); // โหลด SharedPreferences
    final email =
        prefs.getString('user_email'); // ดึง email จาก SharedPreferences
    final userId = '30'; // แทนที่ด้วย ID ผู้ใช้งานที่เหมาะสม

    if (email == null) {
      print('No email found in SharedPreferences.');
      return;
    }

    // เปลี่ยน URL ให้รองรับ ID
    final url = Uri.parse(
        'https://localhost:44327/api/Customers/$userId'); // แทนที่ {id} ด้วย userId
    final headers = {'Content-Type': 'application/json'}; // หัวข้อคำขอ

    // เปลี่ยน Body ให้ตรงกับ API
    final body = jsonEncode({
      'fname': fname,
      'lname': lname,
      'currentpassword': currentPassword,
      'password': newPassword,
    });

    // เปลี่ยน HTTP Method เป็น PUT
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        print('Profile updated successfully: ${jsonResponse['data']}');
        _loadProfileData(); // โหลดข้อมูลโปรไฟล์ใหม่
      } else {
        print('Failed to update profile: ${jsonResponse['message']}');
      }
    } else {
      print('Failed to update profile. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _openEditDialog() {
    final TextEditingController fnameController =
        TextEditingController(text: _profileData?['fname']); // ชื่อผู้ใช้
    final TextEditingController lnameController =
        TextEditingController(text: _profileData?['lname']); // นามสกุล
    final TextEditingController currentPasswordController =
        TextEditingController(); // รหัสผ่านเดิม
    final TextEditingController newPasswordController =
        TextEditingController(); // รหัสผ่านใหม่

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fnameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lnameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: currentPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Current Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateProfile(
                  fnameController.text,
                  lnameController.text,
                  currentPasswordController.text,
                  newPasswordController.text,
                ); // ส่งข้อมูลที่แก้ไขไป API
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = '0'; // เปลี่ยนให้เหมาะสมกับ ID ผู้ใช้งานที่ต้องการลบ

    // สร้าง URL สำหรับลบบัญชี
    final url = Uri.parse('https://localhost:44327/api/Customers/$userId');
    final headers = {'accept': '*/*'}; // หัวข้อคำขอ

    // ยืนยันก่อนลบ
    final confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure to delete your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // ไม่ลบ
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true), // ยืนยันการลบ
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // หากผู้ใช้ยืนยันการลบ
    if (confirmDelete == true) {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        print('Account deleted successfully.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        ); // ส่งผู้ใช้ไปหน้า Sign In
      } else {
        print('Failed to delete account. Status code: ${response.statusCode}');
      }
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const SignInScreen()), // กลับไปหน้าล็อกอิน
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // จำนวนแท็บทั้งหมด
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home', icon: Icon(Icons.home)),
              Tab(text: 'Contact', icon: Icon(Icons.contact_mail)),
              Tab(text: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text('Home')), // เนื้อหาแท็บ Home
            const Center(child: Text('Contact')), // เนื้อหาแท็บ Contact
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Profile Info',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _profileData == null
                      ? const CircularProgressIndicator() // กำลังโหลด
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_profileData?['fullname'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _openEditDialog, // เปิด Dialog แก้ไข
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ปุ่มลบบัญชี
                      OutlinedButton(
                        onPressed: _deleteAccount, // ฟังก์ชันลบบัญชี
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color:
                                Theme.of(context).colorScheme.primary, // สีกรอบ
                          ),
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .primary, // สีข้อความเหมือนสีพื้นหลังปุ่ม Logout
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8), // ขนาดปุ่ม
                        ),
                        child: const Text('Delete Account'),
                      ),
                      const SizedBox(width: 16), // ระยะห่างระหว่างปุ่ม
                      // ปุ่มออกจากระบบ
                      ElevatedButton(
                        onPressed: _logout, // ฟังก์ชัน Logout
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
