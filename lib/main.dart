import 'package:flutter/material.dart';

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
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Journey started (next: pop-up)'))),
              child: const Text('Start journey'),
            ),
          ]),
        ),
      );
}
