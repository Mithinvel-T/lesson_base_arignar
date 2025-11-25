import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/density/scalable_text.dart';
import '../../responsive/responsive.dart';
import 'models/letter_question.dart';
import 'data/letter_questions_data.dart';
import 'widgets/letter_classification_card.dart';
import 'widgets/question_image_widget.dart';
import 'widgets/progress_header.dart';
import 'widgets/navigation_buttons.dart';

// Tamil Letter Classification Activity - 10 Family Words
class LuxuryActivity extends StatefulWidget {
  final VoidCallback? onExit;

  const LuxuryActivity({super.key, this.onExit});

  @override
  State<LuxuryActivity> createState() => _LuxuryActivityState();
}

class _LuxuryActivityState extends State<LuxuryActivity> {
  // Questions loaded from separated data file
  final List<LetterQuestion> questions = LetterQuestionsData.questions;

  int currentQuestionIndex = 0;
  Map<String, String?> userAnswers = {};
  bool showResult = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _initializeQuestion();
  }

  void _initializeQuestion() {
    userAnswers.clear();
    showResult = false;
    isCorrect = false;

    final letters = questions[currentQuestionIndex].letters;
    for (int i = 0; i < letters.length; i++) {
      userAnswers['${letters[i]}_$i'] = null;
    }
  }

  bool _areAllAnswersSelected() {
    return userAnswers.values.every((answer) => answer != null);
  }

  void _verifyAnswers() {
    final letters = questions[currentQuestionIndex].letters;
    final correctAnswers = questions[currentQuestionIndex].correctAnswers;

    bool allAnswered = userAnswers.values.every((answer) => answer != null);

    if (!allAnswered) {
      _showMessage('எல்லா எழுத்துகளையும் தேர்வு செய்யவும்!');
      return;
    }

    bool correct = true;
    for (int i = 0; i < letters.length; i++) {
      String letter = letters[i];
      String key = '${letter}_$i';
      if (userAnswers[key] != correctAnswers[letter]) {
        correct = false;
        break;
      }
    }

    setState(() {
      isCorrect = correct;
      showResult = true;
    });

    _showResultDialog();
  }

  void _showResultDialog() {
    final letters = questions[currentQuestionIndex].letters;
    final correctAnswers = questions[currentQuestionIndex].correctAnswers;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8EF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.success.withOpacity(0.2)
                      : AppColors.error.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  size: 50,
                  color: isCorrect ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 16),
              ScalableText(
                isCorrect ? 'சரியான பதில்! 🎉' : 'தவறான பதில் ❌',
                style: AppTextStyles.headlineMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 16),
              ScalableText(
                isCorrect
                    ? 'வாழ்த்துக்கள்! நீங்கள் சரியாக தேர்வு செய்துள்ளீர்கள்!'
                    : 'மீண்டும் முயற்சிக்கவும்!',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge(context),
              ),
              if (!isCorrect) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightYellowBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.headerOrange, width: 2),
                  ),
                  child: Column(
                    children: [
                      ScalableText(
                        'சரியான பதில்:',
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.headerOrange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...letters.asMap().entries.map((entry) {
                        String letter = entry.value;
                        String? categoryKey = correctAnswers[letter];
                        String categoryName = categoryKey == 'uyir'
                            ? 'உயிர்'
                            : categoryKey == 'mei'
                            ? 'மெய்'
                            : 'உயிர்மெய்';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ScalableText(
                            '$letter → $categoryName',
                            style: AppTextStyles.bodyMedium(
                              context,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isCorrect) {
                    _nextQuestion();
                  } else {
                    setState(() {
                      showResult = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: ScalableText(
                  isCorrect ? 'அடுத்த கேள்வி ➡️' : 'மீண்டும் முயற்சி 🔄',
                  style: AppTextStyles.bodyLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFAF8EF),
        title: ScalableText(
          'வாழ்த்துக்கள்! 🎉',
          style: AppTextStyles.headlineMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        content: ScalableText(
          'எல்லா கேள்விகளும் முடிந்தது!\nநீங்கள் சிறப்பாக செய்துள்ளீர்கள்!',
          style: AppTextStyles.bodyLarge(context),
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
            child: ScalableText(
              'மீண்டும் தொடங்கு',
              style: AppTextStyles.bodyLarge(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.headerOrange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final word = question.word;
    final imageUrl = question.image;
    final letters = question.letters;
    final progress = (currentQuestionIndex + 1) / questions.length;

    return ResponsiveBuilder(
      builder: (context, responsive) {
        final screenWidth = responsive.physicalScreenWidth;
        final screenHeight = responsive.screenHeight;
        final isMobile = screenWidth < 600;

        return Scaffold(
          backgroundColor: const Color(0xFFFAF8EF),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                ProgressHeader(
                  progress: progress,
                  isMobile: isMobile,
                  screenWidth: screenWidth,
                  currentQuestion: currentQuestionIndex + 1,
                  totalQuestions: questions.length,
                ),

                // Centered Content Container
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? screenWidth : 800,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title Header
                            Container(
                              margin: EdgeInsets.only(
                                bottom: screenHeight * 0.02,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.headerOrange.withOpacity(0.1),
                                    AppColors.primaryBlue.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.headerOrange.withOpacity(
                                    0.3,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'எழுத்துகளை வகைப்படுத்துங்கள்',
                                    style: TextStyle(
                                      fontSize: isMobile ? 20 : 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.headerOrange,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Classify the Letters',
                                    style: TextStyle(
                                      fontSize: isMobile ? 12 : 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.subtleText,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            // Word Container
                            _buildWordContainer(word, isMobile, screenWidth),
                            SizedBox(height: screenHeight * 0.02),

                            // Image with enhanced styling
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    AppColors.lightYellowBackground,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.headerOrange.withOpacity(
                                      0.2,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: QuestionImageWidget(
                                imageUrl: imageUrl,
                                screenWidth: screenWidth,
                                isMobile: isMobile,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.025),

                            // Letter Classification Cards
                            ...letters.asMap().entries.map((entry) {
                              int index = entry.key;
                              String letter = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: LetterClassificationCard(
                                  letter: letter,
                                  letterIndex: index,
                                  isMobile: isMobile,
                                  selectedCategory:
                                      userAnswers['${letter}_$index'],
                                  showResult: showResult,
                                  onCategorySelected: (category) {
                                    setState(() {
                                      userAnswers['${letter}_$index'] =
                                          category;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Bar
                NavigationButtons(
                  isMobile: isMobile,
                  screenWidth: screenWidth,
                  canGoPrevious: currentQuestionIndex > 0,
                  areAllAnswersSelected: _areAllAnswersSelected(),
                  onPrevious: () {
                    setState(() {
                      currentQuestionIndex--;
                      _initializeQuestion();
                    });
                  },
                  onNext: () {
                    _verifyAnswers();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWordContainer(String word, bool isMobile, double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: isMobile ? 16 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.lightYellowBackground, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.headerOrange, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.headerOrange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          word,
          style: TextStyle(
            fontSize: isMobile ? 36 : 48,
            fontWeight: FontWeight.bold,
            color: AppColors.headerOrange,
            fontFamily: 'Roboto',
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: AppColors.lightYellowBackground,
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
