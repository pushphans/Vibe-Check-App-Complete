import 'package:flutter/foundation.dart';
import '../../model/style_result.dart';
import '../../model/style_repository.dart';

enum AnalysisState { idle, processing, success }

class StyleProvider extends ChangeNotifier {
  final StyleRepository _repository;
  
  AnalysisState _state = AnalysisState.idle;
  StyleResult? _result;
  String? _error;

  StyleProvider(this._repository);

  AnalysisState get state => _state;
  StyleResult? get result => _result;
  String? get error => _error;

  Future<void> analyzeImage(String imagePath) async {
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
    notifyListeners();
  }
}