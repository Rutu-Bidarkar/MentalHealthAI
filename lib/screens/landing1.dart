import 'package:flutter/material.dart';

// Theme constants
class AppTheme {
  static const borderRadius = 16.0;
  static const effects = AppEffects();
}

class AppColors {
  const AppColors._();
  static const Color primary = Color(0xFF6366F1);
}

class AppShadows {
  const AppShadows._();

  static const BoxShadow glow = BoxShadow(
    color: Color.fromRGBO(99, 102, 241, 0.4),
    blurRadius: 24,
    spreadRadius: 0,
  );

  static const BoxShadow soft = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    blurRadius: 8,
    spreadRadius: 0,
  );

  static const BoxShadow card = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    blurRadius: 12,
    spreadRadius: 0,
  );

  static const BoxShadow innerGlow = BoxShadow(
    color: Color.fromRGBO(99, 102, 241, 0.3),
    blurRadius: 16,
    spreadRadius: 0,
  );
}

class AppGradients {
  const AppGradients._();

  static const LinearGradient ocean = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  );

  static const LinearGradient forest = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
  );

  static const LinearGradient sunset = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF38EF7D), Color(0xFFFF5858)],
  );

  static const LinearGradient peace = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
  );

  static const LinearGradient primaryGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );
}

class AppEffects {
  const AppEffects();

  BoxDecoration get glassCard => BoxDecoration(
        color: Colors.white.withAlpha(51), // 20% opacity
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white.withAlpha(77), // 30% opacity
          width: 1,
        ),
        backgroundBlendMode: BlendMode.overlay,
      );

  BoxDecoration get glass => BoxDecoration(
        color: Colors.white.withAlpha(38), // 15% opacity
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: Colors.white.withAlpha(51), // 20% opacity
          width: 1,
        ),
      );
}

// Onboarding slide model
class OnboardingSlide {
  final String title;
  final String description;
  final LinearGradient gradient;
  final String imagePath;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.gradient,
    required this.imagePath,
  });
}

class Landing1 extends StatefulWidget {
  const Landing1({Key? key}) : super(key: key);

  @override
  State<Landing1> createState() => _Landing1State();
}

class _Landing1State extends State<Landing1>
    with SingleTickerProviderStateMixin {
  int currentSlide = 0;
  late AnimationController _shimmerController;

  // IMPORTANT: Update these paths to match your asset structure
  final List<OnboardingSlide> onboardingSlides = const [
    OnboardingSlide(
      title: "Welcome to MindfulCare",
      description: "Your personalized mental health companion",
      gradient: AppGradients.ocean,
      imagePath: 'assets/images/Welcome lp.png',
    ),
    OnboardingSlide(
      title: "Understand Yourself Better",
      description: "Take validated assessments to track your mental health",
      gradient: AppGradients.forest,
      imagePath: 'assets/images/Understand urself lp.png',
    ),
    OnboardingSlide(
      title: "Evidence-Based Exercises",
      description: "Access 12+ unique activities tailored to your needs",
      gradient: AppGradients.sunset,
      imagePath: 'assets/images/Evidence lp.png',
    ),
    OnboardingSlide(
      title: "You're Not Alone",
      description: "Connect with a supportive community",
      gradient: AppGradients.peace,
      imagePath: 'assets/images/Community lp.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void goToNext() {
    if (currentSlide < onboardingSlides.length - 1) {
      setState(() {
        currentSlide++;
      });
    } else {
      Navigator.pushNamed(context, '/signup');
    }
  }

  void goToPrev() {
    if (currentSlide > 0) {
      setState(() {
        currentSlide--;
      });
    }
  }

  bool get isLastSlide => currentSlide == onboardingSlides.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: onboardingSlides[currentSlide].gradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main content area with card
              Expanded(
                child: Stack(
                  children: [
                    // Subtle overlay pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: CustomPaint(
                          painter: DotPatternPainter(),
                        ),
                      ),
                    ),
                    // Content
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image circle with shimmer
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 128,
                                  height: 128,
                                  decoration:
                                      AppTheme.effects.glassCard.copyWith(
                                    boxShadow: [AppShadows.glow],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Stack(
                                      children: [
                                        // Shimmer effect
                                        AnimatedBuilder(
                                          animation: _shimmerController,
                                          builder: (context, child) {
                                            return Positioned(
                                              left: -128 +
                                                  (_shimmerController.value *
                                                      256),
                                              top: 0,
                                              bottom: 0,
                                              child: Container(
                                                width: 128,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.white.withAlpha(153), // 60% opacity
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Image
                                Image.asset(
                                  onboardingSlides[currentSlide].imagePath,
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback if image not found
                                    return const Icon(
                                      Icons.image,
                                      size: 64,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Title
                            Text(
                              onboardingSlides[currentSlide].title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.2),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Description
                            Text(
                              onboardingSlides[currentSlide].description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withAlpha(242), // 95% opacity
                                height: 1.6,
                                shadows: const [
                                  Shadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation dots
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingSlides.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() => currentSlide = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentSlide == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: currentSlide == index
                              ? AppGradients.primaryGlow
                              : null,
                          color: currentSlide == index
                              ? null
                              : const Color.fromRGBO(0, 0, 0, 0.15),
                          boxShadow: currentSlide == index
                              ? [AppShadows.soft]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                child: Row(
                  children: [
                    if (currentSlide > 0) ...[
                      Expanded(
                        child: _GlassButton(
                          onPressed: goToPrev,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chevron_left, size: 20),
                              SizedBox(width: 8),
                              Text('Back'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      flex: currentSlide > 0 ? 1 : 2,
                      child: _PrimaryButton(
                        onPressed: goToNext,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(isLastSlide ? 'Get Started' : 'Continue'),
                            if (!isLastSlide) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, size: 20),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for dot pattern
class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(38) // 15% opacity
      ..style = PaintingStyle.fill;

    const spacing = 40.0;
    const dotRadius = 1.0;

    for (double x = 2; x < size.width; x += spacing) {
      for (double y = 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Reusable glass button widget
class _GlassButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _GlassButton({
    required this.onPressed,
    required this.child,
  });

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 52,
          decoration: AppTheme.effects.glass.copyWith(
            boxShadow: [AppShadows.card],
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: IconTheme(
              data: const IconThemeData(color: AppColors.primary),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable primary button widget
class _PrimaryButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _PrimaryButton({
    required this.onPressed,
    required this.child,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGlow,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            boxShadow: [AppShadows.innerGlow],
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: IconTheme(
              data: const IconThemeData(color: Colors.white),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
