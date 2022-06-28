import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/data_providers/json_data_provider.dart';
import 'package:project/domain/models/tenant.dart';
import 'package:project/domain/utils/color_extention.dart';
import 'package:project/ui/navigation/main_navigation.dart';
import 'package:project/ui/widgets/screens/auth/login_widget.dart';
import 'package:project/ui/widgets/navigation_drawer/navigation_drawer.dart';

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
        backgroundColor: const Color(0xff1e988a),
        title: const Text('Home page'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_wave.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const TenantTiles(),
          ),
        ),
      ),
    );
  }
}

class TenantTiles extends StatelessWidget {
  const TenantTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final jsonDataProvider = JsonDataProvider();
    return FutureBuilder(
      future: jsonDataProvider.getTenantFromJson(),
      builder: (BuildContext context, AsyncSnapshot<List<Tenant>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GridView.builder(
            itemCount: snapshot.requireData.length,
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              final Tenant tenant = snapshot.requireData[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(MainNavigationRouteNames.modulesScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff1e988a).withOpacity(0.5),
                            offset: const Offset(0, 0),
                            blurRadius: 4)
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: SizedBox(
                            height: size.width * 0.2,
                            width: size.width * 0.2,
                            child: SvgPicture.asset(
                                'assets/saphir_diamond_logo.svg'),
                          ),
                        ),
                        Center(
                          child: Text(
                            tenant.name,
                            style: GoogleFonts.roboto(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: HexColor.fromHex(tenant.color),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Text('Cannot load data, try it again later');
        }
      },
    );
  }
}
