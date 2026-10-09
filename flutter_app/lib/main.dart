import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const SafeApp());

class SafeApp extends StatelessWidget {
  const SafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFE83E79);
    const purple = Color(0xFF6335A5);
    const cream = Color(0xFFFFF8F5);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeWalk',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          primary: purple,
          secondary: pink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: Color(0xFF19264F),
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const navy = Color(0xFF19264F);
  static const pink = Color(0xFFE83E79);
  static const purple = Color(0xFF6335A5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 650;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [pink, purple],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.shield_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SafeWalk',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                  color: navy,
                                ),
                              ),
                              Text(
                                'Your safety. Your choices.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF77758A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      if (wide)
                        Row(
                          children: [
                            Expanded(child: _welcomeText()),
                            const SizedBox(width: 22),
                            Expanded(child: _cityIllustration()),
                          ],
                        )
                      else ...[
                        _welcomeText(),
                        const SizedBox(height: 20),
                        _cityIllustration(),
                      ],
                      const SizedBox(height: 22),
                      _feature(
                        Icons.location_on_rounded,
                        pink,
                        'Your journey, your choice',
                        'Plan your journey and choose when to start sharing.',
                      ),
                      const SizedBox(height: 12),
                      _feature(
                        Icons.people_alt_rounded,
                        purple,
                        'Your trusted circle',
                        'You choose which contacts in SheSafe can see your location.',
                      ),
                      const SizedBox(height: 12),
                      _feature(
                        Icons.shield_rounded,
                        const Color(0xFF267D69),
                        'Help when you need it',
                        'Keep emergency options easy to find.',
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 58,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [pink, purple],
                            ),
                            borderRadius: BorderRadius.circular(19),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SetupScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.navigation_rounded),
                            label: const Text(
                              'Start Your Journey',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            size: 16,
                            color: purple,
                          ),
                          SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              'Your safety. Your choices.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: navy,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOU DESERVE TO FEEL SAFE',
          style: TextStyle(
            color: pink,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        SizedBox(height: 13),
        Text(
          'You’re not alone.\nYour safety matters.',
          style: TextStyle(
            color: navy,
            fontSize: 36,
            height: 1.12,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 13),
        Text(
          'For the way to college, the ride home, '
          'or wherever life takes you.',
          style: TextStyle(
            color: Color(0xFF6D7185),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _cityIllustration() {
    return Container(
      height: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD9D1),
            Color(0xFFFFB7BD),
            Color(0xFF9C82CA),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 28,
            top: 22,
            child: Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFE7A6),
              ),
            ),
          ),
          Positioned(
            left: -10,
            right: -10,
            bottom: 0,
            height: 115,
            child: CustomPaint(
              painter: _CityPainter(),
            ),
          ),
          const Positioned(
            left: 20,
            bottom: 18,
            child: Icon(
              Icons.directions_walk_rounded,
              color: Color(0xFF19264F),
              size: 83,
            ),
          ),
          Positioned(
            right: 18,
            bottom: 17,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_rounded, color: pink, size: 19),
                  SizedBox(width: 6),
                  Text(
                    'Safety first',
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(
    IconData icon,
    Color color,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF2E8EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF77758A),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final buildingPaint = Paint()..color = const Color(0xFF6C6097);
    final darkPaint = Paint()..color = const Color(0xFF3C426F);
    final roadPaint = Paint()..color = const Color(0xFF5C537F);

    final buildings = <Rect>[
      Rect.fromLTWH(12, 25, 48, 90),
      Rect.fromLTWH(65, 45, 37, 70),
      Rect.fromLTWH(108, 10, 54, 105),
      Rect.fromLTWH(169, 35, 43, 80),
      Rect.fromLTWH(220, 18, 49, 97),
      Rect.fromLTWH(277, 42, 43, 73),
      Rect.fromLTWH(327, 12, 54, 103),
      Rect.fromLTWH(389, 34, 45, 81),
      Rect.fromLTWH(442, 22, 52, 93),
    ];

    for (int i = 0; i < buildings.length; i++) {
      canvas.drawRect(
        buildings[i],
        i.isEven ? buildingPaint : darkPaint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 106, size.width, 9),
      roadPaint,
    );

    final windowPaint = Paint()..color = const Color(0xFFFFD9A1);
    for (final building in buildings) {
      for (double x = building.left + 9; x < building.right - 4; x += 15) {
        for (double y = building.top + 10; y < building.bottom - 7; y += 18) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, 5, 7),
            windowPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

  Widget _waitingView() => Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFE5EC),
        Color(0xFFF3E8FF),
        Color(0xFFFFF8F0),
      ],
    ),
  ),
  child: SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),

          const Center(
            child: Text(
              'SafeWalk',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF754078),
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              'Your safety. Your choices.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF755F78),
              ),
            ),
          ),

          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF754078)
                      .withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFD5E2),
                        Color(0xFFE8D5FF),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.directions_walk_rounded,
                    size: 55,
                    color: Color(0xFF754078),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Your journey is underway',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF54345F),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Take a breath. You deserve to feel safe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF796B7D),
                  ),
                ),

                const SizedBox(height: 26),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFB65C88),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'YOUR DESTINATION',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9C6383),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.config.destination.isEmpty
                                  ? 'Destination not specified'
                                  : widget.config.destination,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF54345F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFC46B91),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'You’re not alone. Your safety matters.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF754078),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Center(
            child: Text(
              'Keep going at your own pace 💜',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF755F78),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    ),
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