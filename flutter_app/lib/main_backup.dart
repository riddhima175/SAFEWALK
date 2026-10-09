import 'dart:async';
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

String two(int n) => n.toString().padLeft(2, '0');

class JourneyConfig {
  final String destination;
  final DateTime firstCheck;
  final String codeWord;
  final List<String> contacts;
  final String message;
  final bool demo;
  const JourneyConfig({
    required this.destination,
    required this.firstCheck,
    required this.codeWord,
    required this.contacts,
    required this.message,
    required this.demo,
  });
  Duration get gap =>
      demo ? const Duration(seconds: 20) : const Duration(minutes: 10);
  int get replySeconds => demo ? 15 : 60;
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
  final message = TextEditingController(
      text: 'I may be in danger. Please check on me and track my location.');
  TimeOfDay? arrival;
  bool demo = false;

  void _warn(String text) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text)));

  void _start() {
    if (arrival == null) return _warn('Please pick the arrival time');
    if (codeWord.text.trim().isEmpty) return _warn('Please enter a code word');

    final now = DateTime.now();
    final eta = DateTime(
        now.year, now.month, now.day, arrival!.hour, arrival!.minute);
    var first = eta.add(const Duration(minutes: 10)); // ETA + 10 min
    if (!first.isAfter(now)) first = first.add(const Duration(days: 1));
    if (demo) first = now.add(const Duration(seconds: 15));

    final contacts = contact.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => JourneyScreen(
          config: JourneyConfig(
            destination: destination.text.trim(),
            firstCheck: first,
            codeWord: codeWord.text.trim(),
            contacts: contacts,
            message: message.text.trim(),
            demo: demo,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Set up journey')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(children: [
            TextField(
                controller: destination,
                decoration:
                    const InputDecoration(labelText: 'Where are you going?')),
            const SizedBox(height: 12),
            ListTile(
              title: Text(arrival == null
                  ? 'Pick arrival time (ETA)'
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
                decoration:
                    const InputDecoration(labelText: 'Secret code word')),
            const SizedBox(height: 12),
            TextField(
                controller: contact,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Emergency contact phone(s), comma separated')),
            const SizedBox(height: 12),
            TextField(
                controller: message,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'Message to send to emergency contacts')),
            SwitchListTile(
              title: const Text('Demo mode'),
              subtitle: const Text(
                  'Short timers for testing. Keep OFF for real use.'),
              value: demo,
              onChanged: (v) => setState(() => demo = v),
            ),
            const SizedBox(height: 12),
            FilledButton(
                onPressed: _start, child: const Text('Start journey')),
          ]),
        ),
      );
}

class JourneyScreen extends StatefulWidget {
  final JourneyConfig config;
  const JourneyScreen({super.key, required this.config});
  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  late DateTime nextCheck;
  int stage = 0; // which pop-up is next: 0, 1, 2
  bool asking = false;
  bool finished = false;
  bool thanks = false;
  Timer? ticker;

  @override
  void initState() {
    super.initState();
    nextCheck = widget.config.firstCheck;
    ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  void _tick() {
    if (!mounted || finished || asking) return;
    if (!DateTime.now().isBefore(nextCheck)) _askCodeWord();
  }

  Future<void> _askCodeWord() async {
    asking = true;
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CodeWordDialog(
        codeWord: widget.config.codeWord,
        seconds: widget.config.replySeconds,
      ),
    );
    asking = false;
    if (!mounted) return;

    if (ok == true) {
      // Correct: stop everything.
      finished = true;
      ticker?.cancel();
      setState(() => thanks = true);
      return;
    }

    // Wrong or no reply: silently escalate. User only sees "Thank you".
    _escalate(stage);
    stage++;
    if (stage >= 3) {
      finished = true;
      ticker?.cancel();
    } else {
      nextCheck = DateTime.now().add(widget.config.gap);
    }
    setState(() => thanks = true);
  }

  void _escalate(int s) {
    final c = widget.config;
    final to =
        c.contacts.isEmpty ? 'emergency contacts' : c.contacts.join(', ');
    if (s == 0) {
      _send('Message sent to $to: "${c.message}"');
    } else if (s == 1) {
      _send('Live location shared with $to');
    } else {
      _send('Police + verified users within 200 m alerted');
    }
  }

  // Silent. Only prints in the VS Code terminal, never on the phone screen.
  // Later this calls Firebase / Twilio.
  void _send(String what) {
    final n = DateTime.now();
    debugPrint('${two(n.hour)}:${two(n.minute)}:${two(n.second)}  $what');
  }

  Widget _waitingView() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.directions_walk, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Journey active', style: TextStyle(fontSize: 24)),
            if (widget.config.destination.isNotEmpty)
              Text('Going to ${widget.config.destination}'),
          ]),
        ),
      );

  Widget _thanksView() => const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.favorite, size: 80, color: Colors.green),
          SizedBox(height: 16),
          Text('Thank you',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ]),
      );

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
              title: const Text('SafeWalk'),
              automaticallyImplyLeading: false),
          body: thanks ? _thanksView() : _waitingView(),
        ),
      );
}

class CodeWordDialog extends StatefulWidget {
  final String codeWord;
  final int seconds;
  const CodeWordDialog(
      {super.key, required this.codeWord, required this.seconds});
  @override
  State<CodeWordDialog> createState() => _CodeWordDialogState();
}

class _CodeWordDialogState extends State<CodeWordDialog> {
  final input = TextEditingController();
  late int secondsLeft;
  Timer? _tick;
  bool done = false;

  @override
  void initState() {
    super.initState();
    secondsLeft = widget.seconds;
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => secondsLeft--);
      if (secondsLeft <= 0) _finish(false); // no reply counts as wrong
    });
  }

  void _finish(bool result) {
    if (done) return;
    done = true;
    _tick?.cancel();
    Navigator.pop(context, result);
  }

  void _submit() => _finish(
      input.text.trim().toLowerCase() == widget.codeWord.trim().toLowerCase());

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Type your code word'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: input,
              autofocus: true,
              onSubmitted: (_) => _submit()),
          const SizedBox(height: 12),
          Text('Please reply within $secondsLeft s',
              style: const TextStyle(color: Colors.grey)),
        ]),
        actions: [
          FilledButton(onPressed: _submit, child: const Text('Confirm'))
        ],
      );
}