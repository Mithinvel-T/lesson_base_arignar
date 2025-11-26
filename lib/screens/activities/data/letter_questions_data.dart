import '../models/letter_question.dart';
import 'tamil_letters_data.dart';

// Tamil Letter Classification Questions Data
class LetterQuestionsData {
  // Function to automatically generate correct answers based on letter categories
  static Map<String, String> _generateCorrectAnswers(List<String> letters) {
    Map<String, String> answers = {};
    for (String letter in letters) {
      String? category = TamilLettersData.getCategory(letter);
      if (category != null) {
        answers[letter] = category;
      }
    }
    return answers;
  }

  // Function to automatically split Tamil words into letters
  static List<String> _splitTamilWord(String word) {
    List<String> letters = [];
    int i = 0;

    while (i < word.length) {
      // Check if current character is a Tamil character
      if (word.codeUnitAt(i) >= 0x0B80 && word.codeUnitAt(i) <= 0x0BFF) {
        String currentLetter = word[i];
        i++;

        // Check for combining characters (like ா, ி, ீ, ு, ூ, ெ, ே, ை, ொ, ோ, ௌ)
        while (i < word.length &&
            ((word.codeUnitAt(i) >= 0x0BBE &&
                    word.codeUnitAt(i) <= 0x0BC2) || // vowel signs
                (word.codeUnitAt(i) >= 0x0BC6 &&
                    word.codeUnitAt(i) <= 0x0BC8) || // e, ee, ai signs
                (word.codeUnitAt(i) >= 0x0BCA &&
                    word.codeUnitAt(i) <= 0x0BCD) || // o, oo, au, virama
                word.codeUnitAt(i) == 0x0BD7)) {
          // au length mark
          currentLetter += word[i];
          i++;
        }

        letters.add(currentLetter);
      } else {
        // For non-Tamil characters, add as individual characters
        letters.add(word[i]);
        i++;
      }
    }

    return letters;
  }

  static final List<LetterQuestion> questions = [
    // 3 Short words (3 letters each)
    LetterQuestion(
      word: 'அம்மா',
      image: 'https://www.shutterstock.com/image-vector/illustration-boy-mothers-arms-day-600nw-2445445245.jpg',
      letters: _splitTamilWord('அம்மா'),
      correctAnswers: _generateCorrectAnswers(_splitTamilWord('அம்மா')),
    ),
    LetterQuestion(
      word: 'அப்பா',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3vxLZ7wKdtvsz3_UfkPS1QOJ618D3r3_Czg&s',
      letters: _splitTamilWord('அப்பா'),
      correctAnswers: _generateCorrectAnswers(_splitTamilWord('அப்பா')),
    ),
    LetterQuestion(
      word: 'அண்ணா',
      image: 'https://thumbs.dreamstime.com/b/cartoon-brother-giving-piggyback-ride-to-sister-happy-siblings-playing-together-cartoon-vector-illustration-happy-brother-376269415.jpg',
      letters: _splitTamilWord('அண்ணா'),
      correctAnswers: _generateCorrectAnswers(_splitTamilWord('அண்ணா')),
    ),

    // 2-3 Long words (4+ letters) - Big words for testing
    LetterQuestion(
      word: 'பட்டாம்பூச்சி',
      image: 'https://thumbs.dreamstime.com/b/cute-butterfly-cartoon-character-flower-spring-garden-adorable-sits-pink-surrounded-blooming-blue-sky-perfect-383551437.jpg',
      letters: _splitTamilWord('பட்டாம்பூச்சி'),
      correctAnswers: _generateCorrectAnswers(_splitTamilWord('பட்டாம்பூச்சி')),
    ),
    LetterQuestion(
      word: 'கண்ணாடி',
      image: 'https://www.shutterstock.com/image-vector/mirror-icon-cartoon-style-isolated-260nw-489791557.jpg',
      letters: _splitTamilWord('கண்ணாடி'),
      correctAnswers: _generateCorrectAnswers(_splitTamilWord('கண்ணாடி')),
    ),
    LetterQuestion(
      word: 'கொடுக்கை',
      image: 'https://static.hindutamil.in/hindu/uploads/common/2017/01/16/kodukku_3118584a.jpg',
      letters: _splitTamilWord('கொடுக்கை'),
      correctAnswers: _generateCorrectAnswers(_splitTamilWord('கொடுக்கை')),
    ),
  ];
}
