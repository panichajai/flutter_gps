import 'package:flutter/material.dart'; //ใช้สำหรับสร้าง UI และกำหนดธีม
import 'package:flutter_screenutil/flutter_screenutil.dart'; //ใช้ปรับขนาด UI ให้รองรับทุกขนาดหน้าจอ

const kSpacingUnit =
    10; //เป็นหน่วยพื้นฐานที่ใช้ในการกำหนดระยะห่างของ UI เช่น margin, padding, ขนาดตัวอักษร

//สีพื้นหลังหลักในโหมดมืด
const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

//กำหนดสไตล์ตัวอักษร title
final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil()
      .setSp(kSpacingUnit.w * 1.7), // ปรับขนาดตัวอักษรให้เหมาะสมกับขนาดหน้าจอ
  fontWeight: FontWeight.w600, //กำหนดให้ตัวอักษร หนาปานกลาง
);

class ScreenUtil {
  setSp(param0) {}
}

//กำหนดสไตล์ตัวอักษร caption
final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
  fontWeight: FontWeight.w100, //กำหนดให้ตัวอักษร บางมาก
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

//กำหนดธีมโหมดมืด (Dark Theme)
final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor,
      ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: kAccentColor)
      .copyWith(background: kDarkSecondaryColor),
);

//กำหนดธีมโหมดสว่าง
final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkSecondaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kDarkSecondaryColor,
        displayColor: kDarkSecondaryColor,
      ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: kAccentColor)
      .copyWith(background: kLightSecondaryColor),
);
