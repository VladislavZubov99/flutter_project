import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(MainNavigationRouteNames.combinationsScreen);
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
                    const Center(
                      child: Icon(
                        Icons.copy,
                        size: 80,
                        color: Color(0xff1e988a),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Dienstplane',
                        style: GoogleFonts.roboto(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
          Padding(
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
                  const Center(
                    child: Icon(
                      Icons.settings_outlined,
                      size: 80,
                      color: Color(0xff1e988a),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Einstellungen',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
    );
  }
}
