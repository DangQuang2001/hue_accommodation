import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/payment.dart';

class MyActivity extends StatefulWidget {
  const MyActivity({super.key});

  @override
  State<MyActivity> createState() => _MyActivityState();
}

class _MyActivityState extends State<MyActivity> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // set the publishable key for Stripe - this is mandatory
    Stripe.publishableKey = "pk_test_51N4fplCYZEI22fEEbtNGRxHaUlnUcQfTWdJSd7NW3vkHoTvvk62WUtUh2PwpC07F9RZ7NU0eWfFpkYKw3TU0zep800RSjDjGC0";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), content(context)],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 40.0, right: 20, left: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 30,
                ),
              ),
            ),
          ),
          Text(
            '    Reservation   ',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  //Filter by categories

  Widget content(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ...[1, 2, 3, 4].map((e) => GestureDetector(
                onTap: () async{
                  await Payment().makePayment(context);
                },
                child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(2, 3))
                          ]),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://yt3.googleusercontent.com/inhxgLbhHuXL6IllrpCH9jw7jdb0aQLv4hpVdATYsBGJAwFYs8OpuvBKnKz-8M2eHp1oXvoyIQ=s900-c-k-c0x00ffffff-no-rj',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Trọ Tuy Lý Vương',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '107 Tuy Lý Vương, Phường Vỹ Dạ, Thành phố Huế',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      '1200000 VND',
                                      style: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15,
                                          color: Colors.orange),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'Confirmed',
                                      style: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Colors.blue),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'Unpaid',
                                      style: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
