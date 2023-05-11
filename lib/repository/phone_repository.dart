import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhoneDialer(String contactNumber) async {
  final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
  try {
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  } catch (error) {
    debugPrint(error.toString());
  }
}

List listTranspot = [
  {
    "image":
        "https://toplist.vn/images/800px/cong-ty-co-phan-tu-van-amp-phat-trien-dai-loc-phat-775457.jpg",
    "name": "Công Ty Cổ Phần Tư Vấn & Phát Triển Đại Lộc Phát",
    "address": "6 Trần Hưng Đạo, TP. Huế, Thừa Thiên Huế",
    "phone": "0906 483 222"
  },
  {
    "image":
        "https://toplist.vn/images/800px/chuyen-nha-tron-goi-hue-775436.jpg",
    "name": "Chuyển nhà trọn gói Huế",
    "address": "Phan Đình Phùng, TP. Huế, Thừa Thiên Huế",
    "phone": "0869 084 159"
  },
  {
    "image":
        "https://toplist.vn/images/800px/cong-ty-ve-sinh-cong-nghiep-khong-gian-sach-775447.jpg",
    "name": "Công Ty Vệ Sinh Công Nghiệp Không Gian Sạch",
    "address": "42 Tùng Thiện Vương, TP. Huế, Thừa Thiên Huế",
    "phone": "0922 955 333"
  },
  {
    "image":
        "https://toplist.vn/images/800px/cong-ty-dich-vu-ve-sinh-cong-nghiep-hue-clean-775449.jpg",
    "name": "Công Ty Dịch Vụ Vệ Sinh Công Nghiệp Huế Clean",
    "address": "11 Lý Thường Kiệt, TP. Huế, Thừa Thiên Huế",
    "phone": "0967 096 970"
  },
  {
    "image":
        "https://toplist.vn/images/800px/dich-vu-chuyen-nha-chuyen-tro-tai-hue-775428.jpg",
    "name": "Dịch vụ chuyển nhà, chuyển trọ tại Huế",
    "address": "Thừa Thiên Huế",
    "phone": "0395 519 791"
  },
  {
    "image":
        "https://toplist.vn/images/800px/xe-cho-hang-chuyen-nha-chuyen-tro-don-van-phong-tai-hue-901559.jpg",
    "name": "Xe chở hàng chuyển nhà chuyển trọ dọn văn phòng tại Huế",
    "address": "Thừa Thiên Huế",
    "phone": "0339 195 840"
  },
  {
    "image":
        "https://toplist.vn/images/800px/dich-vu-chuyen-nha-tro-van-phong-tron-goi-tai-hue-901563.jpg",
    "name": "Dịch vụ chuyển nhà, trọ, văn phòng trọn gói tại Huế",
    "address": "Thừa Thiên Huế",
    "phone": "0913 149 533"
  },
  {
    "image":
        "https://toplist.vn/images/800px/dich-vu-chuyen-nha-tro-tai-hue-901565.jpg",
    "name": "Dịch Vụ Chuyển Nhà Trọ Tại Huế",
    "address": "Thừa Thiên Huế",
    "phone": "0931 936 435"
  },
  {
    "image": "https://toplist.vn/images/800px/chuyen-nha-hue-901567.jpg",
    "name": "Chuyển nhà Huế",
    "address": "Thừa Thiên Huế",
    "phone": "0896 206 726"
  },
  {
    "image":
        "https://toplist.vn/images/800px/dich-vu-chuyen-nha-chuyen-tro-tai-hue-901572.jpg",
    "name": "Dịch vụ chuyển nhà chuyển trọ tại Huế",
    "address": "Thừa Thiên Huế",
    "phone": "0375 080 905"
  },
];
