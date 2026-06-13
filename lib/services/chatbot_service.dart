import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotService {
  late GenerativeModel _model;
  late ChatSession _chatSession;
  static const String _apiKey = 'YOUR_GEMINI_API_KEY'; // Replace with your API key

  ChatBotService() {
    _initializeModel();
  }

  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
    _chatSession = _model.startChat();
  }

  /// Set API key (call this before using the chatbot)
  void setApiKey(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _chatSession = _model.startChat();
  }

  /// Send a message and get a response from Gemini
  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await _chatSession.sendMessage(
        Content.text(userMessage),
      );

      if (response.text != null) {
        return response.text!;
      } else {
        return 'No response from Gemini API';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  /// Get chat history
  List<Content> getChatHistory() {
    return _chatSession.history.toList();
  }

  /// Clear chat history
  void clearChatHistory() {
    _chatSession = _model.startChat();
  }
}
