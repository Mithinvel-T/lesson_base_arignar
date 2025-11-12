import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/screens/tasks/simple_task.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

void main() {
  runApp(const LessonBaseApp());
}

class LessonBaseApp extends StatelessWidget {
  const LessonBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson Base',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightGrey,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(0.85)),
          child: child!,
        );
      },
      routes: {
        '/': (context) => const SimpleTaskWrapper(),
        '/simple-task': (context) => const SimpleTaskWrapper(),
      },
    );
  }
}

class SimpleTaskWrapper extends StatelessWidget {
  const SimpleTaskWrapper({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ScalableText(
          message,
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
          autoScale: false,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(211, 255, 153, 0),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Limit content width to prevent zoomed appearance
        final targetWidth = constraints.maxWidth.clamp(320.0, 420.0);

        return SizedBox(
          width: targetWidth,
          height: constraints.maxHeight,
          child: _EmbeddedAwareSimpleTask(
            onReady: () {},
            chapterID: 'chapter-001',
            lessonID: 'lesson-001',
            onLessonComplete: () => _showSnackBar(context, 'Lesson Complete!'),
            onExitPressed: () => _showSnackBar(context, 'Exit tapped'),
            onJumpToQuestion: () =>
                _showSnackBar(context, 'Jump to Question tapped'),
            onPrevLessonPressed: () =>
                _showSnackBar(context, 'Reached first lesson'),
          ),
        );
      },
    );
  }
}

class _EmbeddedAwareSimpleTask extends StatefulWidget {
  const _EmbeddedAwareSimpleTask({
    required this.onReady,
    required this.chapterID,
    required this.lessonID,
    required this.onLessonComplete,
    required this.onExitPressed,
    required this.onJumpToQuestion,
    required this.onPrevLessonPressed,
  });

  final VoidCallback onReady;
  final String chapterID;
  final String lessonID;
  final VoidCallback onLessonComplete;
  final VoidCallback onExitPressed;
  final VoidCallback onJumpToQuestion;
  final VoidCallback onPrevLessonPressed;

  @override
  State<_EmbeddedAwareSimpleTask> createState() =>
      _EmbeddedAwareSimpleTaskState();
}

class _EmbeddedAwareSimpleTaskState extends State<_EmbeddedAwareSimpleTask> {
  @override
  Widget build(BuildContext context) {
    return SimpleTask(
      chapterID: widget.chapterID,
      lessonID: widget.lessonID,
      onLessonComplete: widget.onLessonComplete,
      onExitPressed: widget.onExitPressed,
      onJumpToQuestion: widget.onJumpToQuestion,
      onPrevLessonPressed: widget.onPrevLessonPressed,
    );
  }
}
