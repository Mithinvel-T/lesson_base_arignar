import 'package:flutter/material.dart';
import 'models/letter_question.dart';
import 'data/letter_questions_data.dart';
import '../../widgets/quiz_header.dart';

// Tamil Letter Classification Activity - Flexible Compact Layout
class TamilGridActivity extends StatefulWidget {
  final VoidCallback? onExit;

  const TamilGridActivity({super.key, this.onExit});

  @override
  State<TamilGridActivity> createState() => _TamilGridActivityState();
}

class _TamilGridActivityState extends State<TamilGridActivity> {
  final List<LetterQuestion> questions = LetterQuestionsData.questions;
  final ScrollController _scrollController = ScrollController();
  bool _hasScrollableContent = false;

  int currentQuestionIndex = 0;
  Map<String, String?> userAnswers = {}; // Current question answers
  Map<int, Map<String, String?>> savedAnswers = {}; // Save answers per question index
  Map<int, bool> savedWrongAnswerFlags = {}; // Save wrong answer flag per question
  bool _dialogButtonClicked = false; // Flag to track dialog button click
  bool _hasWrongAnswer = false; // Track if wrong answer was shown

  @override
  void initState() {
    super.initState();
    _initializeQuestion();
    _scrollController.addListener(_checkScrollable);
  }

  void _checkScrollable() {
    if (_scrollController.hasClients) {
      final isScrollable = _scrollController.position.maxScrollExtent > 0;
      if (isScrollable != _hasScrollableContent) {
        setState(() {
          _hasScrollableContent = isScrollable;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScrollable);
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeQuestion() {
    userAnswers.clear();
    _hasWrongAnswer = false; // Reset wrong answer flag
    final letters = questions[currentQuestionIndex].letters;
    for (int i = 0; i < letters.length; i++) {
      userAnswers['${letters[i]}_$i'] = null;
    }
  }

  void _selectCategory(String letter, int letterIndex, String category) {
    setState(() {
      // If wrong answer was shown, only allow correct answer selection
      if (_hasWrongAnswer) {
        final correctAnswers = questions[currentQuestionIndex].correctAnswers;
        final correctCategory = correctAnswers[letter];
        if (category != correctCategory) {
          // Don't allow wrong answer selection
          return;
        }
      }

      // Set the category
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
      _showMessage('Please select all letters!');
      return;
    }

    bool correct = true;
    Map<String, String> wrongAnswers = {};

    // Debug: Print letters and correct answers
    debugPrint('=== Verifying Answers ===');
    debugPrint('Letters: $letters');
    debugPrint('Correct Answers: $correctAnswers');
    debugPrint('User Answers: $userAnswers');

    for (int i = 0; i < letters.length; i++) {
      String letter = letters[i];
      String key = '${letter}_$i';
      String userAnswer = userAnswers[key] ?? '';
      String correctAnswer = correctAnswers[letter] ?? '';

      debugPrint(
        'Letter[$i]: $letter, Key: $key, User: $userAnswer, Correct: $correctAnswer',
      );

      if (userAnswer != correctAnswer) {
        correct = false;
        wrongAnswers[letter] = correctAnswer;
        debugPrint(
          '❌ Wrong: $letter - User selected: $userAnswer, Should be: $correctAnswer',
        );
      } else {
        debugPrint('✅ Correct: $letter - $userAnswer');
      }
    }

    debugPrint('Final Result: ${correct ? "CORRECT" : "WRONG"}');

    // If last question and answer is correct, show completion dialog directly
    bool isLastQuestion = currentQuestionIndex == questions.length - 1;
    if (isLastQuestion && correct) {
      _showCompletionDialog();
      return;
    }

    if (!correct) {
      _hasWrongAnswer = true; // Mark that wrong answer was shown
    }
    _showResultDialog(correct, wrongAnswers);
  }

  // Group all letters by their correct categories
  Map<String, List<String>> _groupAllLettersByCategory() {
    final question = questions[currentQuestionIndex];
    final letters = question.letters;
    final correctAnswers = question.correctAnswers;

    Map<String, List<String>> grouped = {'uyir': [], 'mei': [], 'uyirmei': []};

    debugPrint('=== Grouping Letters ===');
    debugPrint('All letters: $letters');
    debugPrint('Correct answers: $correctAnswers');

    for (String letter in letters) {
      String? category = correctAnswers[letter];
      debugPrint('Letter: $letter -> Category: $category');
      if (category != null && grouped.containsKey(category)) {
        grouped[category]!.add(letter);
      } else {
        debugPrint('⚠️ Letter $letter not categorized or category not found');
      }
    }

    debugPrint('Grouped result: $grouped');
    return grouped;
  }

  // Calculate dialog width based on content
  double _calculateDialogWidth(Map<String, List<String>> allLettersByCategory) {
    // Calculate width based on content
    double calculateTextWidth(String text, double fontSize) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      return textPainter.size.width;
    }

    // Calculate total width needed
    double maxRowWidth = 0;
    const categoryPadding = 12.0 * 2; // horizontal padding
    const letterPadding = 10.0 * 2; // horizontal padding
    const spacing = 12.0; // spacing between category and letters
    const letterSpacing = 8.0; // spacing between letters
    const containerPadding = 16.0 * 2; // container padding
    const titleWidth = 150.0; // approximate title width

    // Helper function to get category name
    String getCategoryName(String cat) {
      switch (cat) {
        case 'uyir':
          return 'உயிர்';
        case 'mei':
          return 'மெய்';
        case 'uyirmei':
          return 'உயிர்மெய்';
        default:
          return cat;
      }
    }

    // Calculate width for each category row
    for (var category in ['uyir', 'mei', 'uyirmei']) {
      if (allLettersByCategory[category] != null &&
          allLettersByCategory[category]!.isNotEmpty) {
        final categoryName = getCategoryName(category);
        final letters = allLettersByCategory[category]!;

        // Category label width
        double rowWidth =
            calculateTextWidth(categoryName, 14) + categoryPadding;
        rowWidth += spacing; // spacing after category

        // Letters width
        for (String letter in letters) {
          rowWidth +=
              calculateTextWidth(letter, 14) + letterPadding + letterSpacing;
        }
        rowWidth -= letterSpacing; // Remove last spacing

        if (rowWidth > maxRowWidth) {
          maxRowWidth = rowWidth;
        }
      }
    }

    // Add container padding and title width
    maxRowWidth += containerPadding + titleWidth;

    // Minimum width 350px, maximum 90% of screen width
    final screenWidth = MediaQuery.of(context).size.width;
    return maxRowWidth.clamp(350.0, screenWidth * 0.9);
  }

  void _showResultDialog(bool correct, Map<String, String> wrongAnswers) {
    // Get all letters grouped by category for display
    final allLettersByCategory = _groupAllLettersByCategory();

    // Debug: Print grouped letters
    debugPrint('=== Dialog Letters by Category ===');
    debugPrint('Uyir: ${allLettersByCategory['uyir']}');
    debugPrint('Mei: ${allLettersByCategory['mei']}');
    debugPrint('Uyirmei: ${allLettersByCategory['uyirmei']}');

    _dialogButtonClicked = false; // Reset flag

    // Calculate dialog width based on content
    final dialogWidth = !correct
        ? _calculateDialogWidth(allLettersByCategory)
        : 300.0; // Default width for correct answer

    showDialog(
      context: context,
      barrierDismissible: true, // Allow closing by tapping outside
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            correct ? 'Correct Answer! 🎉' : 'Wrong Answer ❌',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: correct ? Colors.green : Colors.red,
            ),
          ),
          content: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  correct ? 'Well done!' : 'Try again!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                // Only show correct answer section if answer is wrong
                if (!correct) ...[
                  const SizedBox(height: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Correct Answer:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Show each category in its own row (in fixed order)
                      ...['uyir', 'mei', 'uyirmei']
                          .where(
                            (cat) =>
                                allLettersByCategory[cat] != null &&
                                allLettersByCategory[cat]!.isNotEmpty,
                          )
                          .map((category) {
                            String categoryKey = category;
                            List<String> letters =
                                allLettersByCategory[categoryKey] ?? [];

                            // Helper function to get category color
                            Color getCategoryColor(String cat) {
                              switch (cat) {
                                case 'uyir':
                                  return const Color(
                                    0xFF42A5F5,
                                  ); // Brighter blue
                                case 'mei':
                                  return const Color(
                                    0xFFFF9800,
                                  ); // Brighter orange
                                case 'uyirmei':
                                  return const Color(
                                    0xFF66BB6A,
                                  ); // Brighter green
                                default:
                                  return const Color(0xFF757575);
                              }
                            }

                            // Helper function to get category name
                            String getCategoryName(String cat) {
                              switch (cat) {
                                case 'uyir':
                                  return 'உயிர்';
                                case 'mei':
                                  return 'மெய்';
                                case 'uyirmei':
                                  return 'உயிர்மெய்';
                                default:
                                  return cat;
                              }
                            }

                            final categoryColor = getCategoryColor(categoryKey);
                            final categoryName = getCategoryName(categoryKey);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: categoryColor.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: categoryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: categoryColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        categoryName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: categoryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: letters.map((letter) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: categoryColor.withOpacity(
                                                0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: categoryColor,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Text(
                                              letter,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: categoryColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _dialogButtonClicked = true; // Mark that button was clicked
                  Navigator.pop(context, 'button_clicked'); // Pass result
                  // Allow moving to next question for both correct and wrong answers
                  // Small delay to ensure dialog closes before moving to next
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _nextQuestion();
                  });
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
                child: Text(correct ? 'Continue' : 'Next'),
              ),
            ),
          ],
        );
      },
    ).then((result) {
      // Handle dialog dismissal (when tapping outside)
      // Move to next question if button wasn't clicked (tapped outside)
      // Button click already handles navigation
      if (result != 'button_clicked' && !_dialogButtonClicked) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _nextQuestion();
        });
      }
    });
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenSize = screenWidth < screenHeight ? screenWidth : screenHeight;

    // Calculate responsive font sizes based on screen size
    final titleFontSize = (screenSize * 0.06).clamp(24.0, 32.0);
    final contentFontSize = (screenSize * 0.04).clamp(16.0, 20.0);
    final buttonFontSize = (screenSize * 0.035).clamp(14.0, 18.0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Congratulations! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              'All questions completed!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: contentFontSize),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentQuestionIndex = 0;
                  _initializeQuestion();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.015,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Again',
                style: TextStyle(fontSize: buttonFontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playAudio(String word) {
    // TODO: Implement audio playback for the word
    // You can use text-to-speech or audio files here
    print('Playing audio for: $word');
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final word = question.word;
    final letters = question.letters;
    final progress = (currentQuestionIndex + 1) / questions.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Flexible responsive values for different screen sizes
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    // Calculate base scale factor for smooth scaling - reduced for smaller screens
    final baseScale = screenWidth / 400.0; // Base scale at 400px width
    final scaleFactor = baseScale.clamp(
      0.7,
      2.0,
    ); // Reduced max scaling to prevent overflow

    // Calculate sizes based on screen resolution - smooth scaling with overflow prevention
    final wordFontSize = (screenWidth * 0.048 * scaleFactor).clamp(16.0, 38.0);
    final maxWidth = screenWidth > 1200
        ? 800.0
        : screenWidth > 900
        ? 650.0
        : screenWidth * 0.98;
    // Category width scales smoothly with screen size - reduced for smaller screens
    final categoryWidth = (screenWidth * 0.14 * scaleFactor).clamp(70.0, 150.0);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF), // Home page cream background
      body: Column(
        children: [
          // Header with title and progress bar - Full width
          QuizHeader(
            currentQuestion: currentQuestionIndex + 1,
            totalQuestions: questions.length,
            progressPercentage: progress * 100,
            title: 'இந்த சொற்களில் எந்த எழுத்து — உயிர், மெய், உயிர்மெய் ?',
          ),

          // Main content area
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: maxWidth,
                padding: EdgeInsets.only(
                  left: isMobile ? 12 : 24,
                  right: isMobile ? 12 : 24,
                  top: isMobile ? 12 : 20,
                  bottom: isMobile ? 12 : 16,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Check if content is scrollable after build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _checkScrollable();
                    });

                    return Scrollbar(
                      controller: _scrollController,
                      thumbVisibility:
                          _hasScrollableContent, // Show only when scrollable
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics:
                            const AlwaysScrollableScrollPhysics(), // Prevent overflow
                        child: Container(
                          color: const Color(
                            0xFFFAF8EF,
                          ), // Match scaffold background
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Word container with speaker icon - Above image
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth * 0.98,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          (screenWidth * 0.045 * scaleFactor)
                                              .clamp(14.0, 28.0),
                                      vertical:
                                          (screenWidth * 0.025 * scaleFactor)
                                              .clamp(8.0, 16.0),
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom:
                                          (screenHeight * 0.02 * scaleFactor)
                                              .clamp(12.0, 20.0),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        16,
                                      ), // Match image border radius
                                      border: Border.all(
                                        color: const Color(0xFFE0E0E0),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Word text - Flexible and adaptive for long words
                                        Flexible(
                                          child: LayoutBuilder(
                                            builder: (context, wordConstraints) {
                                              // Calculate optimal font size based on word length and available width
                                              final wordLength = word.length;
                                              final availableWordWidth =
                                                  wordConstraints.maxWidth *
                                                  0.85; // Leave space for icon

                                              // Adjust font size based on word length - longer words get smaller base size
                                              double adaptiveFontSize =
                                                  wordFontSize;
                                              if (wordLength > 8) {
                                                // Reduce font size for very long words
                                                adaptiveFontSize =
                                                    wordFontSize *
                                                    (8.0 / wordLength);
                                              }

                                              // Ensure it fits within constraints
                                              final testStyle = TextStyle(
                                                fontSize: adaptiveFontSize,
                                                fontWeight: FontWeight.bold,
                                              );
                                              final testWidth =
                                                  _calculateTextWidth(
                                                    word,
                                                    testStyle,
                                                  );

                                              if (testWidth >
                                                      availableWordWidth &&
                                                  availableWordWidth > 0) {
                                                adaptiveFontSize =
                                                    adaptiveFontSize *
                                                    (availableWordWidth /
                                                        testWidth);
                                              }

                                              return FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  word,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: adaptiveFontSize
                                                        .clamp(14.0, 36.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF1A1A1A,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: isMobile ? 8 : 12),
                                        // Speaker icon - Right side
                                        Material(
                                          color: const Color(
                                            0xFFFFF3E0,
                                          ), // Light orange background
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: InkWell(
                                            onTap: () => _playAudio(word),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                isMobile
                                                    ? 6
                                                    : (isTablet ? 8 : 10),
                                              ),
                                              child: Icon(
                                                Icons.volume_up_rounded,
                                                color: const Color(
                                                  0xFFFF8F00,
                                                ), // Orange color
                                                size: (wordFontSize * 0.7)
                                                    .clamp(16.0, 28.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Image container - Flexible and neat - scales smoothly
                              Center(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: (screenWidth * 0.45 * scaleFactor)
                                        .clamp(180.0, 400.0),
                                    maxHeight:
                                        (screenHeight * 0.28 * scaleFactor)
                                            .clamp(140.0, 350.0),
                                  ),
                                  width: (screenWidth * 0.5 * scaleFactor)
                                      .clamp(180.0, 350.0),
                                  height: (screenWidth * 0.4 * scaleFactor)
                                      .clamp(
                                        140.0,
                                        280.0,
                                      ), // Maintains aspect ratio
                                  margin: EdgeInsets.only(
                                    bottom: (screenHeight * 0.025 * scaleFactor)
                                        .clamp(16.0, 28.0),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      16,
                                    ), // Match word container
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      16,
                                    ), // Match container border radius
                                    child: question.image.isNotEmpty
                                        ? Image.network(
                                            question.image,
                                            fit: BoxFit
                                                .cover, // Flexible fit within container
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const Center(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Color(0xFFFFA726)),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(
                                                      Icons.image_outlined,
                                                      size: 64,
                                                      color: Color(0xFFBDBDBD),
                                                    ),
                                                  );
                                                },
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 64,
                                              color: Color(0xFFBDBDBD),
                                            ),
                                          ),
                                  ),
                                ),
                              ),

                              // Main grid - Centered with constraints to prevent overflow
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth * 0.98,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Categories
                                      SizedBox(
                                        width: categoryWidth,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            _buildCategoryChip('உயிர்', 'uyir'),
                                            SizedBox(
                                              height: isMobile ? 6 : 8,
                                            ), // Responsive spacing
                                            _buildCategoryChip('மெய்', 'mei'),
                                            SizedBox(
                                              height: isMobile ? 6 : 8,
                                            ), // Responsive spacing
                                            _buildCategoryChip(
                                              'உயிர்மெய்',
                                              'uyirmei',
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: isMobile ? 8 : 12),

                                      // Letters grid - Flexible to prevent overflow
                                      Flexible(
                                        child: LayoutBuilder(
                                          builder: (context, letterConstraints) {
                                            // Calculate actual available width for letters
                                            final availableForLetters =
                                                letterConstraints.maxWidth;

                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildLetterRow(
                                                  letters,
                                                  'uyir',
                                                  availableForLetters,
                                                ),
                                                SizedBox(
                                                  height: isMobile ? 6 : 8,
                                                ), // Equal spacing matching category chips
                                                _buildLetterRow(
                                                  letters,
                                                  'mei',
                                                  availableForLetters,
                                                ),
                                                SizedBox(
                                                  height: isMobile ? 6 : 8,
                                                ), // Equal spacing matching category chips
                                                _buildLetterRow(
                                                  letters,
                                                  'uyirmei',
                                                  availableForLetters,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Minimal bottom padding
                              SizedBox(height: isMobile ? 8 : 12),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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

  Widget _buildCategoryChip(String label, String category) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Get color based on category
    Color getCategoryColor() {
      switch (category) {
        case 'uyir':
          return const Color(0xFF64B5F6); // Soft light blue
        case 'mei':
          return const Color(0xFFFFB74D); // Soft light orange
        case 'uyirmei':
          return const Color(0xFF81C784); // Soft light green
        default:
          return const Color(0xFFE0E0E0); // Grey default
      }
    }

    final categoryColor = getCategoryColor();

    // Calculate base scale factor for smooth scaling
    final baseScale = screenWidth / 400.0; // Base scale at 400px width
    final scaleFactor = baseScale.clamp(0.8, 2.5); // Limit scaling range

    // Responsive sizes - smooth scaling based on screen size - match letter row height
    final containerHeight = (screenWidth * 0.11 * scaleFactor).clamp(
      35.0,
      65.0,
    );
    final fontSize = (screenWidth * 0.035 * scaleFactor).clamp(12.0, 20.0);
    final horizontalPadding = (screenWidth * 0.025 * scaleFactor).clamp(
      6.0,
      16.0,
    );
    final verticalPadding = (screenWidth * 0.02 * scaleFactor).clamp(5.0, 14.0);
    final padding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );
    final borderRadius = (screenWidth * 0.02 * scaleFactor).clamp(7.0, 14.0);
    final borderWidth = (screenWidth * 0.003 * scaleFactor).clamp(0.8, 2.5);

    return Container(
      width: double.infinity,
      height: containerHeight,
      padding: padding,
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: categoryColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: categoryColor,
          ),
        ),
      ),
    );
  }

  // Helper method to calculate text width for a letter
  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  Widget _buildLetterRow(
    List<String> letters,
    String category,
    double maxAvailableWidth,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate base scale factor for smooth scaling - reduce for smaller screens
    final baseScale = screenWidth / 400.0; // Base scale at 400px width
    final scaleFactor = baseScale.clamp(
      0.7,
      2.0,
    ); // Reduced max scaling to prevent overflow

    // Responsive sizes - smooth scaling based on screen size - reduced for smaller screens
    // Match category chip height exactly for perfect alignment
    final rowHeight = (screenWidth * 0.11 * scaleFactor).clamp(35.0, 65.0);
    final fontSize = (screenWidth * 0.042 * scaleFactor).clamp(13.0, 26.0);

    return SizedBox(
      height: rowHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate width needed for each letter's text
          final textStyle = TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          );

          // Calculate individual widths for each letter (adaptive sizing) - reduced for smaller screens
          final padding = (screenWidth * 0.035 * scaleFactor).clamp(10.0, 24.0);
          final minWidth = (screenWidth * 0.09 * scaleFactor).clamp(32.0, 60.0);
          final maxWidth = (screenWidth * 0.25 * scaleFactor).clamp(
            75.0,
            180.0,
          );

          // Calculate width for each letter based on its actual text width
          List<double> letterWidths = [];
          double totalTextWidth = 0;

          for (String letter in letters) {
            final textWidth = _calculateTextWidth(letter, textStyle);
            final calculatedWidth = (textWidth + padding).clamp(
              minWidth,
              maxWidth,
            );
            letterWidths.add(calculatedWidth);
            totalTextWidth += calculatedWidth;
          }

          final spacing = (screenWidth * 0.012 * scaleFactor).clamp(2.0, 10.0);

          // Calculate total width needed for all letters
          final totalSpacing = spacing * (letters.length - 1);
          final totalWidthNeeded = totalTextWidth + totalSpacing;

          // Use the provided maxAvailableWidth or constraints.maxWidth, whichever is smaller
          final availableWidth =
              maxAvailableWidth > 0 && maxAvailableWidth < constraints.maxWidth
              ? maxAvailableWidth
              : (constraints.maxWidth > 0
                    ? constraints.maxWidth
                    : double.infinity);

          // Adjust letter widths proportionally if content exceeds available space
          List<double> adjustedWidths = List.from(letterWidths);
          if (totalWidthNeeded > availableWidth &&
              availableWidth != double.infinity) {
            // Calculate scale factor to fit all letters - ensure we don't exceed available space
            final availableForLetters = availableWidth - totalSpacing;
            final scaleDownFactor = availableForLetters > 0
                ? (availableForLetters / totalTextWidth).clamp(
                    0.3,
                    1.0,
                  ) // Minimum 30% of original size
                : 0.3;

            // Recalculate total with scaled widths
            double scaledTotal = 0;
            for (int i = 0; i < adjustedWidths.length; i++) {
              adjustedWidths[i] = (adjustedWidths[i] * scaleDownFactor).clamp(
                minWidth * 0.7, // Allow smaller minimum for tight spaces
                maxWidth,
              );
              scaledTotal += adjustedWidths[i];
            }

            // If still too wide, reduce minWidth further
            if (scaledTotal + totalSpacing > availableWidth) {
              final finalScale = (availableForLetters / scaledTotal).clamp(
                0.5,
                1.0,
              );
              for (int i = 0; i < adjustedWidths.length; i++) {
                adjustedWidths[i] = (adjustedWidths[i] * finalScale).clamp(
                  minWidth * 0.5, // Further reduced minimum
                  maxWidth,
                );
              }
            }
          }

          // Build row content with adjusted widths (no scrolling) - centered alignment
          Widget rowContent = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: letters.asMap().entries.map((entry) {
              int index = entry.key;
              String letter = entry.value;
              String key = '${letter}_$index';
              bool isSelected = userAnswers[key] == category;

              // Get color based on category - Soft, light colors for children
              Color getCategoryColor() {
                switch (category) {
                  case 'uyir':
                    return const Color(0xFF64B5F6); // Soft light blue
                  case 'mei':
                    return const Color(0xFFFFB74D); // Soft light orange
                  case 'uyirmei':
                    return const Color(0xFF81C784); // Soft light green
                  default:
                    return const Color(0xFFE0E0E0); // Grey default
                }
              }

              final categoryColor = getCategoryColor();

              // Check if this is the correct category for this letter
              final correctAnswers =
                  questions[currentQuestionIndex].correctAnswers;
              final correctCategory = correctAnswers[letter];
              final isCorrectCategory = category == correctCategory;

              // Disable if wrong answer was shown and this is not the correct category
              // But allow unselection even if disabled
              final isDisabled = _hasWrongAnswer && !isCorrectCategory;

              // Get adaptive width for this specific letter
              final letterWidth = adjustedWidths[index];

              return Padding(
                padding: EdgeInsets.only(
                  right: index < letters.length - 1 ? spacing : 0,
                ),
                child: SizedBox(
                  width: letterWidth, // Adaptive width based on letter length
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          // Always allow unselection
                          userAnswers[key] = null;
                        } else {
                          // Only allow selection if not disabled
                          if (!isDisabled) {
                            _selectCategory(letter, index, category);
                          }
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: letterWidth, // Use adaptive width for this letter
                      height:
                          rowHeight, // Match row height exactly for perfect alignment
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? categoryColor // Category color when selected
                            : isDisabled
                            ? Colors.grey.withOpacity(0.2) // Disabled color
                            : Colors.white, // Clean white when not selected
                        borderRadius: BorderRadius.circular(
                          (screenWidth * 0.018 * scaleFactor).clamp(5.0, 10.0),
                        ),
                        border: Border.all(
                          color: isSelected
                              ? categoryColor // Category border when selected
                              : isDisabled
                              ? Colors.grey.withOpacity(0.3) // Disabled border
                              : const Color(
                                  0xFFE0E0E0,
                                ), // Simple grey border when not selected
                          width: isSelected
                              ? (screenWidth * 0.004 * scaleFactor).clamp(
                                  1.2,
                                  2.5,
                                )
                              : (screenWidth * 0.0025 * scaleFactor).clamp(
                                  0.8,
                                  1.5,
                                ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? categoryColor.withOpacity(
                                    0.3,
                                  ) // Category shadow when selected
                                : Colors.grey.withOpacity(
                                    0.06,
                                  ), // Light shadow when not selected
                            blurRadius: isSelected
                                ? (screenWidth * 0.012 * scaleFactor).clamp(
                                    3.0,
                                    7.0,
                                  )
                                : (screenWidth * 0.005 * scaleFactor).clamp(
                                    1.5,
                                    3.0,
                                  ),
                            offset: Offset(
                              0,
                              isSelected
                                  ? (screenWidth * 0.006 * scaleFactor).clamp(
                                      1.5,
                                      3.5,
                                    )
                                  : (screenWidth * 0.0025 * scaleFactor).clamp(
                                      0.8,
                                      1.5,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors
                                        .white // White text when selected
                                  : isDisabled
                                  ? Colors.grey.withOpacity(
                                      0.5,
                                    ) // Disabled text
                                  : const Color(
                                      0xFF333333,
                                    ), // Dark text when not selected
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );

          // Return row content without scrolling - sizes are adjusted to fit
          return rowContent;
        },
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
