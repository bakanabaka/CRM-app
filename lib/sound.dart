import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Text Demo',
      home: SpeechToTextWidget(),
    );
  }
}

class SpeechToTextWidget extends StatefulWidget {
  @override
  _SpeechToTextWidgetState createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _generatedText = '';
  String _summarizedText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text Demo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generated Text:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(_generatedText),
              SizedBox(height: 16),
              Text(
                'Summarized Text:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(_summarizedText),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isListening ? _stopListening : _startListening,
                child:
                    Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _summarizedText = 'Loading...';
                  // print(_generatedText);
                  _summarize();
                },
                child: Text('Summarize Generated Text'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                ),
              ),
              const SizedBox(height: 10),
              // Text('Summarized Text: $_summarizedText'),
              // print(_summarizedText),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _summarizedText);
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startListening() async {
    bool available = await _speech!.initialize(
      onError: (error) {
        print('Error: $error');
        setState(() {
          _isListening = false;
        });
      },
    );

    if (available) {
      _speech!.listen(
        onResult: (result) {
          setState(() {
            _generatedText = result.recognizedWords;
          });
        },
      );
      setState(() {
        _isListening = true;
      });
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _stopListening() {
    _speech!.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _summarize() async {
    final String apiUrl = "http://localhost:5000/ap";

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    };

    Map<String, String> data = {
      "long_text": _generatedText,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        setState(() {
          _summarizedText = result["summary"] ?? "No summary available.";
          print("Summary: $_summarizedText");
        });
      } else {
        print("Failed to get summary. Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
