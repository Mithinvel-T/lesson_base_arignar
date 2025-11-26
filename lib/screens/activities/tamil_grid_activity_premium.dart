import 'package:flutter/material.dart';
import 'models/letter_question.dart';
import 'data/letter_questions_data.dart';

// Professional Tamil Letter Classification Activity - Premium UI Design
class TamilGridActivity extends StatefulWidget {
  final VoidCallback? onExit;

  const TamilGridActivity({super.key, this.onExit});

  @override
  State<TamilGridActivity> createState() => _TamilGridActivityState();
}

class _TamilGridActivityState extends State<TamilGridActivity>
    with TickerProviderStateMixin {
  final List<LetterQuestion> questions = LetterQuestionsData.questions;

  int currentQuestionIndex = 0;
  Map<String, String?> userAnswers = {};

  // Animation Controllers for Premium UI
  late AnimationController _progressController;
  late AnimationController _cardController;
  late AnimationController _letterController;

  late Animation<double> _progressAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _letterAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _letterController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
    _letterAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _letterController, curve: Curves.bounceInOut),
    );

    _initializeQuestion();
    _startAnimations();
  }

  void _startAnimations() {
    _cardController.forward();
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _progressController.forward(),
    );
    Future.delayed(
      const Duration(milliseconds: 400),
      () => _letterController.forward(),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cardController.dispose();
    _letterController.dispose();
    super.dispose();
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

    // Add haptic feedback and animation
    _playSelectionAnimation();
  }

  void _playSelectionAnimation() {
    _letterController.reset();
    _letterController.forward();
  }

  bool _areAllAnswersSelected() {
    return userAnswers.values.every((answer) => answer != null);
  }

  // Professional responsive text scaling
  double _getResponsiveFont(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = (screenWidth / 375).clamp(0.8, 2.0); // Base width 375px
    return (baseSize * scaleFactor).clamp(baseSize * 0.8, baseSize * 1.6);
  }

  // Premium responsive spacing
  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (baseSpacing * (screenWidth / 375)).clamp(
      baseSpacing * 0.7,
      baseSpacing * 1.8,
    );
  }

  void _verifyAnswers() {
    final letters = questions[currentQuestionIndex].letters;
    final correctAnswers = questions[currentQuestionIndex].correctAnswers;

    if (!_areAllAnswersSelected()) {
      _showPremiumMessage('எல்லா எழுத்துகளையும் தேர்வு செய்யவும்! 🤗', false);
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

    _showPremiumResultDialog(correct, wrongAnswers);
  }

  void _showPremiumMessage(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.info_outline,
              color: Colors.white,
              size: _getResponsiveFont(context, 20),
            ),
            SizedBox(width: _getResponsiveSpacing(context, 8)),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: _getResponsiveFont(context, 14),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess
            ? const Color(0xFF4CAF50)
            : const Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(_getResponsiveSpacing(context, 16)),
        elevation: 8,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showPremiumResultDialog(
    bool correct,
    Map<String, String> wrongAnswers,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => ScaleTransition(
        scale: _cardAnimation,
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            constraints: BoxConstraints(
              maxWidth: _getResponsiveSpacing(context, 320),
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: correct
                    ? [
                        const Color(0xFFF0F9FF),
                        const Color(0xFFE8F5E8),
                        Colors.white,
                      ]
                    : [
                        const Color(0xFFFFF8E1),
                        const Color(0xFFFFE8D6),
                        Colors.white,
                      ],
              ),
              borderRadius: BorderRadius.circular(
                _getResponsiveSpacing(context, 24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(_getResponsiveSpacing(context, 24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Premium result icon with glow
                  Container(
                    width: _getResponsiveSpacing(context, 80),
                    height: _getResponsiveSpacing(context, 80),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: correct
                            ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                            : [
                                const Color(0xFFFF7043),
                                const Color(0xFFFF8A65),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(
                        _getResponsiveSpacing(context, 40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (correct
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFFF7043))
                                  .withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      correct
                          ? Icons.celebration_rounded
                          : Icons.emoji_emotions_outlined,
                      color: Colors.white,
                      size: _getResponsiveFont(context, 40),
                    ),
                  ),

                  SizedBox(height: _getResponsiveSpacing(context, 20)),

                  // Result text with premium typography
                  Text(
                    correct ? 'அருமை! சரியான பதில்! 🎉' : 'கவலையே வேண்டாம்! 😊',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _getResponsiveFont(context, 24),
                      fontWeight: FontWeight.bold,
                      color: correct
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFD84315),
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: _getResponsiveSpacing(context, 8)),

                  Text(
                    correct
                        ? 'நீங்கள் மிகச் சிறப்பாக செய்தீர்கள்!'
                        : 'மீண்டும் முயற்சி செய்யுங்கள்!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _getResponsiveFont(context, 16),
                      color: const Color(0xFF424242),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Show correct answers with premium design
                  if (!correct && wrongAnswers.isNotEmpty) ...[
                    SizedBox(height: _getResponsiveSpacing(context, 20)),
                    Container(
                      padding: EdgeInsets.all(
                        _getResponsiveSpacing(context, 16),
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF0F9FF), Color(0xFFE8F5E8)],
                        ),
                        borderRadius: BorderRadius.circular(
                          _getResponsiveSpacing(context, 16),
                        ),
                        border: Border.all(
                          color: const Color(0xFF4CAF50),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                color: const Color(0xFF2E7D32),
                                size: _getResponsiveFont(context, 20),
                              ),
                              SizedBox(
                                width: _getResponsiveSpacing(context, 8),
                              ),
                              Text(
                                'சரியான பதில்:',
                                style: TextStyle(
                                  fontSize: _getResponsiveFont(context, 16),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: _getResponsiveSpacing(context, 12)),
                          ...wrongAnswers.entries.map((entry) {
                            String categoryName = entry.value == 'uyir'
                                ? 'உயிர்'
                                : entry.value == 'mei'
                                ? 'மெய்'
                                : 'உயிர்மெய்';
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: _getResponsiveSpacing(context, 2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: _getResponsiveSpacing(
                                        context,
                                        12,
                                      ),
                                      vertical: _getResponsiveSpacing(
                                        context,
                                        6,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        _getResponsiveSpacing(context, 8),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF4CAF50),
                                      ),
                                    ),
                                    child: Text(
                                      '${entry.key} → $categoryName',
                                      style: TextStyle(
                                        fontSize: _getResponsiveFont(
                                          context,
                                          14,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: _getResponsiveSpacing(context, 24)),

                  // Premium action button
                  Container(
                    width: double.infinity,
                    height: _getResponsiveSpacing(context, 56),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: correct
                            ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                            : [
                                const Color(0xFF2196F3),
                                const Color(0xFF42A5F5),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(
                        _getResponsiveSpacing(context, 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (correct
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFF2196F3))
                                  .withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (correct) {
                            _nextQuestion();
                          }
                        },
                        borderRadius: BorderRadius.circular(
                          _getResponsiveSpacing(context, 16),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                correct
                                    ? Icons.arrow_forward_rounded
                                    : Icons.refresh_rounded,
                                color: Colors.white,
                                size: _getResponsiveFont(context, 20),
                              ),
                              SizedBox(
                                width: _getResponsiveSpacing(context, 8),
                              ),
                              Text(
                                correct
                                    ? 'அடுத்த கேள்விக்கு செல்லுங்கள்'
                                    : 'மீண்டும் முயற்சிக்கவும்',
                                style: TextStyle(
                                  fontSize: _getResponsiveFont(context, 16),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      _startAnimations();
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.all(_getResponsiveSpacing(context, 24)),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF8E1), Color(0xFFE8F5E8), Colors.white],
            ),
            borderRadius: BorderRadius.circular(
              _getResponsiveSpacing(context, 24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: const Color(0xFFFFB300),
                size: _getResponsiveFont(context, 60),
              ),
              SizedBox(height: _getResponsiveSpacing(context, 16)),
              Text(
                'வாழ்த்துக்கள்! 🏆',
                style: TextStyle(
                  fontSize: _getResponsiveFont(context, 28),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              Text(
                'எல்லா கேள்விகளையும் முடித்துவிட்டீர்கள்!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _getResponsiveFont(context, 16),
                  color: const Color(0xFF424242),
                ),
              ),
              SizedBox(height: _getResponsiveSpacing(context, 20)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentQuestionIndex = 0;
                    _initializeQuestion();
                  });
                  _startAnimations();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: EdgeInsets.symmetric(
                    horizontal: _getResponsiveSpacing(context, 24),
                    vertical: _getResponsiveSpacing(context, 12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _getResponsiveSpacing(context, 12),
                    ),
                  ),
                ),
                child: Text(
                  'மீண்டும் விளையாட வேண்டுமா?',
                  style: TextStyle(
                    fontSize: _getResponsiveFont(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
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
    final screenHeight = MediaQuery.of(context).size.height;

    // Professional responsive layout calculations
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;
    final maxContentWidth = isDesktop
        ? 800.0
        : (isTablet ? screenWidth * 0.8 : screenWidth * 0.95);
    final contentPadding = _getResponsiveSpacing(context, isTablet ? 32 : 20);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA), // Light neutral top
              Color(0xFFF1F3F4), // Slightly darker middle
              Color(0xFFE8F5E8), // Soft green bottom for kids
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Premium top header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(contentPadding),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Column(
                      children: [
                        // Beautiful question card
                        AnimatedBuilder(
                          animation: _cardAnimation,
                          builder: (context, child) => Transform.scale(
                            scale: _cardAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(
                                _getResponsiveSpacing(context, 20),
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.white, Color(0xFFF8F9FA)],
                                ),
                                borderRadius: BorderRadius.circular(
                                  _getResponsiveSpacing(context, 20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                    spreadRadius: 2,
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color(
                                    0xFF2196F3,
                                  ).withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'இந்த சொற்களில் எந்த எழுத்து — உயிர், மெய், உயிர்மெய் ?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _getResponsiveFont(context, 16),
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1A1A),
                                  letterSpacing: 0.5,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: _getResponsiveSpacing(context, 20)),

                        // Premium progress indicator
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: _getResponsiveSpacing(context, 16),
                              vertical: _getResponsiveSpacing(context, 12),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(
                                _getResponsiveSpacing(context, 12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'கேள்வி ${currentQuestionIndex + 1}/${questions.length}',
                                      style: TextStyle(
                                        fontSize: _getResponsiveFont(
                                          context,
                                          14,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2196F3),
                                      ),
                                    ),
                                    Text(
                                      '${(progress * 100).toInt()}% முடிந்தது',
                                      style: TextStyle(
                                        fontSize: _getResponsiveFont(
                                          context,
                                          14,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: _getResponsiveSpacing(context, 8),
                                ),
                                Container(
                                  height: _getResponsiveSpacing(context, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      _getResponsiveSpacing(context, 4),
                                    ),
                                    color: const Color(0xFFE3F2FD),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor:
                                        progress * _progressAnimation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          _getResponsiveSpacing(context, 4),
                                        ),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF2196F3),
                                            Color(0xFF42A5F5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: _getResponsiveSpacing(context, 24)),

                        // Beautiful word display with sound
                        Container(
                          padding: EdgeInsets.all(
                            _getResponsiveSpacing(context, 20),
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF3E5F5), Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(
                              _getResponsiveSpacing(context, 20),
                            ),
                            border: Border.all(
                              color: const Color(0xFF9C27B0).withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF9C27B0).withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                word,
                                style: TextStyle(
                                  fontSize: _getResponsiveFont(context, 32),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A1A),
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(
                                width: _getResponsiveSpacing(context, 12),
                              ),
                              Container(
                                padding: EdgeInsets.all(
                                  _getResponsiveSpacing(context, 8),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9C27B0),
                                  borderRadius: BorderRadius.circular(
                                    _getResponsiveSpacing(context, 12),
                                  ),
                                ),
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: Colors.white,
                                  size: _getResponsiveFont(context, 24),
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

              // Main interactive area
              Expanded(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    padding: EdgeInsets.symmetric(horizontal: contentPadding),
                    child: AnimatedBuilder(
                      animation: _letterAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: 0.8 + (_letterAnimation.value * 0.2),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Premium category chips
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildPremiumCategoryChip(
                                    'உயிர்',
                                    const Color(0xFF4CAF50),
                                  ),
                                  _buildPremiumCategoryChip(
                                    'மெய்',
                                    const Color(0xFF2196F3),
                                  ),
                                  _buildPremiumCategoryChip(
                                    'உயிர்மெய்',
                                    const Color(0xFFFF9800),
                                  ),
                                ],
                              ),

                              SizedBox(
                                width: _getResponsiveSpacing(context, 24),
                              ),

                              // Premium letter grid
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildPremiumLetterRow(
                                    letters,
                                    'uyir',
                                    const Color(0xFF4CAF50),
                                  ),
                                  _buildPremiumLetterRow(
                                    letters,
                                    'mei',
                                    const Color(0xFF2196F3),
                                  ),
                                  _buildPremiumLetterRow(
                                    letters,
                                    'uyirmei',
                                    const Color(0xFFFF9800),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Premium bottom navigation
              Container(
                padding: EdgeInsets.all(contentPadding),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8F9FA), Colors.white],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPremiumNavButton(
                        Icons.home_rounded,
                        'முகப்பு',
                        () => Navigator.pop(context),
                        true,
                        const Color(0xFF9E9E9E),
                      ),
                      _buildPremiumNavButton(
                        Icons.arrow_back_rounded,
                        'முன்பு',
                        currentQuestionIndex > 0
                            ? () {
                                setState(() {
                                  currentQuestionIndex--;
                                  _initializeQuestion();
                                });
                                _startAnimations();
                              }
                            : null,
                        currentQuestionIndex > 0,
                        const Color(0xFF2196F3),
                      ),
                      _buildPremiumNavButton(
                        Icons.arrow_forward_rounded,
                        'அடுத்தது',
                        _areAllAnswersSelected()
                            ? () => _verifyAnswers()
                            : null,
                        _areAllAnswersSelected(),
                        const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCategoryChip(String label, Color color) {
    return Container(
      width: _getResponsiveSpacing(context, 120),
      height: _getResponsiveSpacing(context, 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(_getResponsiveSpacing(context, 16)),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: _getResponsiveFont(context, 16),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumLetterRow(
    List<String> letters,
    String category,
    Color categoryColor,
  ) {
    return SizedBox(
      height: _getResponsiveSpacing(context, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.asMap().entries.map((entry) {
          int index = entry.key;
          String letter = entry.value;
          String key = '${letter}_$index';
          bool isSelected = userAnswers[key] == category;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getResponsiveSpacing(context, 4),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _getResponsiveSpacing(context, 50),
              height: _getResponsiveSpacing(context, 50),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [categoryColor, categoryColor.withOpacity(0.8)],
                      )
                    : const LinearGradient(
                        colors: [Colors.white, Color(0xFFF8F9FA)],
                      ),
                borderRadius: BorderRadius.circular(
                  _getResponsiveSpacing(context, 12),
                ),
                border: Border.all(
                  color: isSelected ? categoryColor : const Color(0xFFE0E0E0),
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? categoryColor.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: isSelected ? 12 : 6,
                    offset: Offset(0, isSelected ? 6 : 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectCategory(letter, index, category),
                  borderRadius: BorderRadius.circular(
                    _getResponsiveSpacing(context, 12),
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: _getResponsiveFont(context, 20),
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1A1A1A),
                      ),
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

  Widget _buildPremiumNavButton(
    IconData icon,
    String label,
    VoidCallback? onPressed,
    bool enabled,
    Color color,
  ) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: Container(
        constraints: BoxConstraints(
          minWidth: _getResponsiveSpacing(context, 80),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _getResponsiveSpacing(context, 56),
              height: _getResponsiveSpacing(context, 56),
              decoration: BoxDecoration(
                gradient: enabled
                    ? LinearGradient(colors: [color, color.withOpacity(0.8)])
                    : LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                      ),
                borderRadius: BorderRadius.circular(
                  _getResponsiveSpacing(context, 16),
                ),
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: enabled ? onPressed : null,
                  borderRadius: BorderRadius.circular(
                    _getResponsiveSpacing(context, 16),
                  ),
                  child: Icon(
                    icon,
                    color: enabled ? Colors.white : Colors.grey.shade600,
                    size: _getResponsiveFont(context, 24),
                  ),
                ),
              ),
            ),
            SizedBox(height: _getResponsiveSpacing(context, 8)),
            Text(
              label,
              style: TextStyle(
                fontSize: _getResponsiveFont(context, 12),
                fontWeight: FontWeight.w600,
                color: enabled ? color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
