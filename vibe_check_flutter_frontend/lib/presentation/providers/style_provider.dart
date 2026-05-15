import 'package:flutter/foundation.dart';
import '../../data/repository/style_result.dart';
import '../../data/repository/style_repository.dart';

enum AnalysisState { idle, processing, success }

class StyleProvider extends ChangeNotifier {
  final StyleRepository _repository;
  
  AnalysisState _state = AnalysisState.idle;
  StyleResult? _result;
  String? _error;
  String? _imageUrl;

  StyleProvider(this._repository);

  AnalysisState get state => _state;
  StyleResult? get result => _result;
  String? get error => _error;
  String? get imageUrl => _imageUrl;

  Future<void> analyzeImage(String imagePath) async {
    _imageUrl = imagePath;
    _state = AnalysisState.processing;
    _error = null;
    notifyListeners();

    try {
      _result = await _repository.analyzeStyle(imagePath);
      _state = AnalysisState.success;
    } catch (e) {
      _error = e.toString();
      _state = AnalysisState.idle;
    }
    notifyListeners();
  }

  void reset() {
    _state = AnalysisState.idle;
    _result = null;
    _error = null;
    _imageUrl = null;
    notifyListeners();
  }
}