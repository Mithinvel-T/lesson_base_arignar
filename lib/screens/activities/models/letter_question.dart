// Letter Question Model
class LetterQuestion {
  final String word;
  final String image;
  final List<String> letters;
  final Map<String, String> correctAnswers;

  LetterQuestion({
    required this.word,
    required this.image,
    required this.letters,
    required this.correctAnswers,
  });
}
