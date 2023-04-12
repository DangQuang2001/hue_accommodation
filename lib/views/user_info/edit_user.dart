import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hue_accommodation/views/user_info/user_info.dart';
import 'package:provider/provider.dart';
import '../../view_models/user_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String email;
  late String password;
  late String image;
  late String phone;
  late String address;
  late bool isGoogle;

  List<bool> isChanged = [false, false, false, false, false];
  @override
  void initState() {
// TODO: implement initState
    super.initState();

    var user = Provider.of<UserProvider>(context, listen: false);
    name = user.userCurrent!.name;
    email = user.userCurrent!.email;
    password = user.userCurrent!.password;
    image = user.userCurrent!.image;
    phone = user.userCurrent!.phone;
    address = user.userCurrent!.address;
    isGoogle = user.userCurrent!.isGoogle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              header(context),
              const SizedBox(
                height: 40,
              ),
              avatar(context),
              content(context)
            ],
          ),
        ),
      ),

      floatingActionButton:isChanged.contains(true)? Consumer<UserProvider>(
        builder: (context, userProvider, child) =>  FloatingActionButton(
          onPressed: (){
            if (_formKey.currentState!.validate()) {
              (() async {
                await userProvider.updateUser(userProvider.userCurrent!.id,name, email, password, image,
                    phone,address, userProvider.userCurrent!.isGoogle,userProvider.userCurrent!.isHost);
                if (userProvider.isUpdate) {
                  // ignore: use_build_context_synchronously
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const UserInfoPage()),
                  //         (route) => false);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: const Text('Cap nhat thanh cong!'),
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
                else{
                  final snackBar = SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: const Text('Cap nhat that bai!'),
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
              })();
            }
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child:const  Icon(
            Icons.save_outlined,
            color: Colors.white,
          ),

        ),
      ):null,
    );
  }

  header(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 40, right: 10),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:  Icon(
                    Icons.arrow_back_outlined,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  avatar(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) =>  Stack(children: [
        CircularBorder(
          width: 2.5,
          size: 160,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: CachedNetworkImage(
              imageUrl:
              userProvider.userCurrent == null
                  ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                  : userProvider.userCurrent!.image == ""
                  ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                  : userProvider.userCurrent!.image
              ,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
        userProvider.userCurrent==null?const Text(''):
        Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).colorScheme.primary),
              child: const Center(
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ))
      ]),
    );
  }

  content(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value){
                      if(value!=name){
                        setState(() {
                          isChanged[0]=true;
                        });
                      }
                      else{
                        setState(() {
                          isChanged[0]=false;
                        });
                      }
                    },
                      initialValue: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        RegExp regex = RegExp(
                            r'^[a-zA-Z0-9.a-zA-Z0-9+" "+ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂ ưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+$');
                        if (value!.length < 2 || value.length > 50) {
                          return "Vui lòng nhập tên ít nhất 2 ký tự và không quá 50 ký tự";
                        }
                        if (!regex.hasMatch(value)) {
                          return "Tên không được chứa ký tự đặc biệt!";
                        }
                        name = value;
                        return null;
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value){
                      if(value!=email){
                        setState(() {
                          isChanged[1]=true;
                        });
                      }
                      else{
                        setState(() {
                          isChanged[1]=false;
                        });
                      }
                    },
                    initialValue: email,
                    enabled: !isGoogle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {

                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      bool emailValid = RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter a valid email';
                      }

                      email = value;
                      return null;
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value){
                      if(value!=address){
                        setState(() {
                          isChanged[2]=true;
                        });
                      }
                      else{
                        setState(() {
                          isChanged[2]=false;
                        });
                      }
                    },
                    initialValue: address,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {

                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      address = value;
                      return null;
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value){
                      if(value!=phone){
                        setState(() {
                          isChanged[3]=true;
                        });
                      }
                      else{
                        setState(() {
                          isChanged[3]=false;
                        });
                      }
                    },
                    initialValue: phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      phone = value!;
                      return null;
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style:Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value){
                      if(value!=password){
                        setState(() {
                          isChanged[4]=true;
                        });
                      }
                      else{
                        setState(() {
                          isChanged[4]=false;
                        });
                      }
                    },
                    initialValue: password,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText:
                          password == null ? "Vui lòng nhập mật khẩu" : null,
                    ),
                    validator: (value) {
                      if (value!.length < 5) {
                        return "Vui lòng nhập mật khẩu dài hơn!";
                      }
                      password = value;
                      return null;
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
