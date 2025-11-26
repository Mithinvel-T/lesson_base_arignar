// Tamil Letters Data - Complete list of all Tamil letters by category

class TamilLettersData {
  // உயிர் எழுத்துகள் (Vowels) - All 12 basic vowels
  static const List<String> uyirLetters = [
    'அ', // A
    'ஆ', // AA
    'இ', // I
    'ஈ', // II
    'உ', // U
    'ஊ', // UU
    'எ', // E
    'ஏ', // EE
    'ஐ', // AI
    'ஒ', // O
    'ஓ', // OO
    'ஔ', // AU
  ];

  // மெய் எழுத்துகள் (Consonants) - All 18 basic consonants
  static const List<String> meiLetters = [
    'க்', // K
    'ங்', // NG
    'ச்', // CH
    'ஞ்', // NY
    'ட்', // T
    'ண்', // N
    'த்', // TH
    'ந்', // N
    'ப்', // P
    'ம்', // M
    'ய்', // Y
    'ர்', // R
    'ல்', // L
    'வ்', // V
    'ழ்', // ZH
    'ள்', // L
    'ற்', // R
    'ன்', // N
  ];

  // உயிர்மெய் எழுத்துகள் (Compound Letters) - Vowel + Consonant combinations
  // These are formed by combining vowels with consonants
  // Examples: கா, கி, கீ, கு, கூ, etc.
  static const List<String> uyirmeiLetters = [
    // க series
    'கா', 'கி', 'கீ', 'கு', 'கூ', 'கெ', 'கே', 'கை', 'கொ', 'கோ', 'கௌ',
    // ங series
    'ஙா', 'ஙி', 'ஙீ', 'ஙு', 'ஙூ', 'ஙெ', 'ஙே', 'ஙை', 'ஙொ', 'ஙோ', 'ஙௌ',
    // ச series
    'சா', 'சி', 'சீ', 'சு', 'சூ', 'செ', 'சே', 'சை', 'சொ', 'சோ', 'சௌ',
    // ஞ series
    'ஞா', 'ஞி', 'ஞீ', 'ஞு', 'ஞூ', 'ஞெ', 'ஞே', 'ஞை', 'ஞொ', 'ஞோ', 'ஞௌ',
    // ட series
    'டா', 'டி', 'டீ', 'டு', 'டூ', 'டெ', 'டே', 'டை', 'டொ', 'டோ', 'டௌ',
    // ண series
    'ணா', 'ணி', 'ணீ', 'ணு', 'ணூ', 'ணெ', 'ணே', 'ணை', 'ணொ', 'ணோ', 'ணௌ',
    // த series
    'தா', 'தி', 'தீ', 'து', 'தூ', 'தெ', 'தே', 'தை', 'தொ', 'தோ', 'தௌ',
    // ந series
    'நா', 'நி', 'நீ', 'நு', 'நூ', 'நெ', 'நே', 'நை', 'நொ', 'நோ', 'நௌ',
    // ப series
    'பா', 'பி', 'பீ', 'பு', 'பூ', 'பெ', 'பே', 'பை', 'பொ', 'போ', 'பௌ',
    // ம series
    'மா', 'மி', 'மீ', 'மு', 'மூ', 'மெ', 'மே', 'மை', 'மொ', 'மோ', 'மௌ',
    // ய series
    'யா', 'யி', 'யீ', 'யு', 'யூ', 'யெ', 'யே', 'யை', 'யொ', 'யோ', 'யௌ',
    // ர series
    'ரா', 'ரி', 'ரீ', 'ரு', 'ரூ', 'ரெ', 'ரே', 'ரை', 'ரொ', 'ரோ', 'ரௌ',
    // ல series
    'லா', 'லி', 'லீ', 'லு', 'லூ', 'லெ', 'லே', 'லை', 'லொ', 'லோ', 'லௌ',
    // வ series
    'வா', 'வி', 'வீ', 'வு', 'வூ', 'வெ', 'வே', 'வை', 'வொ', 'வோ', 'வௌ',
    // ழ series
    'ழா', 'ழி', 'ழீ', 'ழு', 'ழூ', 'ழெ', 'ழே', 'ழை', 'ழொ', 'ழோ', 'ழௌ',
    // ள series
    'ளா', 'ளி', 'ளீ', 'ளு', 'ளூ', 'ளெ', 'ளே', 'ளை', 'ளொ', 'ளோ', 'ளௌ',
    // ற series
    'றா', 'றி', 'றீ', 'று', 'றூ', 'றெ', 'றே', 'றை', 'றொ', 'றோ', 'றௌ',
    // ன series
    'னா', 'னி', 'னீ', 'னு', 'னூ', 'னெ', 'னே', 'னை', 'னொ', 'னோ', 'னௌ',
  ];

  // Check if a letter is உயிர் (Vowel)
  static bool isUyir(String letter) {
    return uyirLetters.contains(letter);
  }

  // Check if a letter is மெய் (Consonant)
  static bool isMei(String letter) {
    return meiLetters.contains(letter);
  }

  // Check if a letter is உயிர்மெய் (Compound)
  static bool isUyirmei(String letter) {
    return uyirmeiLetters.contains(letter);
  }

  // Get category of a letter
  static String? getCategory(String letter) {
    if (isUyir(letter)) return 'uyir';
    if (isMei(letter)) return 'mei';
    if (isUyirmei(letter)) return 'uyirmei';

    // Handle letters without virama
    // Tamil consonants without virama have inherent vowel 'அ', making them uyirmei
    if (letter.length == 1 &&
        letter.codeUnitAt(0) >= 0x0B95 &&
        letter.codeUnitAt(0) <= 0x0BB9) {
      // It's a Tamil consonant character (க to ஹ range) without virama
      // This means it has inherent vowel 'அ', so it's uyirmei
      // Example: "ப" = "ப + அ" = uyirmei
      return 'uyirmei';
    }

    return null;
  }

  // Get all letters of a specific category
  static List<String> getLettersByCategory(String category) {
    switch (category) {
      case 'uyir':
        return uyirLetters;
      case 'mei':
        return meiLetters;
      case 'uyirmei':
        return uyirmeiLetters;
      default:
        return [];
    }
  }
}
