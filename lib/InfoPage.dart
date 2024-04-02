// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class InfoPage extends StatefulWidget {
//   @override
//   _InfoPageState createState() => _InfoPageState();
// }

// class _InfoPageState extends State<InfoPage> {
//   late TextEditingController _fullNameController;
//   late TextEditingController _branchController;
//   late TextEditingController _passingYearController;
//   late TextEditingController _prnNumberController;
//   late List<Map<String, dynamic>> _userInfo;

//   @override
//   void initState() {
//     super.initState();
//     _fullNameController = TextEditingController();
//     _branchController = TextEditingController();
//     _passingYearController = TextEditingController();
//     _prnNumberController = TextEditingController();
//     _userInfo = [];
//   }

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _branchController.dispose();
//     _passingYearController.dispose();
//     _prnNumberController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Info Page'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _fullNameController,
//               decoration: InputDecoration(labelText: 'Full Name'),
//             ),
//             TextField(
//               controller: _branchController,
//               decoration: InputDecoration(labelText: 'Branch'),
//             ),
//             TextField(
//               controller: _passingYearController,
//               decoration: InputDecoration(labelText: 'Passing Year'),
//             ),
//             TextField(
//               controller: _prnNumberController,
//               decoration: InputDecoration(labelText: 'PRN Number'),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Store data in database and display in container
//                 storeAndDisplayData(context);
//               },
//               child: Text('Submit'),
//             ),
//             SizedBox(height: 20.0),
//             _userInfo.isNotEmpty
//                 ? Container(
//                     padding: EdgeInsets.all(16.0),
//                     color: Colors.blue.withOpacity(0.1),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: _userInfo.map((info) {
//                         return Container(

//                             // crossAxisAlignment: CrossAxisAlignment.start,
//                             child: Column(
//                           children: [
//                             Text('Full Name: ${info['fullName']}'),
//                             Text('Branch: ${info['branch']}'),
//                             Text('Passing Year: ${info['passingYear']}'),
//                             Text('PRN Number: ${info['prnNumber']}'),
//                             const SizedBox(height: 16.0),
//                           ],
//                         ));
//                       }).toList(),
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//           ],
//         ),
//       ),
//     );
//   }

//   void storeAndDisplayData(BuildContext context) async {
//     final String fullName = _fullNameController.text.trim();
//     final String branch = _branchController.text.trim();
//     final String passingYear = _passingYearController.text.trim();
//     final String prnNumber = _prnNumberController.text.trim();

//     // Open database
//     final Database database = await openDatabase(
//       join(await getDatabasesPath(), 'my_custom_database.db'),
//       version: 1,
//     );

//     // Create the 'my_custom_table' table if it doesn't exist
//     await database.execute(
//       'CREATE TABLE IF NOT EXISTS my_custom_table('
//       'id INTEGER PRIMARY KEY AUTOINCREMENT, '
//       'fullName TEXT, '
//       'branch TEXT, '
//       'passingYear TEXT, '
//       'prnNumber TEXT)',
//     );

//     // Insert user info into the custom table
//     await database.transaction((txn) async {
//       await txn.rawInsert(
//         'INSERT INTO my_custom_table(fullName, branch, passingYear, prnNumber) '
//         'VALUES("$fullName", "$branch", "$passingYear", "$prnNumber")',
//       );
//     });

//     // Fetch stored data
//     final List<Map<String, dynamic>> userInfo =
//         await database.query('my_custom_table');

//     setState(() {
//       _userInfo = userInfo;
//     });

//     // Clear input fields
//     _fullNameController.clear();
//     _branchController.clear();
//     _passingYearController.clear();
//     _prnNumberController.clear();
//   }
// }

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late TextEditingController _fullNameController;
  late TextEditingController _branchController;
  late TextEditingController _passingYearController;
  late TextEditingController _prnNumberController;
  late List<Map<String, dynamic>> _userInfo;

  bool _infoFilled = false; // Flag to track if info is already filled

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _branchController = TextEditingController();
    _passingYearController = TextEditingController();
    _prnNumberController = TextEditingController();
    _userInfo = [];
    _checkInfoFilledStatus();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _branchController.dispose();
    _passingYearController.dispose();
    _prnNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Page'),
      ),
      body: _infoFilled ? InfoFilledPage() : InfoFormPage(),
    );
  }

  void _checkInfoFilledStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _infoFilled = prefs.getBool('info_filled') ?? false;
    });
  }

  void _setInfoFilledStatus(bool filled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('info_filled', filled);
    setState(() {
      _infoFilled = filled;
    });
  }
}

class InfoFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Full Name'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Branch'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Passing Year'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'PRN Number'),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Store data in database and display in container
              // For demonstration purpose, calling _setInfoFilledStatus(true)
              // to indicate the info is filled.
              _setInfoFilledStatus(true);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class InfoFilledPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('You have already filled out the information.'),
    );
  }
}
