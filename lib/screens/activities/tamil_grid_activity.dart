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
  Map<String, String?> userAnswers = {};
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
                  // Only move to next question if answer is correct
                  if (correct) {
                    // Small delay to ensure dialog closes before moving to next
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _nextQuestion();
                    });
                  }
                  // If wrong, just close the dialog (don't move to next)
                  // User can now select only correct answers
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
                child: Text(correct ? 'Continue' : 'OK'),
              ),
            ),
          ],
        );
      },
    ).then((result) {
      // Handle dialog dismissal (when tapping outside)
      // Only move to next if answer was correct and button wasn't clicked
      // (button click already handles navigation)
      if (correct && result != 'button_clicked' && !_dialogButtonClicked) {
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

    // Calculate sizes based on screen resolution
    final wordFontSize =
        screenWidth *
        (isMobile
            ? 0.06
            : isTablet
            ? 0.04
            : 0.035);
    final maxWidth = screenWidth > 900 ? 650.0 : screenWidth * 0.95;
    final categoryWidth = isMobile
        ? 85.0
        : isTablet
        ? 110.0
        : 140.0; // Larger for iPad Pro

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
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile
                                        ? 20
                                        : (isTablet
                                              ? 24
                                              : 28), // Increased horizontal padding
                                    vertical: isMobile
                                        ? 10
                                        : (isTablet
                                              ? 12
                                              : 14), // Reduced vertical padding
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Word text - Centered
                                      Text(
                                        word,
                                        style: TextStyle(
                                          fontSize: wordFontSize.clamp(
                                            20.0,
                                            40.0,
                                          ), // Responsive based on screen width
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Speaker icon - Right side
                                      Material(
                                        color: const Color(
                                          0xFFFFF3E0,
                                        ), // Light orange background
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                          onTap: () => _playAudio(word),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              screenWidth * 0.02,
                                            ),
                                            child: Icon(
                                              Icons.volume_up_rounded,
                                              color: const Color(
                                                0xFFFF8F00,
                                              ), // Orange color
                                              size:
                                                  wordFontSize *
                                                  0.7, // Scale with word font size
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Image container - Rectangular, centered, perfect shape
                              Center(
                                child: Container(
                                  width: isMobile
                                      ? 200
                                      : isTablet
                                      ? 260
                                      : 300, // Perfect sizes
                                  height: isMobile
                                      ? 160
                                      : isTablet
                                      ? 210
                                      : 250, // Perfect sizes - maintains aspect ratio
                                  margin: const EdgeInsets.only(bottom: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
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
                                    borderRadius: BorderRadius.circular(16),
                                    child: question.image.isNotEmpty
                                        ? Image.network(
                                            question.image,
                                            fit: BoxFit
                                                .fill, // Perfect fit within container
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

                              // Main grid - Centered
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Categories
                                    SizedBox(
                                      width: categoryWidth,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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

                                    const SizedBox(width: 12),

                                    // Letters grid
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _buildLetterRow(letters, 'uyir'),
                                        SizedBox(
                                          height: isMobile ? 6 : 8,
                                        ), // Responsive spacing
                                        _buildLetterRow(letters, 'mei'),
                                        SizedBox(
                                          height: isMobile ? 6 : 8,
                                        ), // Responsive spacing
                                        _buildLetterRow(letters, 'uyirmei'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Add bottom padding to prevent color gap when scrolling
                              SizedBox(height: isMobile ? 16 : 24),
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
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

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

    // Responsive sizes - match word container height
    final containerHeight = isMobile
        ? 42.0
        : isTablet
        ? 52.0
        : 60.0; // Match word container height
    final fontSize = isMobile
        ? 13.0
        : isTablet
        ? 16.0
        : 18.0; // Larger for iPad Pro
    final padding = isMobile
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6)
        : isTablet
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
        : const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ); // Larger for iPad Pro
    final borderRadius = isMobile ? 8.0 : (isTablet ? 10.0 : 12.0);
    final borderWidth = isMobile ? 1.0 : (isTablet ? 1.5 : 2.0);

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

  Widget _buildLetterRow(List<String> letters, String category) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    // Responsive sizes - match word container height
    final rowHeight = isMobile
        ? 42.0
        : isTablet
        ? 52.0
        : 60.0; // Match word container height
    final fontSize = isMobile
        ? 15.0
        : isTablet
        ? 20.0
        : 24.0; // Larger for iPad Pro

    return SizedBox(
      height: rowHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate width needed for each letter's text
          final textStyle = TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          );

          // Find the maximum text width among all letters
          double maxTextWidth = 0;
          for (String letter in letters) {
            final textWidth = _calculateTextWidth(letter, textStyle);
            if (textWidth > maxTextWidth) {
              maxTextWidth = textWidth;
            }
          }

          // Responsive padding and box width - larger for tablets and iPad Pro
          final padding = isMobile
              ? 14.0
              : isTablet
              ? 20.0
              : 24.0; // Larger for iPad Pro
          final calculatedBoxWidth = maxTextWidth + padding;

          // Clamp to reasonable size: larger for tablets and iPad Pro
          final minWidth = isMobile
              ? 45.0
              : isTablet
              ? 60.0
              : 70.0; // Larger for iPad Pro
          final maxWidth = isMobile
              ? 90.0
              : isTablet
              ? 130.0
              : 150.0; // Larger for iPad Pro
          final boxWidth = calculatedBoxWidth.clamp(minWidth, maxWidth);

          final spacing = isMobile
              ? 4.0
              : isTablet
              ? 8.0
              : 10.0; // More spacing for larger screens

          // Calculate total width needed for all letters
          final totalWidthNeeded =
              (boxWidth * letters.length) + (spacing * (letters.length - 1));

          // Use SingleChildScrollView if content exceeds available width
          Widget rowContent = Row(
            mainAxisAlignment: MainAxisAlignment.start,
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

              return Padding(
                padding: EdgeInsets.only(
                  right: index < letters.length - 1 ? spacing : 0,
                ),
                child: SizedBox(
                  width: boxWidth, // Uniform width based on largest letter
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
                      width:
                          boxWidth, // Ensure uniform width for all containers
                      height: isMobile
                          ? 38.0
                          : isTablet
                          ? 48.0
                          : 56.0, // Match word container height
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? categoryColor // Category color when selected
                            : isDisabled
                            ? Colors.grey.withOpacity(0.2) // Disabled color
                            : Colors.white, // Clean white when not selected
                        borderRadius: BorderRadius.circular(
                          isMobile ? 6.0 : 8.0,
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
                              ? (isMobile ? 1.5 : 2.0)
                              : (isMobile ? 1.0 : 1.2),
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
                            blurRadius: isSelected ? (isMobile ? 4 : 6) : 2,
                            offset: Offset(
                              0,
                              isSelected ? (isMobile ? 2.0 : 3.0) : 1.0,
                            ),
                          ),
                        ],
                      ),
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors
                                    .white // White text when selected
                              : isDisabled
                              ? Colors.grey.withOpacity(0.5) // Disabled text
                              : const Color(
                                  0xFF333333,
                                ), // Dark text when not selected
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );

          // Wrap in scrollable if content is wider than available space
          if (totalWidthNeeded > constraints.maxWidth) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: rowContent,
            );
          } else {
            return rowContent;
          }
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
