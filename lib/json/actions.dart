import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../login.dart';

class WorkOrder extends StatefulWidget {
  const WorkOrder({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<WorkOrder> {
  Future<void> signUserOut(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  int currentItemIndex = 0;
  String selectedReason = 'stå still'; // Initial reason
  List<String> reasons = [
    "stå still",
    "lägg till smörj punkt",
    "ta bort smörj punkt",
    "trasig smörj punkt"
  ]; // List of reasons

  final List<Map<String, String>> _items = [];

  // Load JSON data when the widget is first built
  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  // Fetch content from the JSON file
// Fetch content from the JSON file
  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/simple.json');
    Map<String, dynamic> data = json.decode(response);

    // Access the values of "MCH_CODE" and "WORK_DESCR" for each "ACTION"
    List<dynamic> actions = data["RESULT"]["WORK_ORDER"]["ACTIONS"]["ACTION"];
    for (var action in actions) {
      String mchCode = action["MCH_CODE"];
      String testPointDescr = action["TEST_POINT_DESCR"];

      String workDescr;

      if (action["WORK_DESCR"] is Map) {
        continue;
      } else {
        workDescr = action["WORK_DESCR"];
        // Extract the integer followed by "g" from the "WORK_DESCR" field
        RegExp regex = RegExp(r'(\d+) g');
        RegExpMatch? match = regex.firstMatch(workDescr);

        if (match != null) {
          String? integerWithG = match.group(1); // Extract the matched integer

          if (integerWithG != null) {
            // Check if integerWithG is not null
            String concatenatedString =
                testPointDescr + " , " + integerWithG + "g";
            _items.add({"MCH_CODE": mchCode, "WORK_DESCR": concatenatedString});
          }
        }
      }
    }

    setState(() {}); // Notify the UI to update
  }

  // Function to handle item removal
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      // Remove the item from the list
      Map<String, String> removedItem = _items.removeAt(index);

      // Save the removed item to a JSON file
      saveRemovedItemToJson(removedItem);
    }
  }

  // Function to save removed items to a JSON file
  Future<void> saveRemovedItemToJson(Map<String, String> item) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/trash/removed_items.json');

    // Read the existing file or create a new list
    List<Map<String, String>> removedItems = [];

    if (await file.exists()) {
      final existingData = await file.readAsString();
      removedItems = List<Map<String, String>>.from(json.decode(existingData));
    }

    // Add the removed item
    removedItems.add(item);

    // Write the updated list to the file
    await file.writeAsString(json.encode(removedItems));
  }

  bool isCardTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          if (_items.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        isCardTapped =
                        true; // Set isCardTapped to true when card is tapped
                      });
                    },
                    child: Card(
                      key: ValueKey(index),
                      margin: const EdgeInsets.all(10),
                      color: Colors.amber.shade100,
                      child: Column(
                        children: [
                          ListTile(
                            title:
                            Text("MCH_CODE: ${_items[index]["MCH_CODE"]}"),
                            subtitle: Text(
                                "WORK_DESCR: ${_items[index]["WORK_DESCR"]}"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Text("Loading..."),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              isCardTapped
                  ? Container(
                width: 175,
                height: 40,
                // Use a container to change the color of the "Next" button
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: TextButton(
                  onPressed: () {
                    if (currentItemIndex < _items.length - 1) {
                      setState(() {
                        currentItemIndex++;
                        selectedReason =
                        'Reason 1'; // Reset the selected reason
                      });
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        color: Colors
                            .white), // Change the text color to white
                  ),
                ),
              )
                  : const TextButton(
                onPressed:
                null, // Button is disabled if isCardTapped is false
                child: Text('Next'),
              ),
              DropdownButton<String>(
                value: selectedReason,
                items: reasons.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedReason = newValue!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
