import 'package:flutter/material.dart';
import '../models/chatbot_model.dart';
import '../services/chatbot_service.dart';

class ChatBotViewModel extends ChangeNotifier {
  final ChatBotService _chatBotService = ChatBotService();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ChatBotViewModel() {
    _initializeChatBot();
  }

  void _initializeChatBot() {
    // Initialize with a welcome message
    _messages.add(
      ChatMessage(
        text: 'Assalamu Alaikum! 👋 Saya adalah chatbot Muslim. Bagaimana saya dapat membantu Anda hari ini?',
        isUser: false,
      ),
    );
    notifyListeners();
  }

  /// Initialize with API key - IMPORTANT: Call this with your actual API key
  void initializeWithApiKey(String apiKey) {
    _chatBotService.setApiKey(apiKey);
  }

  /// Send a message to the chatbot
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Add user message to the list
    _messages.add(
      ChatMessage(
        text: userMessage,
        isUser: true,
      ),
    );
    notifyListeners();

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get response from Gemini
      final response = await _chatBotService.sendMessage(userMessage);
      
      // Add bot response to the list
      _messages.add(
        ChatMessage(
          text: response,
          isUser: false,
        ),
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear chat history
  void clearChatHistory() {
    _messages.clear();
    _chatBotService.clearChatHistory();
    _initializeChatBot();
    notifyListeners();
  }

  /// Get chat history count
  int get messageCount => _messages.length;
}
