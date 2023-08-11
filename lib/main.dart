import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDsGPaZAOZoz-74JcdL9PARwuyKn1qTm58",
          projectId: "confirm-d2ee1",
          messagingSenderId: "199163217996",
          appId: "1:199163217996:web:e8d53d13145a4b534a4ce9"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GuestForm(),
    );
  }
}

class GuestForm extends StatefulWidget {
  const GuestForm({super.key});

  @override
  State<GuestForm> createState() => _GuestFormState();
}

class _GuestFormState extends State<GuestForm> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController guestCountController = TextEditingController();
  String currentUrii = "";
  String uid = "";
  List<String> docIds = [];

  @override
  void initState() {
    super.initState();
    getLinkData();
  }

  Future<void> getLinkData() async {
    final Uri currentUri = Uri.base;
    final Map<String, String> queryParameters = currentUri.queryParameters;

    setState(() {
      currentUrii = currentUri.toString();
      uid = queryParameters['uid'] ?? "the uid is null";

      final String docIdsString =
          queryParameters['docIds'] ?? "the docID is null or empty";
      docIds = docIdsString
          .split(','); // Split the comma-separated string into a list
    });
  }

  _submitForm({
    required String uid,
    required String guestID,
  }) async {
    if (guestCountController.text.isNotEmpty) {
      try {
        await firebaseFirestore
            .collection("ziv")
            .doc('1')
            .collection("companies")
            .doc(uid)
            .collection("cars")
            .doc(guestID)
            .update({'deleksum': int.parse(guestCountController.text)}).then(
                (value) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Form Submitted'),
                content: Text('Number of guests: ${guestCountController.text}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('error'),
              content: Text('$e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please enter number of people'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guests Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('currentUrii: $currentUrii'),
            Text('uid: $uid'),
            Text('docIds[0]: $docIds[0]'),
            TextField(
              controller: guestCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'How many people are coming?'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final Uri currentUri = Uri.base;
                final Map<String, String> queryParameters =
                    currentUri.queryParameters;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('queryParameters'),
                      content: Column(
                        children: [
                          Text('currentUri: ${currentUri}'),
                          Text('queryParameters: ${queryParameters}'),
                          Text('queryParametersuid: ${queryParameters['uid']}'),
                          Text(
                              'queryParametersdocIds: ${queryParameters['docIds']}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );

                // _submitForm(uid: uid, guestID: docIds[0]);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
