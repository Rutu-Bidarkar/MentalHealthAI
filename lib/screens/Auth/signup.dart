import 'package:flutter/material.dart';

// Theme constants (assuming these exist in your theme.dart file)
class AppTheme {
  static const borderRadius = 16.0;
  static const spacing = 16.0;

  static const colors = AppColors();
  static const shadows = AppShadows();
}

class AppColors {
  const AppColors();

  final Color background = const Color(0xFFF5F5F5);
  final Color cardBackground = const Color(0xFFFFFFFF);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF666666);
  final Color primary = const Color(0xFF6366F1);
  final Color accent = const Color(0xFF8B5CF6);
  final Color warning = const Color(0xFFEF4444);
}

class AppShadows {
  const AppShadows();

  final BoxShadow card = const BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    blurRadius: 12,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );

  final BoxShadow floating = const BoxShadow(
    color: Color.fromRGBO(99, 102, 241, 0.3),
    blurRadius: 16,
    spreadRadius: 0,
    offset: Offset(0, 4),
  );
}

// Enums for type safety (better than const objects)
enum SignupStep {
  userType,
  ageGroup,
  token,
  language,
  details,
}

enum UserType {
  organization,
  family,
  individual,
}

// Models
class UserTypeOption {
  final UserType id;
  final String icon;
  final String title;
  final String description;

  const UserTypeOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class Language {
  final String name;
  final String flag;

  const Language({
    required this.name,
    required this.flag,
  });
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupStep step = SignupStep.userType;
  UserType? userType;
  String? ageGroup;
  String token = '';
  String selectedLanguage = 'English';
  bool agreedTerms = false;
  bool agreedPrivacy = false;

  // Form controllers for Step 5
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? selectedAgeGroup;

  final List<Language> languages = const [
    Language(name: 'English', flag: '🇬🇧'),
    Language(name: 'हिन्दी', flag: '🇮🇳'),
    Language(name: 'मराठी', flag: '🇮🇳'),
    Language(name: 'ગુજરાતી', flag: '🇮🇳'),
    Language(name: 'తెలుగు', flag: '🇮🇳'),
    Language(name: 'தமிழ்', flag: '🇮🇳'),
  ];

  final List<UserTypeOption> userTypes = const [
    UserTypeOption(
      id: UserType.organization,
      icon: 'assets/images/organization.png',
      title: 'Organization',
      description: 'For workplace mental health',
    ),
    UserTypeOption(
      id: UserType.family,
      icon: 'assets/images/family.png',
      title: 'Family',
      description: 'Family wellness plan',
    ),
    UserTypeOption(
      id: UserType.individual,
      icon: 'assets/images/individual.png',
      title: 'Individual',
      description: 'Personal mental health journey',
    ),
  ];

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    locationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  int get stepNumber {
    return step.index + 1;
  }

  void handleNext() {
    if (step == SignupStep.token && userType == UserType.individual) {
      setState(() => step = SignupStep.language);
    } else if (stepNumber < 5) {
      setState(() => step = SignupStep.values[stepNumber]);
    }
  }

  void handleBack() {
    if (stepNumber > 1) {
      setState(() => step = SignupStep.values[stepNumber - 2]);
    } else {
      Navigator.pop(context);
    }
  }

  void handleSubmit() {
    // Collect all form data
    final signupData = {
      'userType': userType,
      'ageGroup': ageGroup,
      'token': token,
      'language': selectedLanguage,
      'fullName': fullNameController.text,
      'username': usernameController.text,
      'selectedAgeGroup': selectedAgeGroup,
      'location': locationController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'agreedTerms': agreedTerms,
      'agreedPrivacy': agreedPrivacy,
    };

    // TODO: Send data to backend/state management
    print('Signup Data: $signupData');

    Navigator.pushReplacementNamed(context, '/home');
  }

  bool get canProceed {
    switch (step) {
      case SignupStep.userType:
        return userType != null;
      case SignupStep.ageGroup:
        return ageGroup != null;
      case SignupStep.token:
        return userType == UserType.individual || token.isNotEmpty;
      case SignupStep.language:
        return true; // Language has a default value
      case SignupStep.details:
        return agreedTerms && agreedPrivacy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colors.cardBackground,
              boxShadow: [AppTheme.shadows.card],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: handleBack,
                      icon: const Icon(Icons.chevron_left, size: 24),
                      color: AppTheme.colors.textPrimary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Column(
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Step $stepNumber of 5',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40), // Spacer for alignment
                  ],
                ),
              ),
            ),
          ),

          // Progress Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 6,
                child: LinearProgressIndicator(
                  value: stepNumber / 5,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.colors.primary,
                  ),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildStepContent(),
            ),
          ),

          // Bottom Action Button
          Container(
            color: AppTheme.colors.background,
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              top: false,
              child: _ActionButton(
                onPressed: canProceed
                    ? (step == SignupStep.details ? handleSubmit : handleNext)
                    : null,
                text: step == SignupStep.details ? 'Create Account' : 'Next',
                showChevron: step != SignupStep.details,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (step) {
      case SignupStep.userType:
        return _buildUserTypeStep();
      case SignupStep.ageGroup:
        return _buildAgeGroupStep();
      case SignupStep.token:
        return _buildTokenStep();
      case SignupStep.language:
        return _buildLanguageStep();
      case SignupStep.details:
        return _buildDetailsStep();
    }
  }

  Widget _buildUserTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome! Let\'s get started',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppTheme.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose your account type',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        ...userTypes.map((type) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _SelectableCard(
            isSelected: userType == type.id,
            onTap: () => setState(() => userType = type.id),
            child: Row(
              children: [
                Image.asset(type.icon, width: 40, height: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (userType == type.id)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildAgeGroupStep() {
    final ageGroups = ['18 and above', 'Under 18'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your age group?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppTheme.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 32),
        ...ageGroups.map((age) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _SelectableCard(
            isSelected: ageGroup == age,
            onTap: () => setState(() => ageGroup = age),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  age,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colors.textPrimary,
                  ),
                ),
                if (ageGroup == age)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        )),
        if (ageGroup == 'Under 18')
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.colors.warning.withAlpha(30),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              border: Border.all(color: AppTheme.colors.warning),
            ),
            child: Text(
              '⚠️ Users under 18 require parental consent to use this platform.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.colors.textPrimary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTokenStep() {
    if (userType == UserType.individual) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your group token',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppTheme.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This was provided by your ${userType.toString().split('.').last} admin',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          onChanged: (value) => setState(() => token = value),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppTheme.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Enter token code',
            filled: true,
            fillColor: AppTheme.colors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: BorderSide(color: AppTheme.colors.primary, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.colors.textSecondary,
              ),
              children: [
                const TextSpan(text: 'Don\'t have a token? '),
                TextSpan(
                  text: 'Contact support',
                  style: TextStyle(
                    color: AppTheme.colors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                  // TODO: Add GestureRecognizer for tap handling
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your preferred language',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppTheme.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final lang = languages[index];
            final isSelected = selectedLanguage == lang.name;

            return _SelectableCard(
              isSelected: isSelected,
              onTap: () => setState(() => selectedLanguage = lang.name),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(lang.flag, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    lang.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.colors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete your profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        _InputField(
          controller: fullNameController,
          hintText: 'Full Name',
        ),
        const SizedBox(height: 16),
        _InputField(
          controller: usernameController,
          hintText: '@username',
        ),
        const SizedBox(height: 16),
        _DropdownField(
          value: selectedAgeGroup,
          hint: 'Select Age Group',
          items: const [
            '13-17',
            '18-25',
            '26-35',
            '36-45',
            '46-60',
            '60+',
          ],
          onChanged: (value) => setState(() => selectedAgeGroup = value),
        ),
        const SizedBox(height: 16),
        _InputField(
          controller: locationController,
          hintText: 'City / Location',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.location_on,
              color: AppTheme.colors.primary,
            ),
            onPressed: () {
              // TODO: Implement location picker
            },
          ),
        ),
        const SizedBox(height: 16),
        _InputField(
          controller: emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _InputField(
          controller: passwordController,
          hintText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        _InputField(
          controller: confirmPasswordController,
          hintText: 'Confirm Password',
          obscureText: true,
        ),
        const SizedBox(height: 24),
        _CheckboxRow(
          value: agreedTerms,
          onChanged: (value) => setState(() => agreedTerms = value ?? false),
          label: 'I agree to ',
          linkText: 'Terms & Conditions',
        ),
        const SizedBox(height: 12),
        _CheckboxRow(
          value: agreedPrivacy,
          onChanged: (value) => setState(() => agreedPrivacy = value ?? false),
          label: 'I agree to ',
          linkText: 'Privacy Policy',
        ),
      ],
    );
  }
}

// Reusable Widgets

class _SelectableCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const _SelectableCard({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.colors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(
            color: isSelected
                ? AppTheme.colors.primary
                : const Color(0xFFE0E0E0),
            width: 2,
          ),
          boxShadow: isSelected ? [AppTheme.shadows.card] : null,
        ),
        child: child,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _InputField({
    this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppTheme.colors.cardBackground,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: BorderSide(color: AppTheme.colors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.colors.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final String linkText;

  const _CheckboxRow({
    required this.value,
    required this.onChanged,
    required this.label,
    required this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.colors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.colors.textPrimary,
              ),
              children: [
                TextSpan(text: label),
                TextSpan(
                  text: linkText,
                  style: TextStyle(
                    color: AppTheme.colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  // TODO: Add GestureRecognizer for tap handling
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool showChevron;

  const _ActionButton({
    required this.onPressed,
    required this.text,
    this.showChevron = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: isEnabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.colors.primary,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              boxShadow: isEnabled ? [AppTheme.shadows.floating] : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.showChevron) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
