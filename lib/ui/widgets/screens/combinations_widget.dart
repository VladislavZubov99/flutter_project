import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/data_providers/json_data_provider.dart';
import 'package:project/domain/models/combination.dart';
import 'package:project/domain/models/fromJson.dart';
import 'package:project/ui/widgets/accordion_widget.dart';
import 'package:project/ui/widgets/custom_checkbox/custom_checkbox.dart';
import 'package:project/ui/widgets/date_time_format.dart';
import 'package:provider/provider.dart';

class _SearchStorage {
  String search = "";
}

class CombinationsScreen extends StatelessWidget {
  const CombinationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CombinationsNotifier>(
            create: (_) => CombinationsNotifier()),
        Provider<_SearchStorage>(create: (_) => _SearchStorage()),
      ],
      child: Scaffold(
        // drawer: const NavigationDrawer(),
        backgroundColor: Colors.transparent,
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
              child: Column(
                children: [
                  _Search(),
                  Flexible(flex: 1, child: _CombinationsTable()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Search extends StatelessWidget {
  const _Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchStorage = context.read<_SearchStorage>();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: TextField(
            onChanged: (value) => searchStorage.search = value,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search by payer...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Accordion(
          title: 'Filters',
          child: Column(
            children: const [
              DateTimeFormat(),
              ListTile(
                leading: CustomCheckbox(
                  initialIsChecked: true,
                ),
                title: Text('Positive'),
                horizontalTitleGap: 0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
              ListTile(
                leading: CustomCheckbox(
                  initialIsChecked: true,
                ),
                title: Text('Negative'),
                horizontalTitleGap: 0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
              ListTile(
                leading: CustomCheckbox(
                  initialIsChecked: true,
                ),
                title: Text('Zero'),
                horizontalTitleGap: 0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
              Divider(
                height: 5,
              ),
              ListTile(
                leading: CustomCheckbox(
                  initialIsChecked: true,
                ),
                title: Text('In Progress'),
                horizontalTitleGap: 0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CombinationsNotifier>(context,
                                listen: false)
                            .fetchNewCombinations(
                                searchValue: searchStorage.search);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xff1e988a)),
                      ),
                      child: const Text('Load data')),
                ),
              )
            ],
          ),
        ),
        Consumer<CombinationsNotifier>(builder: (_, combinationsModel, __) {
          bool hasData;
          if (combinationsModel.combinations.total != null &&
              combinationsModel.loading != true &&
              combinationsModel.combinations.pageSize != null &&
              combinationsModel.combinations.items!.isNotEmpty) {
            hasData = true;
          } else {
            hasData = false;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hasData
                    ? 'Total: ${combinationsModel.combinations.total}'
                    : 'Total: --'),
                Text(hasData
                    ? '1 - ${combinationsModel.combinations.pageSize! > combinationsModel.combinations.total! ? combinationsModel.combinations.total : combinationsModel.combinations.pageSize} of ${combinationsModel.combinations.total} '
                    : '-- of --')
              ],
            ),
          );
        })
      ],
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

    return Consumer<CombinationsNotifier>(
        builder: (context, combinationsModel, __) {
      if (combinationsModel.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (combinationsModel.hasData) {
        final items = combinationsModel.combinations.items;

        return GridView.builder(
            itemCount: items!.length,
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
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(0, 0),
                            blurRadius: 4)
                      ],
                      // borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: BuilderMobileTable(item: combination, keys: const [
                      'mainId',
                      'kdName',
                      "kdNumber",
                      "kdCity",
                      "kdStreet",
                    ])),
              );
            });
      } else {
        return const Text('No data');
      }
    });
  }
}

class BuilderMobileTable extends StatelessWidget {
  final FromJson item;
  final List<String> keys;

  const BuilderMobileTable({Key? key, required this.item, required this.keys})
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
                    _getString(json[element]).trim(),
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



