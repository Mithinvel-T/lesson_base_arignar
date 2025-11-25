import 'package:flutter/material.dart';
import 'models/letter_question.dart';
import 'data/letter_questions_data.dart';

// Tamil Letter Classification Activity - Flexible Compact Layout
class TamilGridActivity extends StatefulWidget {
  final VoidCallback? onExit;

  const TamilGridActivity({super.key, this.onExit});

  @override
  State<TamilGridActivity> createState() => _TamilGridActivityState();
}

class _TamilGridActivityState extends State<TamilGridActivity> {
  final List<LetterQuestion> questions = LetterQuestionsData.questions;

  int currentQuestionIndex = 0;
  Map<String, String?> userAnswers = {};

  @override
  void initState() {
    super.initState();
    _initializeQuestion();
  }

  void _initializeQuestion() {
    userAnswers.clear();
    final letters = questions[currentQuestionIndex].letters;
    for (int i = 0; i < letters.length; i++) {
      userAnswers['${letters[i]}_$i'] = null;
    }
  }

  void _selectCategory(String letter, int letterIndex, String category) {
    setState(() {
      userAnswers['${letter}_$letterIndex'] = category;
    });
  }

  bool _areAllAnswersSelected() {
    return userAnswers.values.every((answer) => answer != null);
  }

  void _verifyAnswers() {
    final letters = questions[currentQuestionIndex].letters;
    final correctAnswers = questions[currentQuestionIndex].correctAnswers;

    if (!_areAllAnswersSelected()) {
      _showMessage('எல்லா எழுத்துகளையும் தேர்வு செய்யவும்!');
      return;
    }

    bool correct = true;
    Map<String, String> wrongAnswers = {};

    for (int i = 0; i < letters.length; i++) {
      String letter = letters[i];
      String key = '${letter}_$i';
      String userAnswer = userAnswers[key] ?? '';
      String correctAnswer = correctAnswers[letter] ?? '';

      if (userAnswer != correctAnswer) {
        correct = false;
        wrongAnswers[letter] = correctAnswer;
      }
    }

    _showResultDialog(correct, wrongAnswers);
  }

  void _showResultDialog(bool correct, Map<String, String> wrongAnswers) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          correct ? 'சரியான பதில்! 🎉' : 'தவறான பதில் ❌',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: correct ? Colors.green : Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              correct ? 'வாழ்த்துக்கள்!' : 'மீண்டும் முயற்சிக்கவும்!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (!correct && wrongAnswers.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'சரியான பதில்:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...wrongAnswers.entries.map((entry) {
                      String categoryName = entry.value == 'uyir'
                          ? 'உயிர்'
                          : entry.value == 'mei'
                          ? 'மெய்'
                          : 'உயிர்மெய்';
                      return Text('${entry.key} → $categoryName');
                    }).toList(),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (correct) {
                  _nextQuestion();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: correct ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(correct ? 'அடுத்தது' : 'சரி'),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _initializeQuestion();
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('வாழ்த்துக்கள்! 🎉', textAlign: TextAlign.center),
        content: const Text(
          'எல்லா கேள்விகளும் முடிந்தது!',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestionIndex = 0;
                _initializeQuestion();
              });
            },
            child: const Text('மீண்டும் தொடங்கு'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final word = question.word;
    final letters = question.letters;
    final progress = (currentQuestionIndex + 1) / questions.length;
    final screenWidth = MediaQuery.of(context).size.width;

    // Flexible responsive values
    final maxWidth = screenWidth > 900 ? 650.0 : screenWidth * 0.95;
    final contentPadding = screenWidth > 600 ? 24.0 : 16.0;
    final categoryWidth = maxWidth < 500 ? 100.0 : 120.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: Center(
              child: Container(
                width: maxWidth,
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 8),

                    // Question card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'இந்த சொற்களில் எந்த எழுத்து — உயிர், மெய், உயிர்மெய் ?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C1810),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Progress bar
                    Row(
                      children: [
                        Text(
                          '${currentQuestionIndex + 1}/${questions.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B4423),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: const Color(0xFFE3F2FD),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: const Color(0xFF2196F3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B4423),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Word display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF6BA4D9),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            word,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.volume_up_rounded,
                            color: Color(0xFF6BA4D9),
                            size: 22,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Main grid
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Categories
                          SizedBox(
                            width: categoryWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCategoryChip('உயிர்'),
                                _buildCategoryChip('மெய்'),
                                _buildCategoryChip('உயிர்மெய்'),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Letters grid
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildLetterRow(letters, 'uyir'),
                                _buildLetterRow(letters, 'mei'),
                                _buildLetterRow(letters, 'uyirmei'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Home
                  _buildNavButton(
                    Icons.home_rounded,
                    () => Navigator.pop(context),
                    true,
                  ),
                  // Back
                  _buildNavButton(
                    Icons.arrow_back_rounded,
                    currentQuestionIndex > 0
                        ? () => setState(() {
                            currentQuestionIndex--;
                            _initializeQuestion();
                          })
                        : null,
                    currentQuestionIndex > 0,
                  ),
                  // Next
                  _buildNavButton(
                    Icons.arrow_forward_rounded,
                    _areAllAnswersSelected() ? () => _verifyAnswers() : null,
                    _areAllAnswersSelected(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      width: double.infinity,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E6D2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD4A574)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5D4037),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterRow(List<String> letters, String category) {
    return SizedBox(
      height: 38,
      child: Row(
        children: letters.asMap().entries.map((entry) {
          int index = entry.key;
          String letter = entry.value;
          String key = '${letter}_$index';
          bool isSelected = userAnswers[key] == category;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      userAnswers[key] = null;
                    } else {
                      _selectCategory(letter, index, category);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF66BB6A) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFE0E0E0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? const Color(0xFF4CAF50).withOpacity(0.15)
                            : Colors.grey.withOpacity(0.06),
                        blurRadius: isSelected ? 4 : 2,
                        offset: Offset(0, isSelected ? 2.0 : 1.0),
                      ),
                    ],
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback? onPressed, bool enabled) {
    return Material(
      color: enabled ? const Color(0xFFFFA726) : Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
      elevation: enabled ? 3 : 0,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: enabled ? Colors.white : Colors.grey,
            size: 22,
          ),
        ),
      ),
    );
  }
}
