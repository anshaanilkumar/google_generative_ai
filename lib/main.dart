import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Simple Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const GeminiPage(),
    );
  }
}

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";
  bool _loading = false;

  Future<void> _generateText(String prompt) async {
    setState(() {
      _loading = true;
      _response = "";
    });

    const apiKey = "";

    final model = GenerativeModel(
      model: "gemini-1.5-flash",
      apiKey: apiKey,
    );

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _response = response.text ?? "No response from model";
      });
    } catch (e) {
      setState(() {
        _response = "Error: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gemini Simple Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter a prompt",
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _generateText(_controller.text),
              child: const Text("Generate"),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
