import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/core/api_client.dart';
import 'package:project/ui/navigation/main_navigation.dart';
import 'package:project/ui/widgets/auth/login_widget.dart';

import '../../domain/data_providers/session_data_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient _apiClient = ApiClient();
  final SessionDataProvider _sessionDataProvider = SessionDataProvider();

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
      backgroundColor: Colors.white,
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: FutureBuilder<Map<String, dynamic>>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.blueGrey,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                String fullName = 'Johny Depp';

                if (snapshot.data!['name'] != null ||
                    snapshot.data!['surname'] != null) {
                  fullName =
                      '${snapshot.data!['name']} ${snapshot.data!['surname']}';
                }
                String firstName = snapshot.data!['name'] ?? 'Johny';
                String lastName = snapshot.data!['surname'] ?? 'Depp';
                String email = snapshot.data!['email'];

                return Container(
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/background_wave.png'),
                    fit: BoxFit.cover,
                  )),
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const _HeaderName(),
                          _LogoutRow(),
                        ],
                      )),
                );
              } else {
                // debugPrint(snapshot.error.toString());
              }
              return const SizedBox();
            },
          )),
    );
  }
}

class _HeaderName extends StatelessWidget {
  const _HeaderName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: size.width,
          height: 140,
          decoration: const BoxDecoration(
            color: Color(0xff1e988a),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Row(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Icon(
                      Icons.person_outlined,
                      size: 80.0,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Max Ryt',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 7),
                  Text('mrytwinski@saphir-software.de',
                      style: TextStyle(fontSize: 19, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutRow extends StatelessWidget {
  final SessionDataProvider _sessionDataProvider = SessionDataProvider();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: size.width,
          height: 140,
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 20,
                offset: Offset(0, 0),
                blurStyle: BlurStyle.normal)
          ]),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    right: 15.0,
                    left: 10.0,
                    bottom: 10.0,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.power_settings_new,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _sessionDataProvider.deleteAccessToken();
                  MainNavigation.resetNavigation(context);
                },
                child: Text(
                  'Logout',
                  style:
                      GoogleFonts.robotoMono(color: Colors.blue, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OldHomeWidget extends StatelessWidget {
  final SessionDataProvider _sessionDataProvider = SessionDataProvider();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(5),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(width: 1, color: Colors.blue.shade100),
              ),
              child: Container(
                height: 100,
                width: 100,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Image(
                    image: AssetImage('assets/image.png'), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Johny Depp',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              '123@test.ru',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white54, borderRadius: BorderRadius.circular(5)),
            child: const Text('PROFILE DETAILS',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 20),
          Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
                color: const Color(0xFF48484A),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('First Name:',
                    style: TextStyle(fontSize: 16, color: Colors.white38)),
                SizedBox(height: 7),
                Text('johny',
                    style: TextStyle(fontSize: 19, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
                color: const Color(0xFF48484A),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Last Name:',
                    style: TextStyle(fontSize: 16, color: Colors.white38)),
                SizedBox(height: 7),
                Text('Depp',
                    style: TextStyle(fontSize: 19, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 60),
          TextButton(
            onPressed: () async {
              await _sessionDataProvider.deleteAccessToken();
              MainNavigation.resetNavigation(context);
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent.shade700,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
