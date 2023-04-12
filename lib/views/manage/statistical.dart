import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticalManage extends StatefulWidget {
  const StatisticalManage({Key? key}) : super(key: key);

  @override
  State<StatisticalManage> createState() => _StatisticalManageState();
}

class _StatisticalManageState extends State<StatisticalManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: GestureDetector(
          onTap: () => _dialogBuilder(context),
          child: Text("Show Dialog"),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(
                child: Text(
              "Scanned Success",
              style: GoogleFonts.readexPro(color: Colors.green),
            )),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        'https://antimatter.vn/wp-content/uploads/2022/10/hinh-nen-gai-xinh.jpg',
                        height: 170,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Phong tro Tuy Ly Vuong',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.readexPro(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '102 Tuy ly vuong',
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
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(20),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.network(
                                'https://cdn-icons-png.flaticon.com/512/1150/1150643.png'),
                          ),
                          Text(
                            'Detail',
                            style: GoogleFonts.readexPro(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 70,
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(20),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.network(
                                'https://cdn-icons-png.flaticon.com/512/2065/2065224.png'),
                          ),
                          Text(
                            'Review',
                            style: GoogleFonts.readexPro(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
