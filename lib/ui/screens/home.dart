import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/data_providers/session_data_provider.dart';
import 'package:project/ui/navigation/main_navigation.dart';
import 'package:project/ui/widgets/auth/login_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getUserData() async {
    dynamic userRes;
    userRes = await _apiClient.getProfile();
    return userRes;
  }

  Future<void> logout() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: const NavigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff1e988a),
          title: const Text('Home page'),
        ),
        body: SafeArea(
          child: SizedBox(
              width: size.width,
              height: size.height,
              child: Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/background_wave.png'),
                  fit: BoxFit.cover,
                )),
              )),
        ));
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: buildHeader(context),
            ),
            Expanded(child: buildMenuItems(context))
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ListTile(
      leading: Container(
        width: size.width * 0.1,
        height: size.width * 0.1,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0xff1e988a), offset: Offset(0, 0), blurRadius: 4)
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: SvgPicture.asset('assets/saphir_diamond_logo.svg'),
        ),
      ),
      title: Text(
        'Saphir Software',
        style: GoogleFonts.robotoMono(
            color: const Color(0xff1e988a), fontSize: 20),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final SessionDataProvider sessionDataProvider = SessionDataProvider();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(
              'Home',
              style: GoogleFonts.roboto(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainNavigationRouteNames.mainScreen, (route) => false);
            },
          ),
        ),
        const Divider(height: 4),
        Expanded(child: Container()),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: ListTile(
            leading: const Icon(
              Icons.power_settings_new,
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.roboto(
                fontSize: 16,
              ),
            ),
            onTap: () async {
              NavigatorState state = Navigator.of(context);
              await sessionDataProvider.deleteAccessToken();
              MainNavigation.resetNavigation(state);
            },
          ),
        ),
        const _UserProfile(),
      ],
    );
  }
}

class _UserProfile extends StatelessWidget {
  const _UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      decoration: const BoxDecoration(
        color: Color(0xff1e988a),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.person_outlined,
          size: 40.0,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Max Ryt',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Text(
              'mrytwinski@saphir-software.de',
              style: GoogleFonts.roboto(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
