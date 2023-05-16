import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../repository/phone_repository.dart';

class TransportPages extends StatefulWidget {
  const TransportPages({super.key});

  @override
  State<TransportPages> createState() => _TransportPagesState();
}

class _TransportPagesState extends State<TransportPages> {
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
            '     Transpot    ',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: listTranspot.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(10)),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: listTranspot[index]['image'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listTranspot[index]['name'],
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          listTranspot[index]['address'],
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.call,
                              color: Colors.blue,
                            ),
                            TextButton(
                                onPressed: () {
                                  launchPhoneDialer(
                                      listTranspot[index]['phone']);
                                },
                                child: Text(
                                  listTranspot[index]['phone'],
                                  style: GoogleFonts.readexPro(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
