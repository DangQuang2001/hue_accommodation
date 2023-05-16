import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/rent_view_model.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house_detail.dart';
import 'package:provider/provider.dart';

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
    Stripe.publishableKey =
        "pk_test_51N4fplCYZEI22fEEbtNGRxHaUlnUcQfTWdJSd7NW3vkHoTvvk62WUtUh2PwpC07F9RZ7NU0eWfFpkYKw3TU0zep800RSjDjGC0";

    var rentViewModel = Provider.of<RentViewModel>(context, listen: false);
    rentViewModel.getListRent(
        Provider.of<UserViewModel>(context, listen: false).userCurrent!.id);
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
    return Consumer<RentViewModel>(
      builder: (context, rentModel, child) => Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ...rentModel.listRent.map((e) => GestureDetector(
                      onTap: () async {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              color: Theme.of(context).colorScheme.onBackground,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20, top: 40),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BoardingHouseDetail(
                                                        motel: e.room)));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://cdn-icons-png.flaticon.com/512/1644/1644130.png",
                                            ),
                                          ),
                                          Text(
                                            'Detail',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (e.isPay) {
                                          showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: 50,
                                                  color: Colors.green,
                                                  child:  Center(
                                                    child: Text(
                                                        'You have already paid this month.' ,style: GoogleFonts.readexPro(color: Colors.white,fontSize: 15),),
                                                  ),
                                                );
                                              });

                                          // ignore: use_build_context_synchronously
                                        } else {
                                          await Payment().makePayment(
                                              context,
                                              rentModel,
                                              e.id,
                                              double.parse(
                                                  e.room.adParams['deposit']
                                                      ['value']),
                                              e.user.id);
                                        }
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://cdn-icons-png.flaticon.com/512/5097/5097344.png",
                                            ),
                                          ),
                                          Text(
                                            'Payment',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                'STT',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayMedium,
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              ...e.payment!
                                                                  .map((item) {
                                                                var index = e
                                                                    .payment!
                                                                    .indexOf(
                                                                        item);
                                                                return Text(
                                                                    (index + 1)
                                                                        .toString(),
                                                                    style: GoogleFonts.readexPro(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w300));
                                                              })
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                'Month',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayMedium,
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              ...e.payment!
                                                                  .map((e) {
                                                                return Text(
                                                                    e['createdAt']
                                                                            .toString()
                                                                            .split("T")[
                                                                        0],
                                                                    style: GoogleFonts.readexPro(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w300));
                                                              })
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Description',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .displayMedium,
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                ...e.payment!
                                                                    .map((e) {
                                                                  return Text(
                                                                    e['description'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.readexPro(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  );
                                                                })
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://cdn-icons-png.flaticon.com/512/4313/4313096.png",
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Payment history',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
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
                                    imageUrl: e.roomImage,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.roomName,
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
                                        e.room.adParams['address']['value'],
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
                                        e.room.adParams['deposit']['value'] +
                                            ' VND',
                                        style: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15,
                                            color: Colors.orange),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        e.isConfirmed == 0
                                            ? "Waiting"
                                            : "Confirmed",
                                        style: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.blue),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      e.isConfirmed == 1
                                          ? Text(
                                              e.isPay ? "Paid" : "UnPay",
                                              style: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                  color: e.isPay
                                                      ? Colors.green
                                                      : Colors.redAccent),
                                            )
                                          : const Text(''),
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
      ),
    );
  }
}
