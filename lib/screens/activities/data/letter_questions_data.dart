import '../models/letter_question.dart';

// Tamil Letter Classification Questions Data
class LetterQuestionsData {
  static final List<LetterQuestion> questions = [
    LetterQuestion(
      word: 'அம்மா',
      image: 'https://cdn-icons-png.flaticon.com/512/4140/4140047.png',
      letters: ['அ', 'ம்', 'மா'],
      correctAnswers: {'அ': 'uyir', 'ம்': 'mei', 'மா': 'uyirmei'},
    ),
    LetterQuestion(
      word: 'அப்பா',
      image: 'https://cdn-icons-png.flaticon.com/512/4140/4140051.png',
      letters: ['அ', 'ப்', 'பா'],
      correctAnswers: {'அ': 'uyir', 'ப்': 'mei', 'பா': 'uyirmei'},
    ),
    LetterQuestion(
      word: 'அண்ணா',
      image: 'https://cdn-icons-png.flaticon.com/512/3884/3884851.png',
      letters: ['அ', 'ண்', 'ணா'],
      correctAnswers: {'அ': 'uyir', 'ண்': 'mei', 'ணா': 'uyirmei'},
    ),
    LetterQuestion(
      word: 'அக்கா',
      image: 'https://cdn-icons-png.flaticon.com/512/3884/3884845.png',
      letters: ['அ', 'க்', 'கா'],
      correctAnswers: {'அ': 'uyir', 'க்': 'mei', 'கா': 'uyirmei'},
    ),
    LetterQuestion(
      word: 'பாட்டி',
      image: 'https://cdn-icons-png.flaticon.com/512/4140/4140055.png',
      letters: ['பா', 'ட்', 'டி'],
      correctAnswers: {'பா': 'uyirmei', 'ட்': 'mei', 'டி': 'uyirmei'},
    ),
    LetterQuestion(
      word: 'தாத்தா',
      image: 'https://cdn-icons-png.flaticon.com/512/4140/4140052.png',
      letters: ['தா', 'த்', 'தா'],
      correctAnswers: {'தா': 'uyirmei', 'த்': 'mei'},
    ),
    LetterQuestion(
      word: 'தங்கை',
      image: 'https://cdn-icons-png.flaticon.com/512/3884/3884822.png',
      letters: ['த', 'ங்', 'கை'],
      correctAnswers: {'த': 'uyirmei', 'ங்': 'mei', 'கை': 'uyirmei'},
    ),
    LetterQuestion(
      word: 'தம்பி',
      image: 'https://cdn-icons-png.flaticon.com/512/3884/3884834.png',
      letters: ['த', 'ம்', 'பி'],
      correctAnswers: {'த': 'uyirmei', 'ம்': 'mei', 'பி': 'uyirmei'},
    ),
    LetterQuestion(
      word: 'மகன்',
      image: 'https://cdn-icons-png.flaticon.com/512/4140/4140049.png',
      letters: ['ம', 'க', 'ன்'],
      correctAnswers: {'ம': 'uyirmei', 'க': 'uyirmei', 'ன்': 'mei'},
    ),
    LetterQuestion(
      word: 'மகள்',
      image: 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
      letters: ['ம', 'க', 'ள்'],
      correctAnswers: {'ம': 'uyirmei', 'க': 'uyirmei', 'ள்': 'mei'},
    ),
  ];
}
