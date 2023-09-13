class TestQuestion {
  String question;
  List<String> choices;
  String correctAnswer;
  String difficulty;
  int duration = 12;
  int points = 4;

  TestQuestion(
      {required this.question,
      required this.choices,
      required this.correctAnswer, required this.difficulty});
}
