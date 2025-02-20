import 'package:flutter/material.dart';
import 'package:flutter_gps/screens/signin_screen.dart'; // นำเข้าไฟล์ SignInScreen (หน้าจอลงชื่อเข้าใช้)
import 'package:flutter_gps/screens/signup_screen.dart'; // นำเข้าไฟล์ SignUpScreen (หน้าจอลงทะเบียน)
import 'package:flutter_gps/theme/theme.dart'; // นำเข้าธีมสีหรือการตกแต่งของแอป
import 'package:flutter_gps/widgets/custom_scaffold.dart'; // นำเข้า CustomScaffold (โครงสร้างหน้าจอที่ปรับแต่งเอง)
import 'package:flutter_gps/widgets/welcome_button.dart'; // นำเข้า WelcomeButton (ปุ่มที่ปรับแต่งเอง)

// สร้างคลาส WelcomeScreen ซึ่งเป็นหน้าจอต้อนรับผู้ใช้งาน
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen(
      {super.key}); // กำหนดคีย์สำหรับ widget เพื่อให้ Flutter ระบุ widget นี้ได้ง่ายขึ้นใน tree

  @override
  Widget build(BuildContext context) {
    // ฟังก์ชันสร้าง UI ของหน้าจอ
    return CustomScaffold(
      // ใช้ CustomScaffold เป็นโครงสร้างพื้นฐานของหน้าจอ
      child: Column(
        // ใช้ Column เพื่อจัดเรียง widget ในแนวตั้ง
        children: [
          Flexible(
              flex: 8, // ส่วนนี้ใช้พื้นที่ 8 ส่วนของหน้าจอจากทั้งหมด 9 ส่วน
              child: Container(
                padding: const EdgeInsets.symmetric(
                  // กำหนดระยะห่างด้านข้าง (horizontal padding)
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  // จัดตำแหน่งเนื้อหาให้อยู่ตรงกลาง
                  child: RichText(
                    // ใช้ RichText เพื่อแสดงข้อความหลายรูปแบบในบรรทัดเดียว
                    textAlign: TextAlign.center, // จัดข้อความให้อยู่กึ่งกลาง
                    text: const TextSpan(
                      // กำหนดรูปแบบข้อความ
                      children: [
                        TextSpan(
                            text: 'Welcome !\n', // ข้อความ "Welcome Back!"
                            style: TextStyle(
                              fontSize: 40, // ขนาดฟอนต์ใหญ่ 40
                              fontWeight:
                                  FontWeight.w600, // น้ำหนักตัวอักษรหนาปานกลาง
                            )),
                        TextSpan(
                            text:
                                '\nEnter personal details to your employee account', // ข้อความเพิ่มเติมด้านล่าง
                            style: TextStyle(
                              fontSize: 20, // ขนาดฟอนต์ 20
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1, // ส่วนนี้ใช้พื้นที่ 1 ส่วนจากทั้งหมด 9 ส่วน
            child: Align(
              alignment:
                  Alignment.bottomRight, // จัด widget ให้อยู่ที่มุมล่างขวา
              child: Row(
                // ใช้ Row เพื่อจัดเรียงปุ่มในแนวนอน
                children: [
                  const Expanded(
                    // ใช้ Expanded เพื่อให้ปุ่มขยายเต็มพื้นที่ที่เหลือใน Row
                    child: WelcomeButton(
                      // ปุ่มแรก "Sign in"
                      buttonText: 'Sign in', // ข้อความบนปุ่ม
                      onTap:
                          SignInScreen(), // เมื่อกดปุ่ม ให้เปิดหน้าจอ SignInScreen
                      color: Colors.transparent, // สีพื้นหลังของปุ่ม (โปร่งใส)
                      textColor: Colors.white, // สีข้อความในปุ่ม (สีขาว)
                    ),
                  ),
                  Expanded(
                    // ปุ่มที่สอง "Sign up"
                    child: WelcomeButton(
                      buttonText: 'Sign up', // ข้อความบนปุ่ม
                      onTap:
                          const SignUpScreen(), // เมื่อกดปุ่ม ให้เปิดหน้าจอ SignUpScreen
                      color: Colors.white, // สีพื้นหลังของปุ่ม (สีขาว)
                      textColor: lightColorScheme
                          .primary, // สีข้อความในปุ่ม (สี primary จากธีม)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
