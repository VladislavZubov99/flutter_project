import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/domain/data_providers/json_data_provider.dart';
import 'package:project/domain/models/combination.dart';
import 'package:project/domain/models/fromJson.dart';

class CombinationsScreen extends StatelessWidget {
  const CombinationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      // drawer: const NavigationDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff1e988a),
        title: const Text('Combinations'),
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
            child: _CombinationsTable(),
          ),
        ),
      ),
    );
  }
}

class _CombinationsTable extends StatelessWidget {
  const _CombinationsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double crossAxisSpacing = 20;
    int crossAxisCount = 1;
    double width = (size.width - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;
    double cellHeight = 250;
    double aspectRatio = width / cellHeight;
    return FutureBuilder(
      future: JsonDataProvider().getCombinationsFromJson(),
      builder: (BuildContext context, AsyncSnapshot<Combinations> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final items = snapshot.requireData.items;
          if (items != null && items.isNotEmpty) {
            return GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    childAspectRatio: aspectRatio),
                itemBuilder: (BuildContext context, int index) {
                  final Combination combination = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xff1e988a).withOpacity(0.5),
                                offset: const Offset(0, 0),
                                blurRadius: 4)
                          ],
                          // borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child:
                            BuilderMobileTable(item: combination, keys: const [
                          'mainId',
                          'kdName',
                          "kdNumber",
                          "kdCity",
                          "kdStreet",
                        ])
                        ),
                  );
                });
          } else {
            return const Text('no items');
          }
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

class BuilderMobileTable extends StatelessWidget {
  FromJson item;
  List<String> keys;

  BuilderMobileTable({Key? key, required this.item, required this.keys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> json = item.toJson();

    final List<Widget> buildList = keys
        .map((String element) {
          if (json[element] != null) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getViewFromKey(element),
                    style: GoogleFonts.roboto(fontSize: 16),
                  ),
                  Text(
                    _getString(json[element]),
                    style: GoogleFonts.roboto(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return null;
          }
        })
        .where((element) => element != null)
        .cast<Widget>()
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: buildList,
    );
  }
}

String _getString(dynamic str) => str != null ? str.toString() : '_';

String _getViewFromKey(String key) {
  switch (key) {
    case 'mainId':
      return 'Payer mainId';
    case 'kdName':
      return 'Payer name';
    default:
      return key;
  }
}
