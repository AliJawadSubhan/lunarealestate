import 'package:flutter/material.dart';
import 'package:lunarestate/Pages/Splash/SplashPage.dart';
import 'package:lunarestate/Widgets/customAppBar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/config.dart';
import '../../Service/UserData.dart';
import '../ForgetPass/ForgetPass.dart';
import 'AcInfo.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  Future<bool> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CustomAppBarwithBackButton('Profile'),
            ];
          },
          body: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  child: Hero(
                    tag: 'profileImage',
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        Provider.of<UserData>(context, listen: true)
                            .profile
                            .toString(),
                      ),
                      onBackgroundImageError: (exception, stackTrace) {
                        Icon(
                          Icons.broken_image,
                          color: Colors.red,
                          size: 30,
                        );
                      },
                      radius: 30,
                    ),
                  ),
                  height: 125,
                  width: 125,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  Provider.of<UserData>(context, listen: false).name.toString(),
                  style: TextStyle(color: Colors.white, fontFamily: 'Satisfy'),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AccountInfo();
                      },
                    ));
                  },
                  title: Text(
                    'Account Information',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: Icon(
                    Icons.account_box,
                    color: Colors.white,
                  ),
                  trailing: Icon(
                    Icons.arrow_right_alt,
                    color: mainColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ForgetMyPass(title: 'Change Password'),
                        isIos: true,
                        duration: Duration(milliseconds: 800),
                      ),
                    );
                  },
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: Icon(
                    Icons.password,
                    color: Colors.white,
                  ),
                  trailing: Icon(
                    Icons.arrow_right_alt,
                    color: mainColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () async {
                    var res = await clear();
                    if (res) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return SplashPage();
                        },
                      ));
                    }
                    // FutureBuilder(
                    //   future: clear(),
                    //   builder: (context, snapshot) {
                    //     print('log ${snapshot.data}');
                    //     if (snapshot.data == true) {
                    //       Navigator.of(context)
                    //           .popUntil((route) => route.isFirst);
                    //       Navigator.pushReplacement(context, MaterialPageRoute(
                    //         builder: (context) {
                    //           return SplashPage();
                    //         },
                    //       ));
                    //     }
                    //     return Container();
                    //   },
                    // );
                  },
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  trailing: Icon(
                    Icons.arrow_right_alt,
                    color: mainColor,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            decoration: BoxDecoration(
                color: Color(0xff141414),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                )),
            height: size.height,
            width: double.infinity,
          ),
        ),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/images/tower.jpg',
          ),
          opacity: 0.2,
          fit: BoxFit.cover,
        )),
      ),
      backgroundColor: Colors.black,
    );
  }
}
