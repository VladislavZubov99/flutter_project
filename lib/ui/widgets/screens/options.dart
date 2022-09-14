import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/ui/app_settings/app_colors.dart';
import 'package:project/ui/navigation/main_navigation.dart';

class Options extends StatelessWidget {
  const Options({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      // drawer: const NavigationDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff1e988a),
        title: const Text('Options'),
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
            child: const OptionsTiles(),
          ),
        ),
      ),
    );
  }
}

class OptionsTiles extends StatelessWidget {
  const OptionsTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GridView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: [
        makeOption(
          title: 'Dashboard',
          icon: Icons.show_chart,
          onTap: () {
            Navigator.of(context)
                .pushNamed(MainNavigationRouteNames.dashboardManagementScreen);
          },
        ),
        makeOption(
          title: 'Dienstplane',
          icon: Icons.copy,
          onTap: () {
            Navigator.of(context)
                .pushNamed(MainNavigationRouteNames.combinationsScreen);
          },
        ),
        makeOption(
          title: 'Einstellungen',
          icon: Icons.settings_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget makeOption({
    required String title,
    required IconData icon,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  offset: const Offset(0, 0),
                  blurRadius: 4)
            ],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Icon(
                  icon,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              Center(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
