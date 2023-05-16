import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/rent_view_model.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/rent.dart';

class InteractManage extends StatefulWidget {
  const InteractManage({Key? key}) : super(key: key);

  @override
  State<InteractManage> createState() => _InteractManageState();
}

class _InteractManageState extends State<InteractManage> {
  bool show = true;
  @override
  void initState() {
// TODO: implement initState
    super.initState();

   (()async{
      Provider.of<RentViewModel>(context, listen: false).getListWaiting(
        Provider.of<UserViewModel>(context, listen: false).userCurrent!.id,0);
     Provider.of<RentViewModel>(context, listen: false).getListConfirm(
        Provider.of<UserViewModel>(context, listen: false).userCurrent!.id,1);
    await Provider.of<RentViewModel>(context, listen: false).getListUnConfirm(
        Provider.of<UserViewModel>(context, listen: false).userCurrent!.id,2);
        setState(() {
          show = false;
        });
   })();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar(context),
            info(context),
          ],
        ),
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
          Text(
            '    ${S.of(context).manage_rent_title} ',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget info(BuildContext context) {
    return  Consumer<RentViewModel>(
      builder: (context, rentProvider, child) =>show?const SizedBox() :Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              initiallyExpanded: rentProvider.listWaiting.isNotEmpty,
              title: Text(
                S.of(context).manage_rent_waiting,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.redAccent),
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  height: 250,
                  child: SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...rentProvider.listWaiting.map(
                              (e) => listItem(context,e),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ExpansionTile(
              initiallyExpanded: rentProvider.listConfirm.isNotEmpty,
              title: Text(
                S.of(context).manage_rent_confirmed,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.green),
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  height: 250,
                  child: SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...rentProvider.listConfirm.map(
                              (e) => listItem(context,e),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(
              height: 50,
            ),
            ExpansionTile(
              initiallyExpanded: rentProvider.listUnConfirm.isNotEmpty,
              title: Text(
                S.of(context).manage_rent_UnConfirmed,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.black54),
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  height: 250,
                  child: SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...rentProvider.listUnConfirm.map(
                              (e) => listItem(context,e),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(
    BuildContext context,Rent item
  ) {
    return GestureDetector(
      onTap: () {
        _dialogBuilder(context,item);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(left: 20),
        width: 300,
        height: 220,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.transparent,
                  blurRadius: 7,
                  offset: const Offset(2, 3))
            ]),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    item.image,
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
                    Text(item.name,
                        style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      S.of(context).rent_now_user,
                      style: GoogleFonts.readexPro(
                          color: Colors.grey, fontWeight: FontWeight.w300),
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
                 Expanded(
                   child: Text(
                    item.dateCreate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:const TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                ),
                 )
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
                  S.of(context).manage_rent_number,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    "${item.numberDaysRented}${S.of(context).manage_day_rent}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.readexPro(
                        fontSize: 17, fontWeight: FontWeight.w200),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
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
                    item.roomName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:const TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                ),
                 )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(
    BuildContext context,Rent item
  ) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Consumer<UserViewModel>(
            builder: (context, userProvider, child) =>  Consumer<RentViewModel>(
              builder: (context, rentProvider, child) => AlertDialog(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).manage_rent_detail,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.exit_to_app_outlined))
                    ]),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            item.image,
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
                            Text(item.name,
                                style: Theme.of(context).textTheme.displayLarge),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              S.of(context).rent_now_user,
                              style: GoogleFonts.readexPro(
                                  color: Colors.grey, fontWeight: FontWeight.w300),
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
                         Expanded(
                           child: Text(
                            item.dateCreate,
                            overflow: TextOverflow.ellipsis,
                            style:const
                                TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                         )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
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
                          S.of(context).manage_rent_number,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${item.numberDaysRented} days rental',
                          style: GoogleFonts.readexPro(
                              fontSize: 17, fontWeight: FontWeight.w200),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
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
                             item.roomName,
                            style:const
                                TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                         )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              width: 5,
                            ),
                             Text(
                              item.phone,
                              style:const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.call_outlined,
                              color: Colors.blue,
                              size: 30,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          width: 5,
                        ),
                         Expanded(
                          child: Text(
                            item.note,
                            style:const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                actions: [
                  item.isConfirmed==0? InkWell(
                    onTap: ()async{
                      await rentProvider.unConfirm(userProvider.userCurrent!.id,item.id);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'UnConfirm',
                          style: GoogleFonts.readexPro(color: Colors.white),
                        ),
                      ),
                    ),
                  ):const SizedBox(),
                  item.isConfirmed==0? InkWell(
                    onTap: ()async{
                      await rentProvider.confirm(userProvider.userCurrent!.id,item.id);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.readexPro(color: Colors.white),
                        ),
                      ),
                    ),
                  ):const SizedBox(),
                ],
              ),
            ),
          );
        });
  }
}
