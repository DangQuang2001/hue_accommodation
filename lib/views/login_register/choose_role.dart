import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class ChooseRolePage extends StatefulWidget {
  final String email;
  const ChooseRolePage({Key? key, required this.email}) : super(key: key);

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        backgroundColor:Theme.of(context).colorScheme.onBackground ,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100,),
              Center(child: Text('CHOOSE ROLE',style: GoogleFonts.readexPro(fontSize: 25,letterSpacing: 1.5,fontWeight: FontWeight.w600),)),
              const SizedBox(height: 60,),
              Center(child: Image.asset('assets/images/chooserole.png',width: 300,height: 200,fit: BoxFit.cover,)),
              const SizedBox(height: 60,),
              Text('Hello!',style: GoogleFonts.readexPro(fontSize: 30,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              Text('Welcome to Hue Accommodation',style: GoogleFonts.readexPro(fontSize: 22,fontWeight: FontWeight.w400),),
              const SizedBox(height: 40,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(onPressed: ()async{
                    await userProvider.updateRole(widget.email, true);
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(context, RouteName.home,(route) => false,);
                  }, child: Text('I AM THE OWNER',style: GoogleFonts.readexPro(fontSize: 15,letterSpacing: 1.5),))),
              const SizedBox(height: 30,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(onPressed: ()async{
                    await userProvider.updateRole(widget.email, false);
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(context, RouteName.home,(route) => false,);
                  }, child: Text('I WANT TO FIND BOARDING HOUSE',style: GoogleFonts.readexPro(fontSize: 15,letterSpacing: 1.5),))),
              const SizedBox(height: 20,),
              Center(child: TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Back',style: GoogleFonts.readexPro(fontSize: 15,letterSpacing: 1.2),)))
            ],
          ),
        ),
      ),
    );
  }
}
