import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../models/mood_model.dart';
import '../services/mood_tag_service.dart';

// Theme constants
class AppTheme {
  const AppTheme._();
  static const double borderRadius = 16.0;
}

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color primary = Color(0xFF6366F1);
  static const Color accent = Color(0xFF8B5CF6);
  static const Color privacy = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
}

class AppShadows {
  const AppShadows._();

  static const BoxShadow card = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    blurRadius: 12,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );
}

// Models
enum EntryMode { write, voice }
enum AiTone { casual, supportive, professional, empathetic }

class JournalTheme {
  final String name;
  final String backgroundPath;
  final bool isDark;

  const JournalTheme({required this.name, required this.backgroundPath, this.isDark = false});
}

class JournalEntry {
  final String id;
  final DateTime date;
  final String content;
  final String mood;
  final List<String> tags;

  JournalEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.mood,
    this.tags = const [],
  });

  String get preview {
    if (content.length <= 60) return content;
    return '${content.substring(0, 60)}...';
  }
}

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // State variables
  // State variables
  EntryMode _entryMode = EntryMode.write;
  bool _aiEnabled = false;
  AiTone? _selectedTone;
  bool _isRecording = false;
  bool _isSaving = false;
  bool _showChatInterface = false;
  List<ChatMessage> _chatMessages = [];

  // Theme & Font State
  late JournalTheme _currentTheme;
  late TextStyle _currentFont;
  
  // Themes List
  final List<JournalTheme> _themes = const [
    JournalTheme(name: 'Default', backgroundPath: ''), // No background
    JournalTheme(name: 'Space', backgroundPath: 'assets/images/space.jpg', isDark: true),
    JournalTheme(name: 'Night Walk', backgroundPath: 'assets/images/Night walk.jpg', isDark: true),
    JournalTheme(name: 'Beach', backgroundPath: 'assets/images/Beach.jpg'),
    JournalTheme(name: 'Countryside', backgroundPath: 'assets/images/Countryside farm.jpg'),
    JournalTheme(name: 'Waterfall', backgroundPath: 'assets/images/Waterfall.jpg'),
    JournalTheme(name: 'Office', backgroundPath: 'assets/images/Office space.jpg'),
    JournalTheme(name: 'Forest', backgroundPath: 'assets/images/Forest.jpg'),
    JournalTheme(name: 'Castle', backgroundPath: 'assets/images/Castle.jpg'),
    JournalTheme(name: 'Snow Cabin', backgroundPath: 'assets/images/snow covered cabin.jpg'),
    JournalTheme(name: 'Cozy Indoors', backgroundPath: 'assets/images/cozy indoors.jpg'),
  ];

  // Fonts List
  final List<String> _fontNames = [
    'Lato', 'Raleway', 'Quicksand', 'Montserrat', 'Open Sans',
    'Roboto Slab', 'Merriweather', 'Playfair Display', 'Lora', 'Nunito'
  ];

  // Controllers
  final TextEditingController _entryController = TextEditingController();
  final FocusNode _entryFocus = FocusNode();

  // Data
  List<JournalEntry> _pastEntries = [];

  DateTime get _today => DateTime.now();
  String get _todayFormatted => DateFormat('MMMM dd, yyyy').format(_today);

  int get _wordCount {
    if (_entryController.text.trim().isEmpty) return 0;
    return _entryController.text.trim().split(RegExp(r'\s+')).length;
  }

  @override
  void initState() {
    super.initState();
    _currentTheme = _themes[0];
    _currentFont = GoogleFonts.lato();
    _loadPastEntries();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _entryFocus.dispose();
    super.dispose();
  }

  Future<void> _loadPastEntries() async {
    setState(() {
      _pastEntries = [
        JournalEntry(
          id: '1',
          date: DateTime.now().subtract(const Duration(days: 1)),
          content: 'Had a great day today. Managed to complete all my tasks.',
          mood: '😊',
        ),
      ];
    });
  }

  Future<void> _saveEntry() async {
    if (_entryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something before saving')),
      );
      return;
    }

    // Show Mood Selection Dialog
    final result = await showDialog<MoodFeedbackResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _MoodFeedbackDialog(),
    );

    if (result == null) return; // User cancelled

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1)); 

    final newEntry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _today,
      content: _entryController.text,
      mood: result.mood.emoji,
      tags: result.tags,
    );

    setState(() {
      _pastEntries.insert(0, newEntry);
      _isSaving = false;
      _entryController.clear();
    });

    if (!mounted) return;

    // Show AI Chat Option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Journal entry saved!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4), // Limited to 4 seconds as requested
        action: SnackBarAction(
          label: 'Chat about this',
          onPressed: () {
            // Mock AI chat navigation
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening AI Chat... (Feature coming soon)')),
              );
          },
        ),
      ),
    );
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _AppearanceSettings(
        currentTheme: _currentTheme,
        themes: _themes,
        onThemeChanged: (theme) => setState(() => _currentTheme = theme),
        currentFontName: _getFontName(_currentFont),
        fontNames: _fontNames,
        onFontChanged: (fontName) => setState(() => _currentFont = GoogleFonts.getFont(fontName)),
      ),
    );
  }
  
  Future<void> _toggleAiMode(bool value) async {
    if (value) {
      // Show Tone Selection
      final selectedTone = await showDialog<AiTone>(
        context: context,
        builder: (context) => const _ToneSelectionDialog(),
      );

      if (selectedTone != null) {
        setState(() {
          _aiEnabled = true;
          _selectedTone = selectedTone;
          _showChatInterface = true;
          _chatMessages = [
            ChatMessage(
              text: "Hello! I'm here to listen. How are you feeling today?", 
              isUser: false, 
              timestamp: DateTime.now()
            )
          ];
        });
      }
    } else {
      setState(() {
        _aiEnabled = false;
        _showChatInterface = false;
        _selectedTone = null;
        _chatMessages.clear();
      });
    }
  }

  void _handleChatSend(String text) {
    setState(() {
      _chatMessages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    });

    // Mock AI Response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _chatMessages.add(ChatMessage(
            text: "That sounds interesting. Tell me more about it.",
            isUser: false, 
            timestamp: DateTime.now()
          ));
        });
      }
    });
  }

  String _getFontName(TextStyle style) {
    // Helper to find font name from list based on style equality 
    // Simplified: just check fontFamily or keep track of name separately
    // Since GoogleFonts.getFont returns text style with fontFamily, we can check that, 
    // but names in list are "Lato", actual family might be "Lato_regular".
    // For simplicity, we'll iterate and check startsWith or use a parallel selection state index.
    // Let's rely on the user selection for now.
    return _fontNames.firstWhere((name) => GoogleFonts.getFont(name).fontFamily == style.fontFamily, orElse: () => 'Lato');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      body: Stack(
        children: [
          // Background Layer: Blurred and Scaling to Cover
          if (_currentTheme.backgroundPath.isNotEmpty)
            Positioned.fill(
              child: Image.asset(
                _currentTheme.backgroundPath,
                fit: BoxFit.cover,
              ),
            ),
          if (_currentTheme.backgroundPath.isNotEmpty)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.2), // Dim for text legibility
                ),
              ),
            ),

          // Middle Layer: Image fitted vertically - Centered (REMOVED as per user request)
          // if (_currentTheme.backgroundPath.isNotEmpty)
          //   Positioned.fill(
          //     child: Center(
          //       child: Image.asset(
          //         _currentTheme.backgroundPath,
          //         fit: BoxFit.fitHeight,
          //       ),
          //     ),
          //   ),
          
          // Foreground: Content
           SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                       final inAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation);
                       final outAnimation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(animation);
                       
                       if (child.key == const ValueKey('chat')) {
                         return SlideTransition(position: inAnimation, child: child);
                       } else {
                         return SlideTransition(position: outAnimation, child: child);
                       }
                    },
                    child: _showChatInterface
                        ? _ChatInterface(
                            key: const ValueKey('chat'),
                            messages: _chatMessages,
                            onSend: _handleChatSend,
                            onBack: () => _toggleAiMode(false),
                            tone: _selectedTone ?? AiTone.casual,
                            fontStyle: _currentFont,
                          )
                        : SingleChildScrollView(
                            key: const ValueKey('journal'),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _TodayEntryCard(
                                  date: _todayFormatted,
                                  entryMode: _entryMode,
                                  onModeChanged: (mode) => setState(() => _entryMode = mode),
                                  entryController: _entryController,
                                  entryFocus: _entryFocus,
                                  wordCount: _wordCount,
                                  isRecording: _isRecording,
                                  onToggleRecording: () => setState(() => _isRecording = !_isRecording),
                                  onSave: _saveEntry,
                                  isSaving: _isSaving,
                                  fontStyle: _currentFont,
                                ),
                                const SizedBox(height: 24),
                                _AiAssistantCard(
                                  aiEnabled: _aiEnabled,
                                  onToggle: _toggleAiMode, // Updated callback
                                  selectedTone: _selectedTone,
                                  onToneSelected: (tone) => setState(() => _selectedTone = tone),
                                   fontStyle: _currentFont,
                                ),
                                const SizedBox(height: 24),
                                _PastEntriesSection(
                                  entries: _pastEntries,
                                   fontStyle: _currentFont,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      // No background for header to show theme, or translucent
       decoration: BoxDecoration(
        color: _currentTheme.backgroundPath.isEmpty 
            ? AppColors.cardBackground 
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.chevron_left, size: 28),
              ),
              const SizedBox(width: 8),
              Text(
                'Journal',
                style: _currentFont.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.palette_outlined, size: 24),
            tooltip: 'Customize Appearance',
          ),
        ],
      ),
    );
  }
}

class _TodayEntryCard extends StatelessWidget {
  final String date;
  final EntryMode entryMode;
  final ValueChanged<EntryMode> onModeChanged;
  final TextEditingController entryController;
  final FocusNode entryFocus;
  final int wordCount;
  final bool isRecording;
  final VoidCallback onToggleRecording;
  final VoidCallback onSave;
  final bool isSaving;
  final TextStyle fontStyle;

  const _TodayEntryCard({
    required this.date,
    required this.entryMode,
    required this.onModeChanged,
    required this.entryController,
    required this.entryFocus,
    required this.wordCount,
    required this.isRecording,
    required this.onToggleRecording,
    required this.onSave,
    required this.isSaving,
    required this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85), // Translucent
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: const [AppShadows.card],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: fontStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                // Mode toggle could be here
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: entryController,
              focusNode: entryFocus,
              style: fontStyle.copyWith(fontSize: 16),
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?...',
                hintStyle: fontStyle.copyWith(color: AppColors.textSecondary),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$wordCount words', style: fontStyle.copyWith(fontSize: 12, color: AppColors.textSecondary)),
                ElevatedButton.icon(
                  onPressed: onSave,
                  icon: isSaving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,))
                      : const Icon(Icons.check, size: 18),
                  label: Text(isSaving ? 'Saving...' : 'Save', style: fontStyle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PastEntriesSection extends StatelessWidget {
  final List<JournalEntry> entries;
  final TextStyle fontStyle;

  const _PastEntriesSection({required this.entries, required this.fontStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Entries',
          style: fontStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white, shadows: [Shadow(blurRadius: 2, color: Colors.black54)]),
        ),
        const SizedBox(height: 16),
        if (entries.isEmpty)
           Center(child: Text('No past entries yet.', style: fontStyle.copyWith(color: Colors.white70)))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];

              // Find matching mood object for image
              final moodObj = Mood.all.firstWhere(
                (m) => m.emoji == entry.mood,
                orElse: () => Mood.all[3], // Default to neutral if not found
              );

              return Card(
                color: Colors.white.withValues(alpha: 0.9),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           // Content
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   DateFormat.yMMMd().format(entry.date), 
                                   style: fontStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey[600])
                                 ),
                                 const SizedBox(height: 4),
                                 Text(entry.preview, style: fontStyle.copyWith(fontSize: 16)),
                               ],
                             ),
                           ),
                           // Mood Image
                           const SizedBox(width: 8),
                           Container(
                             width: 50,
                             height: 50,
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               boxShadow: [
                                 BoxShadow(
                                   color: moodObj.baseColor.withValues(alpha: 0.3),
                                   blurRadius: 8,
                                   offset: const Offset(0, 2),
                                 )
                               ]
                             ),
                             child: Image.asset(moodObj.imagePath),
                           ),
                         ],
                       ),
                       if (entry.tags.isNotEmpty) ...[
                         const SizedBox(height: 12),
                         Wrap(
                           spacing: 8,
                           children: entry.tags.map((tag) => Container(
                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                             decoration: BoxDecoration(
                               color: moodObj.baseColor.withValues(alpha: 0.2), // Darker shade background
                               borderRadius: BorderRadius.circular(12),
                               border: Border.all(color: moodObj.baseColor.withValues(alpha: 0.5)),
                             ),
                             child: Text(
                               tag,
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w600,
                                 color: moodObj.baseColor, // Colored text
                               ),
                             ),
                           )).toList(),
                         ),
                       ],
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class MoodFeedbackResult {
  final Mood mood;
  final List<String> tags;

  MoodFeedbackResult(this.mood, this.tags);
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class _MoodFeedbackDialog extends StatefulWidget {
  const _MoodFeedbackDialog();

  @override
  State<_MoodFeedbackDialog> createState() => _MoodFeedbackDialogState();
}

class _MoodFeedbackDialogState extends State<_MoodFeedbackDialog> {
  Mood? _selectedMood;
  List<String> _selectedTags = [];
  List<String> _availableTags = [];
  final TextEditingController _customTagController = TextEditingController();
  final MoodTagService _tagService = MoodTagService();
  bool _isLoadingTags = false;

  void _onMoodSelected(Mood mood) async {
    setState(() {
      _selectedMood = mood;
      _isLoadingTags = true;
      _selectedTags = [];
    });
    
    // Fetch tags
    final tags = await _tagService.getTagsForMood(mood.label);
    if (mounted) {
      setState(() {
        _availableTags = tags;
        _isLoadingTags = false;
      });
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _addCustomTag() {
    if (_customTagController.text.trim().isNotEmpty) {
       final newTag = _customTagController.text.trim();
       _tagService.addCustomTag(_selectedMood!.label, newTag);
       setState(() {
         if (!_availableTags.contains(newTag)) {
            _availableTags.insert(0, newTag); // Add to top
         }
         if (!_selectedTags.contains(newTag)) {
           _selectedTags.add(newTag); // Auto select added tag
         }
         _customTagController.clear();
       });
    }
  }

  @override
  void dispose() {
    _customTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
       child: AnimatedContainer(
         duration: const Duration(milliseconds: 300),
         padding: const EdgeInsets.all(24),
         width: 500, // Fixed width for better layout on desktop
         constraints: const BoxConstraints(maxWidth: 600, minHeight: 400),
         child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                 _selectedMood == null ? 'How are you feeling?' : 'What best describes this feeling?',
                 style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 24),
               Flexible(
                 child: _selectedMood == null 
                   ? _buildMoodGrid()
                   : _buildTagSelection(),
               ),
            ],
         ),
       ),
    );
  }
  
  Widget _buildMoodGrid() {
    return GridView.builder(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(), // Fit in dialog
       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.85,
       ),
       itemCount: Mood.all.length,
       itemBuilder: (context, index) {
          final mood = Mood.all[index];
          return GestureDetector(
             onTap: () => _onMoodSelected(mood),
             child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Expanded(
                     child: Container(
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         boxShadow: [
                           BoxShadow(
                             color: mood.baseColor.withValues(alpha: 0.3),
                             blurRadius: 12,
                             offset: const Offset(0, 4),
                           )
                         ]
                       ),
                       child: Image.asset(mood.imagePath),
                     ),
                   ),
                   const SizedBox(height: 12),
                   Text(
                     mood.label, 
                     style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 16)
                   ),
                ],
             ),
          );
       },
    );
  }

  Widget _buildTagSelection() {
     if (_isLoadingTags) {
       return const Center(child: CircularProgressIndicator());
     }
     
     return Column(
       mainAxisSize: MainAxisSize.min,
       children: [
         // Selected Mood Display (Small)
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Image.asset(_selectedMood!.imagePath, width: 40, height: 40),
             const SizedBox(width: 12),
             Text(
               _selectedMood!.label,
               style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: _selectedMood!.baseColor),
             ),
             const Spacer(),
             TextButton(
               onPressed: () => setState(() => _selectedMood = null),
               child: const Text('Change'),
             ),
           ],
         ),
         const Divider(height: 32),
         
         // Tags
         Flexible(
           child: SingleChildScrollView(
             child: Wrap(
               spacing: 8,
               runSpacing: 8,
               children: [
                 ..._availableTags.map((tag) {
                   final isSelected = _selectedTags.contains(tag);
                   return FilterChip(
                     label: Text(tag),
                     selected: isSelected,
                     onSelected: (_) => _toggleTag(tag),
                     selectedColor: _selectedMood!.baseColor.withValues(alpha: 0.2),
                     checkmarkColor: _selectedMood!.baseColor,
                     labelStyle: TextStyle(
                       color: isSelected ? _selectedMood!.baseColor : Colors.black87,
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                     ),
                     backgroundColor: Colors.grey[100],
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20),
                       side: BorderSide(
                         color: isSelected ? _selectedMood!.baseColor : Colors.transparent,
                       ),
                     ),
                   );
                 }),
                 ActionChip(
                   avatar: const Icon(Icons.add, size: 18),
                   label: const Text('Add Tag'),
                   onPressed: () {
                     showDialog(
                       context: context,
                       builder: (context) => AlertDialog(
                         title: const Text('Add Custom Tag'),
                         content: TextField(
                           controller: _customTagController,
                           autofocus: true,
                           decoration: const InputDecoration(hintText: 'e.g., Hopeful'),
                           onSubmitted: (_) {
                             _addCustomTag();
                             Navigator.pop(context);
                           },
                         ),
                         actions: [
                           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                           TextButton(
                             onPressed: () {
                               _addCustomTag();
                               Navigator.pop(context);
                             },
                             child: const Text('Add'),
                           ),
                         ],
                       ),
                     );
                   },
                 ),
               ],
             ),
           ),
         ),
         
         const SizedBox(height: 24),
         
         // Done Button
         SizedBox(
           width: double.infinity,
           child: ElevatedButton(
             onPressed: () {
               Navigator.pop(
                 context, 
                 MoodFeedbackResult(_selectedMood!, _selectedTags),
               );
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: AppColors.primary, // Using primary color
               foregroundColor: Colors.white,
               padding: const EdgeInsets.symmetric(vertical: 16),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               elevation: 4,
             ),
             child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
           ),
         ),
       ],
     );
  }
}

class _AppearanceSettings extends StatelessWidget {
  final JournalTheme currentTheme;
  final List<JournalTheme> themes;
  final ValueChanged<JournalTheme> onThemeChanged;
  final String currentFontName;
  final List<String> fontNames;
  final ValueChanged<String> onFontChanged;

  const _AppearanceSettings({
    required this.currentTheme,
    required this.themes,
    required this.onThemeChanged,
    required this.currentFontName,
    required this.fontNames,
    required this.onFontChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Themes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: themes.length,
              itemBuilder: (context, index) {
                final theme = themes[index];
                return GestureDetector(
                  onTap: () => onThemeChanged(theme),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: currentTheme.name == theme.name ? Border.all(color: AppColors.primary, width: 2) : null,
                      borderRadius: BorderRadius.circular(12),
                      image: theme.backgroundPath.isNotEmpty
                          ? DecorationImage(image: AssetImage(theme.backgroundPath), fit: BoxFit.cover)
                          : null,
                      color: theme.backgroundPath.isEmpty ? Colors.grey[200] : null,
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.black54,
                        child: Text(
                          theme.name,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text('Fonts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: fontNames.length,
              itemBuilder: (context, index) {
                final font = fontNames[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(font, style: GoogleFonts.getFont(font)),
                    selected: false,
                    onSelected: (selected) => onFontChanged(font),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AiAssistantCard extends StatelessWidget {
  final bool aiEnabled;
  final ValueChanged<bool> onToggle;
  final AiTone? selectedTone;
  final ValueChanged<AiTone?> onToneSelected;
  final TextStyle fontStyle;

  const _AiAssistantCard({
    required this.aiEnabled,
    required this.onToggle,
    this.selectedTone,
    required this.onToneSelected,
    required this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: const [AppShadows.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🤖', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Assistant',
                  style: fontStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Switch(
                value: aiEnabled,
                onChanged: onToggle,
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToneSelectionDialog extends StatelessWidget {
  const _ToneSelectionDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose AI Tone',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...AiTone.values.map((tone) => ListTile(
              title: Text(tone.toString().split('.').last.capitalize()),
              leading: const Icon(Icons.record_voice_over_outlined),
              onTap: () => Navigator.pop(context, tone),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              hoverColor: Colors.grey[100],
            )),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class _ChatInterface extends StatefulWidget {
  final List<ChatMessage> messages;
  final ValueChanged<String> onSend;
  final VoidCallback onBack;
  final AiTone tone;
  final TextStyle fontStyle;

  const _ChatInterface({
    super.key,
    required this.messages,
    required this.onSend,
    required this.onBack,
    required this.tone,
    required this.fontStyle,
  });

  @override
  State<_ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<_ChatInterface> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;
    widget.onSend(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [AppShadows.card],
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack, 
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text('AI', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: widget.fontStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      widget.tone.toString().split('.').last.capitalize(),
                      style: widget.fontStyle.copyWith(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!msg.isUser) ...[
                        const CircleAvatar(radius: 12, backgroundColor: AppColors.primary, child: Icon(Icons.smart_toy, size: 14, color: Colors.white)),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: msg.isUser ? AppColors.primary : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                              bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                            ),
                          ),
                          child: Text(
                            msg.text,
                            style: widget.fontStyle.copyWith(
                              color: msg.isUser ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      if (msg.isUser) ...[
                        const SizedBox(width: 8),
                        const CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 14, color: Colors.white)),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                   onPressed: _handleSend,
                   icon: const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
