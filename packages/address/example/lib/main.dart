import 'package:address_dart/address.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location = Location();
  List data = [];

  String text = "";

  String provinceName = '';
  String postalCode = '';
  String districtName = '';
  String subDistrictName = '';

  void getData() {
    data = location.execute(DatabaseSchemaQuery(
      provinceName: provinceName,
      postalCode: postalCode,
      districtName: districtName,
      subDistrictName: subDistrictName,
    ));
    setState(() {});
  }

  List<String> item(String key) {
    if (data.isEmpty) return [];
    return data.map((e) => (e.toJson()[key]) as String).toSet().toList();
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(' แขวง/ตำบล'),
                        const SizedBox(height: 4),
                        AutocompleteB(
                          items: item('subDistrictName'),
                          initialValue: subDistrictName,
                          onSelected: (p0) {
                            subDistrictName = p0;
                            getData();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' เขต/อำเภอ',
                        ),
                        const SizedBox(height: 4),
                        AutocompleteB(
                          items: item('districtName'),
                          initialValue: districtName,
                          onSelected: (p0) {
                            districtName = p0;
                            getData();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' จังหวัด',
                        ),
                        const SizedBox(height: 4),
                        AutocompleteB(
                          items: item('provinceName'),
                          initialValue: provinceName,
                          onSelected: (p0) {
                            provinceName = p0;
                            getData();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' รหัสไปรษณีย์',
                        ),
                        const SizedBox(height: 4),
                        AutocompleteB(
                          items: item('postalCode'),
                          initialValue: postalCode,
                          onSelected: (p0) {
                            postalCode = p0;
                            getData();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                ' ประเทศ',
              ),
              const SizedBox(height: 4),
              const AutocompleteB(
                isFull: true,
                items: ['ไทย'],
                initialValue: 'ไทย',
              ),
              const SizedBox(height: 10),
              Text(text),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            List listData = location.execute(DatabaseSchemaQuery(
              provinceName: provinceName,
              postalCode: postalCode,
              districtName: districtName,
              subDistrictName: subDistrictName,
            ));
            if (listData.length == 1) {
              text = "${listData.first.toJson()}";
              setState(() {});
            } else {
              text =
                  "{provinceName:$provinceName,postalCode:$postalCode,districtName:$subDistrictName,subDistrictName:$districtName}";
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}

class AutocompleteB extends StatelessWidget {
  final List<String> items;
  final String initialValue;
  final bool isFull;
  final Function(String)? onSelected;
  const AutocompleteB({
    super.key,
    required this.items,
    this.isFull = false,
    this.onSelected,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      initialValue: TextEditingValue(text: initialValue),
      onSelected: onSelected,
      optionsBuilder: (textEditingValue) {
        print(textEditingValue.text);
        if (textEditingValue.text.isEmpty) {
          return items;
        }
        return items.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      optionsViewBuilder: (context, onSelected, options) {
        double width = MediaQuery.of(context).size.width - 205;
        if (isFull) width = MediaQuery.of(context).size.width;
        return Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: BoxConstraints(
              maxHeight: 272,
              maxWidth: width,
              minWidth: width,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: options.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                final option = options.elementAt(index);
                return InkWell(
                  onTap: () => onSelected(option),
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(
                      option,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 1,
                  color: const Color(0xFFE5E5E5),
                );
              },
            ),
          ),
        );
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onTapOutside: (event) {
            onSelected!(textEditingController.text);
          },
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(8),
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            hintText: 'เพิ่ม',
          ),
        );
      },
    );
  }
}
