import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const SafeApp());

class SafeApp extends StatelessWidget {
  const SafeApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SafeWalk',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
        home: const SetupScreen(),
      );
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final destination = TextEditingController();
  final codeWord = TextEditingController();
  final contact = TextEditingController();
  TimeOfDay? arrival;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Set up journey')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(children: [
            TextField(
                controller: destination,
                decoration: const InputDecoration(labelText: 'Where are you going?')),
            const SizedBox(height: 12),
            ListTile(
              title: Text(arrival == null
                  ? 'Pick arrival time'
                  : 'Arrive by ${arrival!.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final t = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (t != null) setState(() => arrival = t);
              },
            ),
            TextField(
                controller: codeWord,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Secret code word')),
            const SizedBox(height: 12),
            TextField(
                controller: contact,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: 'Trusted contact phone')),
            const SizedBox(height: 24),
            FilledButton(
  onPressed: () async {
    if (destination.text.isEmpty ||
        codeWord.text.isEmpty ||
        arrival == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in destination, time and code word'),
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/journey/start'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': 'demo_user',
        'destination': destination.text,
        'arrival_time': arrival!.format(context),
        'code_word': codeWord.text,
      }),
    );

    if (response.statusCode == 200) {
  final data = jsonDecode(response.body);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CodeWordScreen(
        journeyId: data['journey_id'],
      ),
    ),
  );
} else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not start journey'),
        ),
      );
    }
  },
  child: const Text('Start journey'),
),
          ]),
        ),
      );
}
class CodeWordScreen extends StatefulWidget {
  final String journeyId;

  const CodeWordScreen({
    super.key,
    required this.journeyId,
  });

  @override
  State<CodeWordScreen> createState() => _CodeWordScreenState();
}

class _CodeWordScreenState extends State<CodeWordScreen> {
  final responseController = TextEditingController();
  bool loading = false;
  Future<void> sendLocation() async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/location'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'journey_id': widget.journeyId,
      'latitude': 12.9716,
      'longitude': 77.5946,
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live location updated'),
      ),
    );
  }
}

  Future<void> submitCodeWord() async {
    setState(() {
      loading = true;
    });

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/journey/respond'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'journey_id': widget.journeyId,
        'response': responseController.text,
      }),
    );

    final data = jsonDecode(response.body);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200 && data['status'] == 'safe') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correct code word. You are safe!'),
        ),
      );
    } else if (response.statusCode == 200 &&
        data['status'] == 'wrong_code') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect code word. Tier 1 alert triggered.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Check'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Are you safe?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter your secret code word.',
            ),
            const SizedBox(height: 24),
            TextField(
              controller: responseController,
              decoration: const InputDecoration(
                labelText: 'Code word',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: loading ? null : submitCodeWord,
              child: Text(
                loading ? 'Checking...' : 'Submit',
              ),
            ),
            const SizedBox(height: 12),

FilledButton(
  onPressed: sendLocation,
  child: const Text('Send Live Location'),
),
          ],
        ),
      ),
    );
  }
}