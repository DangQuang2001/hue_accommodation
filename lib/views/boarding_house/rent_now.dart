import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/rent_view_model.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/room.dart';

class RentNowPage extends StatefulWidget {
  const RentNowPage({super.key, this.restorationId, required this.room});
  final String? restorationId;
  final Room room;
  @override
  State<RentNowPage> createState() => _RentNowPageState();
}

class _RentNowPageState extends State<RentNowPage> with RestorationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int days;
  late String phone;
  late int numberPeople;
  late String notes;
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());


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
      padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
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
          Hero(
            tag: "Rent Now",
            child: Text(
              '    ${S.of(context).rent_now_title}    ',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userProvider, child) => Form(
        key: _formKey,
        child: Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: userProvider.userCurrent!.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userProvider.userCurrent!.name,
                              style: Theme.of(context).textTheme.displayLarge),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'User',
                            style: GoogleFonts.readexPro(
                                color: Colors.grey,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            S.of(context).rent_now_rent_date,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            _restorableDatePickerRouteFuture.present();
                          },
                          icon: const Icon(
                            Icons.date_range_outlined,
                            color: Colors.blue,
                            size: 30,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.numbers_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).rent_now_number_date,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: '30',
                          validator: (value) {
                            // add email validation
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }

                            if (int.parse(value) < 1) {
                              return 'Min one day!';
                            }
                            days = int.parse(value);
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                            hintText: 'Days',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                       Text(
                        S.of(context).rent_now_day,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).rent_now_boarding_house,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          widget.room.name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_android_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).rent_now_phone,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: userProvider.userCurrent!.phone,
                          validator: (value) {
                            // add email validation
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }

                            if (value.length < 2) {
                              return 'Phone is so short!';
                            }
                            phone = value;
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                            hintText: 'Phone',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 90,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person_2_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).rent_now_number_of_people,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: '01',
                          validator: (value) {
                            // add email validation
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }

                            if (int.parse(value) < 1) {
                              return 'Min one People!';
                            }
                            numberPeople = int.parse(value);
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                            hintText: 'Number',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'People',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        S.of(context).rent_now_note,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: "",
                          validator: (value) {
                            // add email validation
                            notes = value!;
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                            hintText: 'Note somethings!',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Consumer<RentViewModel>(
                    builder: (context, rentProvider, child) => InkWell(
                      onTap: () async{
                        if (_formKey.currentState?.validate() ?? false) {
                          await rentProvider.createRent(
                              widget.room.hostID,
                              userProvider.userCurrent!.id,
                              userProvider.userCurrent!.name,
                              userProvider.userCurrent!.image,
                              widget.room.image,
                              phone,
                              widget.room.roomId,
                              widget.room.name,
                              days,
                              numberPeople,
                              notes);

                        }
                        if(rentProvider.isRent){
                          final snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            content: const Text('Rent Success!'),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }else{
                          final snackBar = SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: const Text('Rent failed!'),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            S.of(context).rent_now_rent,
                            style: GoogleFonts.readexPro(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2024),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
      });
    }
  }
}
