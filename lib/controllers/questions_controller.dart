import 'dart:math';

import 'package:find_words/data/questions_list.dart';
import 'package:find_words/models/question.dart';
import 'package:get/get.dart';

class QuestionsController extends GetxController {
  List<Question> questionsList = QuestionsList.questions;

  int currentQuestionIndex = 0;

  List<Map<String, dynamic>> selectedVariants = [];

  void addSlectedVariants({required int index, required String letter}) {
    selectedVariants.add({"index": index, "letter": letter});
    update();
  }

  void removeLastSelectedVariants() {
    if (selectedVariants.isNotEmpty) {
      selectedVariants.removeLast();
    }
    update();
  }

  void clearSelectedVariants() {
    selectedVariants.clear();
    update();
  }

  void nextQuestion() {
    selectedVariants.clear();
    currentQuestionIndex += 1;
    update();
  }

  void restartGame() {
    currentQuestionIndex = 0;
    update();
  }

  List<String> getVariants() {
    List<String> words =
        questionsList[currentQuestionIndex].answer.toLowerCase().split("");

    int desiredLength = 12 - words.length;

    words.addAll(_getRandomLetters(desiredLength));
    words.shuffle();

    return words;
  }

  List<String> _getRandomLetters(int n) {
    const String aphabet = "abcdefghijklmnopqrstuvwxyz";
    Random random = Random();
    return List.generate(n, (_) {
      int randomIndex = random.nextInt(aphabet.length);
      return aphabet[randomIndex];
    });
  }
}
