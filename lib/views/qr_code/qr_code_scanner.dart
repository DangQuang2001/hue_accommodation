import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/room_view_model.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house_detail.dart';
import 'package:hue_accommodation/views/components/slide_route.dart';
import 'package:hue_accommodation/views/qr_code/review_room.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../generated/l10n.dart';
import '../login_register/auth_service.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(children: [
      QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
      Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
                child: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      snapshot.data == false
                          ? Icons.flash_off_outlined
                          : Icons.flash_on_outlined,
                      size: 31,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              InkWell(
                onTap: () async {
                  await controller?.flipCamera();
                  setState(() {});
                },
                child: FutureBuilder(
                  future: controller?.getCameraInfo(),
                  builder: (context, snapshot) => const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.flip_camera_ios_outlined,
                      size: 31,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )),
      Positioned(
          bottom: 20,
          right: 20,
          left: 20,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              S.of(context).qr_code_scan,
              style: GoogleFonts.readexPro(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20),
            )),
          ))
    ]);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      if (describeEnum(scanData.format) == "qrcode") {
        // ignore: use_build_context_synchronously
        await _dialogBuilder(context, scanData.code!);
        // Navigator.pushNamed(context, RouteName.home);
        await controller.resumeCamera();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _dialogBuilder(BuildContext context, String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<RoomViewModel, UserViewModel>(
          builder: (context, roomProvider, userProvider, child) => AlertDialog(
              title: Center(
                  child: Text(
                    S.of(context).qr_code_scan_success,
                style: GoogleFonts.readexPro(color: Colors.green),
              )),
              content: Container(
                alignment: Alignment.center,
                width: 400,
                height: 420,
                child: FutureBuilder(
                  future: roomProvider.getDetailRoom(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                snapshot.data!.image,
                                height: 170,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot.data!.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.readexPro(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data!.adParams['address']['value'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.readexPro(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller!.pauseCamera();
                                      Navigator.of(context).push(
                                          slideBottomToTop(BoardingHouseDetail(
                                              motel: snapshot.data!)));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(20),
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Image.network(
                                          'https://cdn-icons-png.flaticon.com/512/1150/1150643.png'),
                                    ),
                                  ),
                                  Text(
                                    S.of(context).qr_code_detail,
                                    style: GoogleFonts.readexPro(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 70,
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (userProvider.userCurrent != null) {
                                        controller!.pauseCamera();
                                        Navigator.of(context).push(
                                            slideBottomToTop(
                                                 ReviewRoom(room: snapshot.data!,)));
                                      } else {
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: const Text(
                                              'Bạn phải đăng nhập để sử dụng chức năng này!'),
                                          action: SnackBarAction(
                                            label: 'Đăng nhập',
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AuthService()
                                                              .handleAuthState()));
                                            },
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(20),
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Image.network(
                                          'https://cdn-icons-png.flaticon.com/512/2065/2065224.png'),
                                    ),
                                  ),
                                  Text(
                                    S.of(context).qr_code_review,
                                    style: GoogleFonts.readexPro(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              )),
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.pauseCamera();
    controller?.dispose();

    super.dispose();
  }
}
