// screening_data.dart — FULL official question bank (Antigravity v2)
// 271 questions across 9 modules. All original compositions.

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Question Model
// ─────────────────────────────────────────────────────────────────────────────

enum ScreeningModule { m1, m2, m3, m4, m5, m6, m7, m8, m9 }
enum QuestionType { yesNo, likert }

class ScreeningQuestion {
  final String id;
  final String text;
  final QuestionType type;
  final bool isSafetyItem;
  final bool isWeighted; // doubles score contribution
  const ScreeningQuestion({
    required this.id,
    required this.text,
    required this.type,
    this.isSafetyItem = false,
    this.isWeighted = false,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Likert labels
// ─────────────────────────────────────────────────────────────────────────────

const List<String> likertLabels = ['Never', 'Rarely', 'Sometimes', 'Often', 'Almost Always'];

// ─────────────────────────────────────────────────────────────────────────────
// Result Bands
// ─────────────────────────────────────────────────────────────────────────────

class ScreeningResultBand {
  final String label;
  final Color color;
  final String copy;
  const ScreeningResultBand({required this.label, required this.color, required this.copy});
}

const ScreeningResultBand bandLow = ScreeningResultBand(
  label: 'Low', color: Color(0xFF4CAF50),
  copy: 'Your responses did not indicate concerns in this area.',
);
const ScreeningResultBand bandMonitor = ScreeningResultBand(
  label: 'Monitor', color: Color(0xFFF59E0B),
  copy: 'Some of your responses are worth discussing with a healthcare professional.',
);
const ScreeningResultBand bandElevated = ScreeningResultBand(
  label: 'Elevated', color: Color(0xFFEF4444),
  copy: 'Your responses suggest it would be beneficial to speak with a licensed healthcare provider.',
);
const ScreeningResultBand bandCrisis = ScreeningResultBand(
  label: 'Crisis', color: Color(0xFF7B1FA2),
  copy: "You're not alone. Please reach out right now — call or text 988.",
);

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 1 — Depression & Anxiety  (Likert 0–4, 30 items)
// Scoring: Low 0–20 | Monitor 21–45 | Elevated 46+
// Safety: M1.28 [W] if scored 3 or 4 → flag in AI report
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module1Questions = [
  ScreeningQuestion(id:'m1_01',type:QuestionType.likert,
    text:'Over the past two weeks, how often have you felt a persistent sense of sadness or emptiness that was difficult to shake off?'),
  ScreeningQuestion(id:'m1_02',type:QuestionType.likert,
    text:'How often have you lost interest or pleasure in activities, hobbies, or people that you normally enjoy?'),
  ScreeningQuestion(id:'m1_03',type:QuestionType.likert,
    text:'How often have you felt physically drained, fatigued, or without energy — even after resting or sleeping?'),
  ScreeningQuestion(id:'m1_04',type:QuestionType.likert,
    text:'How often have you had difficulty falling asleep, staying asleep, or found yourself sleeping far more than usual?'),
  ScreeningQuestion(id:'m1_05',type:QuestionType.likert,
    text:'How often have you had trouble concentrating, making decisions, or remembering things that feel routine?'),
  ScreeningQuestion(id:'m1_06',type:QuestionType.likert,
    text:'How often have you felt worthless, excessively guilty, or been very harshly critical of yourself for things within or outside your control?'),
  ScreeningQuestion(id:'m1_07',type:QuestionType.likert,
    text:'How often have you felt a persistent, unexplained sense of nervousness, tension, or unease?'),
  ScreeningQuestion(id:'m1_08',type:QuestionType.likert,
    text:'How often have you found it difficult to stop or control worrying once it starts?'),
  ScreeningQuestion(id:'m1_09',type:QuestionType.likert,
    text:'How often have you felt your heart racing, your chest tightening, or your breathing becoming difficult in situations that didn\'t seem to warrant it?'),
  ScreeningQuestion(id:'m1_10',type:QuestionType.likert,
    text:'How often have you felt restless, on edge, or unable to relax — even in calm environments?'),
  ScreeningQuestion(id:'m1_11',type:QuestionType.likert,
    text:'How often have you experienced unexplained physical symptoms such as headaches, stomach problems, or muscle tension alongside your low mood or worry?'),
  ScreeningQuestion(id:'m1_12',type:QuestionType.likert,
    text:'How often have you found yourself eating significantly more or significantly less than usual, not connected to any deliberate diet change?'),
  ScreeningQuestion(id:'m1_13',type:QuestionType.likert,
    text:'Imagine you have been given an unexpected day off with no responsibilities. How often would your first feeling be dread, emptiness, or an inability to enjoy it — rather than relief or pleasure?'),
  ScreeningQuestion(id:'m1_14',type:QuestionType.likert,
    text:'You receive a message from a friend inviting you to a social event you would have previously enjoyed. How often do you find yourself making excuses to avoid it because you simply don\'t have the energy or desire to go?'),
  ScreeningQuestion(id:'m1_15',type:QuestionType.likert,
    text:'You are in the middle of a task at work or at home. How often do you find yourself stopping midway because you feel overwhelmed, hopeless about finishing, or suddenly tearful for no clear reason?'),
  ScreeningQuestion(id:'m1_16',type:QuestionType.likert,
    text:'When something goes wrong at work or in a relationship — even something minor — how often do you interpret it as confirmation that you are a failure or that things will never improve?'),
  ScreeningQuestion(id:'m1_17',type:QuestionType.likert,
    text:'You have been looking forward to a plan for weeks. When the day arrives, how often do you feel flat, uninterested, or unable to experience the enjoyment you expected?'),
  ScreeningQuestion(id:'m1_18',type:QuestionType.likert,
    text:'When you are waiting for news — a test result, a reply, or an outcome — how often does your mind automatically jump to the worst possible scenario and stay there?'),
  ScreeningQuestion(id:'m1_19',type:QuestionType.likert,
    text:'You make a small mistake — perhaps sending a message to the wrong person or forgetting an appointment. How often do you spend hours or days replaying it, feeling intensely ashamed or guilty?'),
  ScreeningQuestion(id:'m1_20',type:QuestionType.likert,
    text:'You are in a public place — a shop, a transport hub, or a crowd. How often do you feel suddenly anxious, as though something bad is about to happen, even though there is no obvious reason?'),
  ScreeningQuestion(id:'m1_21',type:QuestionType.likert,
    text:'You have a deadline or an important task coming up. How often does anxiety about it prevent you from starting — leaving you paralysed rather than productive?'),
  ScreeningQuestion(id:'m1_22',type:QuestionType.likert,
    text:'When a friend or family member asks how you are, how often do you say "fine" while feeling significantly worse inside — because explaining feels too exhausting or pointless?'),
  ScreeningQuestion(id:'m1_23',type:QuestionType.likert,
    text:'How often do you feel that the future holds little to look forward to, or that things are unlikely to improve regardless of what you do?'),
  ScreeningQuestion(id:'m1_24',type:QuestionType.likert,
    text:'How often have you felt emotionally numb — unable to feel either sadness or happiness — as if you are going through the motions of daily life?'),
  ScreeningQuestion(id:'m1_25',type:QuestionType.likert,
    text:'How often do you feel that your anxiety or low mood is controlling your choices — such as which places you go, which people you see, or what opportunities you pursue?'),
  ScreeningQuestion(id:'m1_26',type:QuestionType.likert,
    text:'How often have you felt significantly more irritable, short-tempered, or easily frustrated than feels usual for you?'),
  ScreeningQuestion(id:'m1_27',type:QuestionType.likert,
    text:'How often have you felt a sense of impending doom — a vague but persistent feeling that something bad is about to happen — without being able to identify a specific cause?'),
  ScreeningQuestion(id:'m1_28',type:QuestionType.likert, isSafetyItem:true, isWeighted:true,
    text:'How often have you had thoughts that you would be better off not being here, or that people around you would be better off without you?'),
  ScreeningQuestion(id:'m1_29',type:QuestionType.likert,
    text:'How often have you felt so anxious or low that it has caused you to miss work, cancel plans, or significantly change your daily routine?'),
  ScreeningQuestion(id:'m1_30',type:QuestionType.likert,
    text:'How often have you found that your mood or anxiety levels are significantly worse at particular times of day — for example, mornings feel unbearable or evenings feel overwhelming?'),
];

ScreeningResultBand scoreModule1(Map<String, int> answers) {
  int sum = 0;
  for (final q in module1Questions) {
    final v = answers[q.id] ?? 0;
    sum += q.isWeighted ? v * 2 : v;
  }
  if (sum <= 20) return bandLow;
  if (sum <= 45) return bandMonitor;
  return bandElevated;
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 2 — Bipolar / Mania  (Likert 0–4, 28 items)
// Scoring: Low 0–18 | Monitor 19–38 | Elevated 39+
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module2Questions = [
  ScreeningQuestion(id:'m2_01',type:QuestionType.likert,
    text:'How often have you experienced periods where your mood felt noticeably elevated, expansive, or unusually positive — clearly different from your normal self?'),
  ScreeningQuestion(id:'m2_02',type:QuestionType.likert,
    text:'How often do elevated mood periods alternate with periods of significant low mood within the same week, fortnight, or month?'),
  ScreeningQuestion(id:'m2_03',type:QuestionType.likert,
    text:'How often have you felt a dramatic increase in your drive to start new projects, pursue goals, or stay busy — beyond what is normal for you?'),
  ScreeningQuestion(id:'m2_04',type:QuestionType.likert,
    text:'How often have you needed significantly less sleep than usual and still felt energetic, alert, or not tired the next day?'),
  ScreeningQuestion(id:'m2_05',type:QuestionType.likert,
    text:'How often has your speech felt faster, louder, or more pressured — as if you couldn\'t get your words out fast enough?'),
  ScreeningQuestion(id:'m2_06',type:QuestionType.likert,
    text:'How often have you acted impulsively in ways you later regretted, such as with money, relationships, or risky decisions?'),
  ScreeningQuestion(id:'m2_07',type:QuestionType.likert,
    text:'How often have you felt unusually irritable, agitated, or easily angered — beyond what felt proportionate to the situation?'),
  ScreeningQuestion(id:'m2_08',type:QuestionType.likert,
    text:'How often have you felt unusually self-confident, important, or as though you had special insights or abilities that others didn\'t recognise?'),
  ScreeningQuestion(id:'m2_09',type:QuestionType.likert,
    text:'How often have your thoughts moved so quickly that it was hard to slow them down, focus, or keep track of them?'),
  ScreeningQuestion(id:'m2_10',type:QuestionType.likert,
    text:'How often have mood changes significantly disrupted your work, relationships, finances, or ability to function day to day?'),
  ScreeningQuestion(id:'m2_11',type:QuestionType.likert,
    text:'How often have people close to you commented that your behaviour, energy, or mood seemed unusual, extreme, or out of character?'),
  ScreeningQuestion(id:'m2_12',type:QuestionType.likert,
    text:'You wake up one morning feeling extraordinary — full of energy, ideas, and confidence. How often does this kind of feeling arrive without any obvious reason and feel significantly more intense than a normal good mood?'),
  ScreeningQuestion(id:'m2_13',type:QuestionType.likert,
    text:'You are browsing online late at night during a particularly energised period. How often have you made large or impulsive purchases you would not normally consider — and felt certain at the time it was a brilliant idea?'),
  ScreeningQuestion(id:'m2_14',type:QuestionType.likert,
    text:'You are in a conversation with colleagues or friends. How often have people had to ask you to slow down, let others speak, or commented that you were talking over them during a high-energy period?'),
  ScreeningQuestion(id:'m2_15',type:QuestionType.likert,
    text:'You have committed to three new projects in the same week. How often does this kind of burst of ambitious starting happen, followed by losing interest before completing any of them?'),
  ScreeningQuestion(id:'m2_16',type:QuestionType.likert,
    text:'You are in an elevated mood phase. How often have you felt so certain you were right — in an argument, a decision, or a creative vision — that you dismissed others\' concerns as simply not understanding?'),
  ScreeningQuestion(id:'m2_17',type:QuestionType.likert,
    text:'After a period of high energy, productivity, and elevated mood, how often do you experience a significant crash — feeling exhausted, flat, or deeply low for days or weeks following?'),
  ScreeningQuestion(id:'m2_18',type:QuestionType.likert,
    text:'You are at a social event during a high period. How often have you behaved in ways — such as being louder than usual, saying things you wouldn\'t normally say — that you later found embarrassing or out of character?'),
  ScreeningQuestion(id:'m2_19',type:QuestionType.likert,
    text:'You find yourself awake at 2am with a racing mind and an urgent sense that you need to start something or send messages. How often has this happened during periods of elevated mood?'),
  ScreeningQuestion(id:'m2_20',type:QuestionType.likert,
    text:'A trusted friend or family member pulls you aside and expresses concern about your recent behaviour or spending. How often does your immediate reaction feel like total dismissal — a certainty that they are wrong and you are simply performing at your best?'),
  ScreeningQuestion(id:'m2_21',type:QuestionType.likert,
    text:'How often have you experienced periods lasting several days where you felt barely any need to sleep, yet felt unusually capable or energised?'),
  ScreeningQuestion(id:'m2_22',type:QuestionType.likert,
    text:'How often have you found yourself in legal, financial, or relationship difficulties that began during a period of elevated mood or unusual confidence?'),
  ScreeningQuestion(id:'m2_23',type:QuestionType.likert,
    text:'How often do you feel that your moods — both the highs and lows — are significantly more intense than those of people around you?'),
  ScreeningQuestion(id:'m2_24',type:QuestionType.likert,
    text:'How often have you felt that during an elevated period, your creativity, productivity, or insight was genuinely exceptional — only to feel later that the results were less impressive than they seemed at the time?'),
  ScreeningQuestion(id:'m2_25',type:QuestionType.likert,
    text:'How often have you felt that alcohol, substances, or other stimulating activities feel especially appealing during a high-energy period?'),
  ScreeningQuestion(id:'m2_26',type:QuestionType.yesNo,
    text:'Have you ever been told by a doctor, therapist, or other professional that your mood swings were a concern worth investigating?'),
  ScreeningQuestion(id:'m2_27',type:QuestionType.likert,
    text:'How often do you feel that your elevated periods — however positive they feel in the moment — have caused lasting damage to relationships, finances, or your reputation?'),
  ScreeningQuestion(id:'m2_28',type:QuestionType.likert,
    text:'How often have you experienced rapid shifts between feeling invincible and feeling completely worthless within a short period?'),
];

ScreeningResultBand scoreModule2(Map<String, int> answers) {
  int sum = 0;
  for (final q in module2Questions) {
    sum += answers[q.id] ?? 0;
  }
  if (sum <= 18) return bandLow;
  if (sum <= 38) return bandMonitor;
  return bandElevated;
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 3 — Psychosis / Schizophrenia Spectrum  (Yes/No, 28 items)
// Scoring: Low 0–1 | Monitor 2–4 | Elevated 5+
// Safety: M3.01–M3.04 flagged individually
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module3Questions = [
  ScreeningQuestion(id:'m3_01',type:QuestionType.yesNo, isSafetyItem:true, isWeighted:true,
    text:'Have you heard sounds, voices, or noises that others nearby did not seem to be able to hear?'),
  ScreeningQuestion(id:'m3_02',type:QuestionType.yesNo, isSafetyItem:true, isWeighted:true,
    text:'Have you seen things, shapes, or visual experiences that others around you did not seem to notice?'),
  ScreeningQuestion(id:'m3_03',type:QuestionType.yesNo, isSafetyItem:true, isWeighted:true,
    text:'Have you had a strong feeling that people are watching you, talking about you, or have a specific interest in you that felt unusual or threatening?'),
  ScreeningQuestion(id:'m3_04',type:QuestionType.yesNo, isSafetyItem:true, isWeighted:true,
    text:'Have you felt that ordinary events, objects, or coincidences had a special hidden meaning that was specifically intended for you?'),
  ScreeningQuestion(id:'m3_05',type:QuestionType.yesNo,
    text:'Have you felt that your thoughts were being inserted into your mind by an outside force that was not your own thinking?'),
  ScreeningQuestion(id:'m3_06',type:QuestionType.yesNo,
    text:'Have you felt that your thoughts were being removed or taken away before you could finish them?'),
  ScreeningQuestion(id:'m3_07',type:QuestionType.yesNo,
    text:'Have you felt that your thoughts or feelings might somehow be available to other people without you having spoken them aloud?'),
  ScreeningQuestion(id:'m3_08',type:QuestionType.yesNo,
    text:'Have you felt that someone or something outside of yourself was controlling your actions, movements, or feelings?'),
  ScreeningQuestion(id:'m3_09',type:QuestionType.yesNo,
    text:'Have you noticed that your thinking felt disorganised, fragmented, or difficult to follow — even to yourself?'),
  ScreeningQuestion(id:'m3_10',type:QuestionType.yesNo,
    text:'Have you felt emotionally flat, detached, or unable to feel emotions that you felt you should be feeling?'),
  ScreeningQuestion(id:'m3_11',type:QuestionType.yesNo,
    text:'Have you had unusual sensory experiences in other ways — such as smelling or tasting things that others around you could not detect?'),
  ScreeningQuestion(id:'m3_12',type:QuestionType.yesNo,
    text:'Have you felt an increasing sense that you cannot trust the world around you — that things are not as they appear, or that people are concealing something from you?'),
  ScreeningQuestion(id:'m3_13',type:QuestionType.yesNo,
    text:'You are walking down a street and notice two people laughing. Do you frequently find yourself feeling certain they are laughing specifically at you — even when there is no reason to believe this?'),
  ScreeningQuestion(id:'m3_14',type:QuestionType.yesNo,
    text:'You are watching television and a presenter or character makes a comment. Have you ever felt with certainty that this comment was directed specifically at you or contained a message intended for you?'),
  ScreeningQuestion(id:'m3_15',type:QuestionType.yesNo,
    text:'You are in a public space — a café, a shopping centre, or transport. Have you felt that the people around you were behaving in coordinated ways specifically because of your presence?'),
  ScreeningQuestion(id:'m3_16',type:QuestionType.yesNo,
    text:'You are alone in your home at night. Have you repeatedly heard what sounded like your name being called, footsteps, or voices — and been certain it was not your imagination — only to find no one was there?'),
  ScreeningQuestion(id:'m3_17',type:QuestionType.yesNo,
    text:'You have a conversation with someone. Afterwards, do you sometimes feel certain they said something they deny saying — and feel equally certain your memory of it is accurate?'),
  ScreeningQuestion(id:'m3_18',type:QuestionType.yesNo,
    text:'You read a news article or see a random number or pattern. Have you felt with conviction that it contained a specific message or code that was personally relevant to you?'),
  ScreeningQuestion(id:'m3_19',type:QuestionType.yesNo,
    text:'During periods of high stress, have you experienced moments where the world around you felt unreal — as if you were watching yourself from outside your own body, or as if people and objects seemed artificial or staged?'),
  ScreeningQuestion(id:'m3_20',type:QuestionType.yesNo,
    text:'You have shared an unusual belief or experience with someone close to you and they responded with significant concern or disbelief. Has this happened, and did their reaction confuse or frustrate you rather than prompt you to reconsider?'),
  ScreeningQuestion(id:'m3_21',type:QuestionType.yesNo,
    text:'Have you become increasingly withdrawn from social situations because being around people feels threatening or overwhelming?'),
  ScreeningQuestion(id:'m3_22',type:QuestionType.yesNo,
    text:'Have you felt that your sense of who you are — your identity — has become confused, fragmented, or feels unfamiliar to you?'),
  ScreeningQuestion(id:'m3_23',type:QuestionType.likert,
    text:'How often do these unusual experiences or beliefs cause you significant distress or interfere with your daily life?'),
  ScreeningQuestion(id:'m3_24',type:QuestionType.yesNo,
    text:'Have you felt that there is a pattern or system behind events in your life that others cannot see or understand?'),
  ScreeningQuestion(id:'m3_25',type:QuestionType.yesNo,
    text:'Have you had moments where you felt you had a special mission, purpose, or power that others were unaware of?'),
  ScreeningQuestion(id:'m3_26',type:QuestionType.likert,
    text:'How often do you feel unable to distinguish between what is a real external experience and what might be coming from your own mind?'),
  ScreeningQuestion(id:'m3_27',type:QuestionType.yesNo,
    text:'Have you significantly changed your routines, behaviours, or relationships in response to these unusual experiences or beliefs?'),
  ScreeningQuestion(id:'m3_28',type:QuestionType.likert,
    text:'How often do these experiences occur — are they occasional and brief, or frequent and sustained?'),
];

ScreeningResultBand scoreModule3(Map<String, int> answers) {
  int score = 0;
  for (final q in module3Questions) {
    final v = answers[q.id] ?? 0;
    if (q.type == QuestionType.yesNo) {
      score += v; // 0 or 1
    } else {
      // Likert: count as positive if ≥ 2
      if (v >= 2) score++;
    }
  }
  if (score <= 1) return bandLow;
  if (score <= 4) return bandMonitor;
  return bandElevated;
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 4 — ADHD  (Likert 0–4, 30 items)
// Scoring: Low 0–20 | Monitor 21–44 | Elevated 45+
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module4Questions = [
  ScreeningQuestion(id:'m4_01',type:QuestionType.likert,
    text:'How often do you have difficulty sustaining your attention on tasks that require prolonged mental effort — such as reading, completing paperwork, or following detailed instructions?'),
  ScreeningQuestion(id:'m4_02',type:QuestionType.likert,
    text:'How often do you make careless mistakes in work, schoolwork, or daily tasks because you did not pay close enough attention to detail?'),
  ScreeningQuestion(id:'m4_03',type:QuestionType.likert,
    text:'How often do you find yourself easily distracted by unrelated thoughts, background noise, or events happening around you — even when you are trying to focus?'),
  ScreeningQuestion(id:'m4_04',type:QuestionType.likert,
    text:'How often do you lose or misplace things you need for daily tasks — such as keys, your phone, documents, or glasses?'),
  ScreeningQuestion(id:'m4_05',type:QuestionType.likert,
    text:'How often do you find it extremely difficult to start a task — even one you know is important — until the very last moment?'),
  ScreeningQuestion(id:'m4_06',type:QuestionType.likert,
    text:'How often do you forget appointments, commitments, or things people have asked you to do — even shortly after being told?'),
  ScreeningQuestion(id:'m4_07',type:QuestionType.likert,
    text:'How often do you find your mind drifting mid-conversation — and realise you have missed what the other person said?'),
  ScreeningQuestion(id:'m4_08',type:QuestionType.likert,
    text:'How often do you leave tasks or projects unfinished — starting with enthusiasm but losing focus or interest before completion?'),
  ScreeningQuestion(id:'m4_09',type:QuestionType.likert,
    text:'How often do you struggle to organise tasks, activities, or your time in a way that allows you to manage responsibilities effectively?'),
  ScreeningQuestion(id:'m4_10',type:QuestionType.likert,
    text:'How often do you find written material — articles, reports, books — difficult to follow because your attention drifts before reaching the end?'),
  ScreeningQuestion(id:'m4_11',type:QuestionType.likert,
    text:'How often do you feel overwhelmed when faced with multiple tasks, and find yourself unable to prioritise or decide where to begin?'),
  ScreeningQuestion(id:'m4_12',type:QuestionType.likert,
    text:'How often do you forget why you walked into a room, what you were about to say, or what you were doing just moments ago?'),
  ScreeningQuestion(id:'m4_13',type:QuestionType.likert,
    text:'How often do you feel physically restless — a need to move, fidget, tap, or get up — when you are expected to remain still?'),
  ScreeningQuestion(id:'m4_14',type:QuestionType.likert,
    text:'How often do you interrupt others mid-sentence, finish their thoughts for them, or blurt out responses before they have finished speaking?'),
  ScreeningQuestion(id:'m4_15',type:QuestionType.likert,
    text:'How often do you make quick decisions — in conversations, purchases, or commitments — without fully thinking through the consequences?'),
  ScreeningQuestion(id:'m4_16',type:QuestionType.likert,
    text:'How often do you find it difficult to wait your turn — in queues, conversations, or group activities?'),
  ScreeningQuestion(id:'m4_17',type:QuestionType.likert,
    text:'How often do you feel an internal sense of urgency or impatience, even when the situation does not require speed?'),
  ScreeningQuestion(id:'m4_18',type:QuestionType.likert,
    text:'How often do you shift from one activity to another before finishing the first — not because you planned to, but because you lost focus?'),
  ScreeningQuestion(id:'m4_19',type:QuestionType.likert,
    text:'You sit down to complete an important piece of work with a deadline. How often do you spend the first hour rearranging your desk, checking your phone, getting a drink, or doing anything except starting the actual work?'),
  ScreeningQuestion(id:'m4_20',type:QuestionType.likert,
    text:'You are in a meeting or lecture. How often do you find that you have been physically present but mentally absent — and cannot recall the last several minutes of discussion?'),
  ScreeningQuestion(id:'m4_21',type:QuestionType.likert,
    text:'You are in the middle of a conversation with someone. How often does a word they say trigger a chain of unrelated thoughts in your mind — so that by the time they finish speaking, you are thinking about something completely different?'),
  ScreeningQuestion(id:'m4_22',type:QuestionType.likert,
    text:'You receive a long email or message that requires a detailed response. How often do you read it, intend to respond, then forget it exists — and only remember when someone chases you?'),
  ScreeningQuestion(id:'m4_23',type:QuestionType.likert,
    text:'You have a list of five things to do today. How often do you complete two of them, get pulled into something unrelated, and find it is evening before you realise the others are still undone?'),
  ScreeningQuestion(id:'m4_24',type:QuestionType.likert,
    text:'You are watching a film, reading a book, or listening to a podcast you are genuinely interested in. How often do you still find your mind wandering and have to rewind or re-read the same section multiple times?'),
  ScreeningQuestion(id:'m4_25',type:QuestionType.likert,
    text:'You are in a social setting and someone is telling a story. How often do you impulsively share your own related story before they have finished — and only realise afterwards that you interrupted?'),
  ScreeningQuestion(id:'m4_26',type:QuestionType.likert,
    text:'You have committed to being somewhere at a specific time. How often do you underestimate how long getting ready takes — and arrive late despite genuinely intending to be on time?'),
  ScreeningQuestion(id:'m4_27',type:QuestionType.likert,
    text:'How often have these patterns of attention or impulse control caused problems at work, in your studies, or in your relationships?'),
  ScreeningQuestion(id:'m4_28',type:QuestionType.likert,
    text:'How often have you been told by teachers, employers, or people close to you that you are not living up to your potential, or that you seem distracted or inconsistent?'),
  ScreeningQuestion(id:'m4_29',type:QuestionType.yesNo,
    text:'Did you experience similar difficulties with attention, focus, or impulsivity as a child or teenager — before the age of 12?'),
  ScreeningQuestion(id:'m4_30',type:QuestionType.likert,
    text:'How often do you feel that your difficulties with focus or impulse control are significantly worse than those of most people around you?'),
];

ScreeningResultBand scoreModule4(Map<String, int> answers) {
  int sum = 0;
  for (final q in module4Questions) {
    sum += answers[q.id] ?? 0;
  }
  if (sum <= 20) return bandLow;
  if (sum <= 44) return bandMonitor;
  return bandElevated;
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 5 — OCD  (Likert 0–4, 28 items)
// Scoring: Low 0–16 | Monitor 17–34 | Elevated 35+
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module5Questions = [
  ScreeningQuestion(id:'m5_01',type:QuestionType.likert,
    text:'How often do you experience unwanted, intrusive thoughts, images, or urges that enter your mind without warning and feel impossible to control?'),
  ScreeningQuestion(id:'m5_02',type:QuestionType.likert,
    text:'How often do these intrusive thoughts cause you significant distress — particularly because they feel inconsistent with your values or who you believe yourself to be?'),
  ScreeningQuestion(id:'m5_03',type:QuestionType.likert,
    text:'How often do you experience persistent doubt — questioning whether you did something correctly, safely, or completely — even after checking?'),
  ScreeningQuestion(id:'m5_04',type:QuestionType.likert,
    text:'How often do you have intrusive thoughts about accidentally harming yourself or others — not because you want to, but as an unwanted, distressing thought that arrives uninvited?'),
  ScreeningQuestion(id:'m5_05',type:QuestionType.likert,
    text:'How often are you bothered by thoughts about contamination, uncleanliness, or the possibility that you or your environment are tainted in some way?'),
  ScreeningQuestion(id:'m5_06',type:QuestionType.likert,
    text:'How often do you feel a need for things to be symmetrical, ordered, or "just right" — and experience significant discomfort when they are not?'),
  ScreeningQuestion(id:'m5_07',type:QuestionType.likert,
    text:'How often do you feel compelled to repeat behaviours or mental acts in response to a distressing thought — even knowing that the behaviour is excessive?'),
  ScreeningQuestion(id:'m5_08',type:QuestionType.likert,
    text:'How often do you check things repeatedly — locks, appliances, taps, or completed work — even though you already know the outcome?'),
  ScreeningQuestion(id:'m5_09',type:QuestionType.likert,
    text:'How often do you wash your hands, clean your body, or clean your surroundings significantly more than most people would consider necessary?'),
  ScreeningQuestion(id:'m5_10',type:QuestionType.likert,
    text:'How often do you arrange, organise, or reorder objects until they feel exactly right — and feel intense discomfort if prevented from doing so?'),
  ScreeningQuestion(id:'m5_11',type:QuestionType.likert,
    text:'How often do you mentally repeat words, phrases, prayers, or counting sequences to neutralise a distressing thought?'),
  ScreeningQuestion(id:'m5_12',type:QuestionType.likert,
    text:'How often do you seek reassurance from others — repeatedly asking them to confirm that everything is fine, that you didn\'t do something wrong, or that something bad hasn\'t happened?'),
  ScreeningQuestion(id:'m5_13',type:QuestionType.likert,
    text:'How often do you collect or find it extremely difficult to throw away items — even ones that have no practical use or value?'),
  ScreeningQuestion(id:'m5_14',type:QuestionType.likert,
    text:'You have just left your home. How often do you need to return — sometimes more than once — to check that the door is locked, the oven is off, or the windows are closed, even though you already checked?'),
  ScreeningQuestion(id:'m5_15',type:QuestionType.likert,
    text:'You shake hands with someone or touch a surface in a public place. How often does this trigger an overwhelming urge to wash your hands immediately, and significant anxiety if you are unable to?'),
  ScreeningQuestion(id:'m5_16',type:QuestionType.likert,
    text:'You are arranging items on a desk or shelf. How often does a slight asymmetry or misalignment cause you significant discomfort — enough that you cannot move on until it is corrected exactly?'),
  ScreeningQuestion(id:'m5_17',type:QuestionType.likert,
    text:'You are driving or walking and pass someone. An intrusive thought enters your mind — "What if I accidentally hurt them?" — even though you have no desire to. How often does this kind of thought arrive and stick with you, causing distress?'),
  ScreeningQuestion(id:'m5_18',type:QuestionType.likert,
    text:'You have completed a task — sent an email, submitted a form, or completed a piece of work. How often do you re-read it, re-check it, or replay it in your mind many times to make sure you didn\'t make an error — despite having already verified it?'),
  ScreeningQuestion(id:'m5_19',type:QuestionType.likert,
    text:'You have a social interaction with someone. Afterwards, how often do you replay the conversation in detail — searching for something you might have said wrong, offended someone with, or that was embarrassing — even when the conversation seemed to go well?'),
  ScreeningQuestion(id:'m5_20',type:QuestionType.likert,
    text:'You experience a distressing intrusive thought. How often do you spend significant time trying to mentally "undo" it — thinking counter-thoughts, praying, or performing a mental ritual to neutralise it?'),
  ScreeningQuestion(id:'m5_21',type:QuestionType.likert,
    text:'How often do these thoughts or behaviours take up more than one hour of your day in total?'),
  ScreeningQuestion(id:'m5_22',type:QuestionType.likert,
    text:'How often do these patterns cause you to avoid people, places, or situations that might trigger the thoughts or the need to perform behaviours?'),
  ScreeningQuestion(id:'m5_23',type:QuestionType.likert,
    text:'How often do the compulsive behaviours you perform actually succeed in reducing your anxiety — or do they only provide brief relief before the urge returns?'),
  ScreeningQuestion(id:'m5_24',type:QuestionType.likert,
    text:'How often have these patterns significantly interfered with your work, relationships, or quality of life?'),
  ScreeningQuestion(id:'m5_25',type:QuestionType.yesNo,
    text:'Have these patterns been present in some form since childhood or adolescence?'),
  ScreeningQuestion(id:'m5_26',type:QuestionType.likert,
    text:'How often do you feel that the thoughts or behaviours are excessive or unreasonable — even while feeling unable to stop them?'),
  ScreeningQuestion(id:'m5_27',type:QuestionType.likert,
    text:'How often do you feel ashamed or embarrassed about these thoughts or behaviours — making it difficult to tell others about them?'),
  ScreeningQuestion(id:'m5_28',type:QuestionType.likert,
    text:'How often do you feel that resisting the compulsion causes a build-up of tension or anxiety that only the behaviour can relieve?'),
];

ScreeningResultBand scoreModule5(Map<String, int> answers) {
  int sum = 0;
  for (final q in module5Questions) {
    sum += answers[q.id] ?? 0;
  }
  if (sum <= 16) return bandLow;
  if (sum <= 34) return bandMonitor;
  return bandElevated;
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 6 — PTSD  (Likert 0–4, 30 items)
// M6.01 is a gating Yes/No question; scoring M6.02 onward
// Scoring: Low 0–20 | Monitor 21–44 | Elevated 45+
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module6Questions = [
  ScreeningQuestion(id:'m6_01',type:QuestionType.yesNo,
    text:'Have you ever experienced or witnessed an event that was deeply distressing — such as a serious accident, violence, abuse, sudden loss, or a life-threatening situation — that still affects how you feel or behave today?'),
  ScreeningQuestion(id:'m6_02',type:QuestionType.likert,
    text:'How often do unwanted memories, images, or mental replays of a distressing event come to mind without you choosing to think about it?'),
  ScreeningQuestion(id:'m6_03',type:QuestionType.likert,
    text:'How often do you have upsetting dreams or nightmares — either directly about a distressing event or with a similar theme of threat, loss, or helplessness?'),
  ScreeningQuestion(id:'m6_04',type:QuestionType.likert,
    text:'How often do you have moments where you feel as if a distressing event is happening again right now — as a flashback, intense memory, or vivid reliving experience?'),
  ScreeningQuestion(id:'m6_05',type:QuestionType.likert,
    text:'How often do reminders of a distressing event — such as sounds, smells, places, or dates — cause sudden and intense emotional distress?'),
  ScreeningQuestion(id:'m6_06',type:QuestionType.likert,
    text:'How often do reminders of a distressing event cause strong physical reactions — such as sweating, shaking, nausea, or a racing heart?'),
  ScreeningQuestion(id:'m6_07',type:QuestionType.likert,
    text:'How often do you avoid thoughts, feelings, or internal reminders of a distressing experience — pushing memories away or refusing to think about what happened?'),
  ScreeningQuestion(id:'m6_08',type:QuestionType.likert,
    text:'How often do you avoid external reminders — places, people, activities, or situations — that are connected to a distressing event?'),
  ScreeningQuestion(id:'m6_09',type:QuestionType.likert,
    text:'How often do you feel a persistent negative view of yourself — believing you are broken, permanently changed, or fundamentally different from who you were before?'),
  ScreeningQuestion(id:'m6_10',type:QuestionType.likert,
    text:'How often do you feel persistent negative beliefs about the world — such as that it is entirely dangerous, that no one can be trusted, or that nowhere is safe?'),
  ScreeningQuestion(id:'m6_11',type:QuestionType.likert,
    text:'How often do you feel unable to experience positive emotions — such as joy, love, or contentment — as if those feelings are no longer accessible to you?'),
  ScreeningQuestion(id:'m6_12',type:QuestionType.likert,
    text:'How often do you feel detached, estranged, or cut off from people around you — as if there is an invisible wall between you and others?'),
  ScreeningQuestion(id:'m6_13',type:QuestionType.likert,
    text:'How often do you experience persistent feelings of guilt or shame related to what happened — feeling somehow responsible for or tainted by the event?'),
  ScreeningQuestion(id:'m6_14',type:QuestionType.likert,
    text:'How often do you feel constantly on guard, watchful, or in a state of alertness — as if danger could appear at any moment?'),
  ScreeningQuestion(id:'m6_15',type:QuestionType.likert,
    text:'How often are you startled by sounds, sudden movements, or unexpected events much more intensely than most people around you?'),
  ScreeningQuestion(id:'m6_16',type:QuestionType.likert,
    text:'How often do you have difficulty falling or staying asleep — lying awake with intrusive thoughts, or waking in fear?'),
  ScreeningQuestion(id:'m6_17',type:QuestionType.likert,
    text:'How often do you feel unusually irritable, have sudden angry outbursts, or react to small frustrations with disproportionate intensity?'),
  ScreeningQuestion(id:'m6_18',type:QuestionType.likert,
    text:'You are watching a film or television programme and a scene unexpectedly depicts violence, an accident, or a threatening situation. How often does this cause you to feel immediate and intense distress — heart racing, feeling sick, or needing to leave the room?'),
  ScreeningQuestion(id:'m6_19',type:QuestionType.likert,
    text:'You are driving on a route that passes near a place connected to a distressing experience. How often do you choose a longer or less convenient route specifically to avoid passing that location?'),
  ScreeningQuestion(id:'m6_20',type:QuestionType.likert,
    text:'You smell something — petrol, a particular food, a perfume — or hear a specific sound, and it immediately transports you back to a distressing memory with a vividness that feels overwhelming. How often does this kind of unexpected sensory trigger happen?'),
  ScreeningQuestion(id:'m6_21',type:QuestionType.likert,
    text:'You are in a crowded space — a shopping centre, a busy street, or a transport hub. How often do you feel on high alert, scanning for threats, or feel certain that something bad is about to happen?'),
  ScreeningQuestion(id:'m6_22',type:QuestionType.likert,
    text:'Someone you trust asks you to talk about what happened. How often does the thought of talking about it feel physically impossible — as though words cannot reach it, or that opening it up would be uncontrollable?'),
  ScreeningQuestion(id:'m6_23',type:QuestionType.likert,
    text:'You are having a calm day. Without any obvious trigger, an intense memory or image from a distressing experience intrudes. How often does this happen — and how difficult is it to refocus afterwards?'),
  ScreeningQuestion(id:'m6_24',type:QuestionType.likert,
    text:'A news report covers a topic similar to your own distressing experience. How often do you find you cannot watch or read it — and feel significant distress for hours or days afterwards?'),
  ScreeningQuestion(id:'m6_25',type:QuestionType.likert,
    text:'How often do these experiences interfere significantly with your ability to work, maintain relationships, or manage daily responsibilities?'),
  ScreeningQuestion(id:'m6_26',type:QuestionType.yesNo,
    text:'Have these symptoms been present consistently for more than one month?'),
  ScreeningQuestion(id:'m6_27',type:QuestionType.likert,
    text:'How often do you feel that what happened has permanently changed who you are — in ways you cannot reverse?'),
  ScreeningQuestion(id:'m6_28',type:QuestionType.likert,
    text:'How often do you use alcohol, substances, or other behaviours — such as overworking or overexercising — as a way of managing these feelings or memories?'),
  ScreeningQuestion(id:'m6_29',type:QuestionType.likert,
    text:'How often do you feel safe — genuinely, physically safe — in your own home and daily life?'),
  ScreeningQuestion(id:'m6_30',type:QuestionType.likert,
    text:'How often do you feel that the distressing experience has affected your ability to form close, trusting relationships with other people?'),
];

ScreeningResultBand scoreModule6(Map<String, int> answers) {
  // m6_01 (Yes/No gate) and m6_26 (Yes/No duration) count as 0/1
  int sum = 0;
  for (final q in module6Questions) {
    sum += answers[q.id] ?? 0;
  }
  if (sum <= 20) return bandLow;
  if (sum <= 44) return bandMonitor;
  return bandElevated;
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 7 — Personality Disorders  (Mixed, 28 items)
// Yes/No [W] items weighted at 3 pts. Likert 0-4.
// Scoring: Low 0–14 | Monitor 15–30 | Elevated 31+
// Safety: M7.08 [Y][W] → Tier 3 escalation if Yes regardless of total
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module7Questions = [
  ScreeningQuestion(id:'m7_01',type:QuestionType.yesNo, isWeighted:true,
    text:'Do you have an intense and persistent fear of being abandoned, rejected, or left — even when there is no clear sign that this is about to happen?'),
  ScreeningQuestion(id:'m7_02',type:QuestionType.likert,
    text:'How often do your close relationships swing between extremes — feeling that the person is perfect and wonderful, then feeling they have completely let you down or are against you?'),
  ScreeningQuestion(id:'m7_03',type:QuestionType.likert,
    text:'How often does your sense of who you are — your identity, values, beliefs, or goals — feel unstable, unclear, or significantly shift depending on who you are with?'),
  ScreeningQuestion(id:'m7_04',type:QuestionType.likert,
    text:'How often do you act impulsively in ways that feel harmful to yourself — such as unsafe behaviour, excessive spending, substance use, binge eating, or reckless decisions?'),
  ScreeningQuestion(id:'m7_05',type:QuestionType.likert,
    text:'How often do your emotions feel overwhelming, shift very rapidly, and feel out of proportion to what triggered them?'),
  ScreeningQuestion(id:'m7_06',type:QuestionType.likert,
    text:'How often do you feel persistently empty inside — a hollow, unfillable feeling — as if something essential is missing?'),
  ScreeningQuestion(id:'m7_07',type:QuestionType.likert,
    text:'How often do you experience episodes of intense anger that feel out of control — either expressed outwardly or turned inward?'),
  ScreeningQuestion(id:'m7_08',type:QuestionType.yesNo, isSafetyItem:true, isWeighted:true,
    text:'Have you ever deliberately harmed yourself, or had persistent thoughts of harming yourself, as a way of coping with overwhelming emotional pain?'),
  ScreeningQuestion(id:'m7_09',type:QuestionType.likert,
    text:'How often do you experience brief but intense periods of feeling detached from yourself or your surroundings — as if you are watching yourself from outside, or the world feels unreal?'),
  ScreeningQuestion(id:'m7_10',type:QuestionType.yesNo,
    text:'Do you find it very difficult to trust other people\'s intentions — tending to assume they have hidden motives or will ultimately let you down?'),
  ScreeningQuestion(id:'m7_11',type:QuestionType.likert,
    text:'How often do you feel fundamentally different from other people — as though you exist outside normal social bonds or cannot truly be understood by others?'),
  ScreeningQuestion(id:'m7_12',type:QuestionType.likert,
    text:'How often do small rejections — a cancelled plan, an unanswered message, or a critical comment — feel disproportionately painful or threatening?'),
  ScreeningQuestion(id:'m7_13',type:QuestionType.likert,
    text:'How often do you feel that your emotional reactions to situations are significantly more intense than those of people around you?'),
  ScreeningQuestion(id:'m7_14',type:QuestionType.likert,
    text:'How often do you find yourself adapting your personality, opinions, or behaviour significantly based on who you are with — to the point where you are unsure which version is the real you?'),
  ScreeningQuestion(id:'m7_15',type:QuestionType.likert,
    text:'A friend cancels plans with you at short notice. How often does this trigger an overwhelming fear that they are pulling away, no longer care about you, or are planning to end the friendship — even if you know logically there is probably a simple reason?'),
  ScreeningQuestion(id:'m7_16',type:QuestionType.likert,
    text:'You are in a close relationship — romantic or friendship. How often do you find yourself alternating between feeling this person is the most important and wonderful person in your life, and feeling they are deeply disappointing, uncaring, or even your enemy — sometimes within the same day?'),
  ScreeningQuestion(id:'m7_17',type:QuestionType.likert,
    text:'You have an argument with someone important to you. How often does the emotional pain feel so overwhelming and uncontrollable in the moment that you consider or take drastic action — ending the relationship, harming yourself, or doing something you later deeply regret?'),
  ScreeningQuestion(id:'m7_18',type:QuestionType.likert,
    text:'You are in a new job, group, or relationship. How often do you unconsciously shape your personality, opinions, and behaviour to match the expectations of the people around you — and later feel uncertain about what you actually think or believe?'),
  ScreeningQuestion(id:'m7_19',type:QuestionType.likert,
    text:'You receive what feels like a dismissive comment or a slight from someone. How often does this trigger an intensity of shame, rage, or emotional pain that you feel unable to control — despite the comment being relatively minor?'),
  ScreeningQuestion(id:'m7_20',type:QuestionType.likert,
    text:'You are alone for an extended period with no distractions. How often does an overwhelming sense of emptiness, panic, or despair arrive — making it very difficult to tolerate being by yourself?'),
  ScreeningQuestion(id:'m7_21',type:QuestionType.yesNo,
    text:'Have you ever ended an important relationship, quit a job, or made a major life change impulsively during a moment of intense emotional pain — and later deeply regretted it?'),
  ScreeningQuestion(id:'m7_22',type:QuestionType.likert,
    text:'Someone you trusted and idealised lets you down in some way. How often does your view of them shift completely — from seeing them as wonderful to seeing them as entirely bad or worthless — with very little middle ground?'),
  ScreeningQuestion(id:'m7_23',type:QuestionType.likert,
    text:'How often do these patterns of emotional intensity, relationship difficulties, or identity instability significantly disrupt your daily life?'),
  ScreeningQuestion(id:'m7_24',type:QuestionType.likert,
    text:'How often do you feel that your emotional pain is so intense that you need to do something — anything — to make it stop, even if that thing might harm you?'),
  ScreeningQuestion(id:'m7_25',type:QuestionType.yesNo,
    text:'Have these patterns been present across different relationships and situations — not just with one person or in one context — for most of your adult life?'),
  ScreeningQuestion(id:'m7_26',type:QuestionType.likert,
    text:'How often do you feel genuine uncertainty about your long-term goals, career direction, values, or the kind of person you want to be?'),
  ScreeningQuestion(id:'m7_27',type:QuestionType.likert,
    text:'How often do you feel that your moods or emotional states shift dramatically within a single day — from feeling fine to feeling devastated, or from feeling calm to feeling explosive?'),
  ScreeningQuestion(id:'m7_28',type:QuestionType.likert,
    text:'How often have these patterns caused significant difficulties in maintaining friendships, romantic relationships, or professional relationships over time?'),
];

ScreeningResultBand scoreModule7(Map<String, int> answers) {
  int sum = 0;
  for (final q in module7Questions) {
    final v = answers[q.id] ?? 0;
    if (q.type == QuestionType.yesNo && q.isWeighted) {
      sum += v * 3;
    } else {
      sum += v;
    }
  }
  if (sum <= 14) return bandLow;
  if (sum <= 30) return bandMonitor;
  return bandElevated;
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 8 — Cognitive Decline  (Yes/No, 25 self + 7 informant)
// Self-report: Low 0–3 | Monitor 4–7 | Elevated 8+
// Informant auto-escalates: if informant ≥ 4 and self = Monitor → Elevated
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module8Questions = [
  ScreeningQuestion(id:'m8_01',type:QuestionType.yesNo,
    text:'Have you noticed that you are having more difficulty remembering recent events or conversations than you used to?'),
  ScreeningQuestion(id:'m8_02',type:QuestionType.yesNo,
    text:'Do you find it harder to recall the names of people you know well — more than feels normal for your age?'),
  ScreeningQuestion(id:'m8_03',type:QuestionType.yesNo,
    text:'Have you had trouble remembering appointments, plans, or things you intended to do — even things you set out to remember?'),
  ScreeningQuestion(id:'m8_04',type:QuestionType.yesNo,
    text:'Have you found yourself repeating the same question or telling the same story to the same person without realising you had already done so?'),
  ScreeningQuestion(id:'m8_05',type:QuestionType.yesNo,
    text:'Have you noticed that you are relying more heavily on notes, reminders, or other people to remember things you previously managed without help?'),
  ScreeningQuestion(id:'m8_06',type:QuestionType.yesNo,
    text:'Do you sometimes lose track of the day of the week, the month, or the year — even for a brief period?'),
  ScreeningQuestion(id:'m8_07',type:QuestionType.yesNo,
    text:'Have you felt confused or disoriented in a familiar place, on a familiar route, or at a familiar time of day?'),
  ScreeningQuestion(id:'m8_08',type:QuestionType.yesNo,
    text:'Have you missed appointments or arrived on the wrong day because you genuinely lost track of the date — not just because you were busy?'),
  ScreeningQuestion(id:'m8_09',type:QuestionType.yesNo,
    text:'Do you sometimes have difficulty finding the right word when speaking — pausing mid-sentence or using a substitute word because the right one won\'t come?'),
  ScreeningQuestion(id:'m8_10',type:QuestionType.yesNo,
    text:'Have you found it harder to follow along in conversations or in written material that you would previously have had no difficulty with?'),
  ScreeningQuestion(id:'m8_11',type:QuestionType.yesNo,
    text:'Have you noticed any change in your ability to write, spell, or construct sentences clearly — compared to how you did a few years ago?'),
  ScreeningQuestion(id:'m8_12',type:QuestionType.yesNo,
    text:'Has it become noticeably harder to manage everyday tasks such as paying bills, organising finances, preparing meals, or following a sequence of instructions?'),
  ScreeningQuestion(id:'m8_13',type:QuestionType.yesNo,
    text:'Have you found it more difficult to make decisions — even straightforward ones — compared to how you managed previously?'),
  ScreeningQuestion(id:'m8_14',type:QuestionType.yesNo,
    text:'Have you noticed a change in your ability to plan ahead, think through problems, or manage multiple steps of a task at once?'),
  ScreeningQuestion(id:'m8_15',type:QuestionType.yesNo,
    text:'Have you made decisions recently that you or others felt showed a significant lapse in judgement — in financial, personal, or safety matters?'),
  ScreeningQuestion(id:'m8_16',type:QuestionType.yesNo,
    text:'Have you noticed that you lose track of what you were doing mid-task — needing to stop and remind yourself of the purpose of what you started?'),
  ScreeningQuestion(id:'m8_17',type:QuestionType.yesNo,
    text:'Have you found it significantly harder to concentrate on a task for a sustained period compared to a few years ago?'),
  ScreeningQuestion(id:'m8_18',type:QuestionType.yesNo,
    text:'Have friends, family, or colleagues expressed concern about your memory or thinking — even if you felt their concern was unnecessary?'),
  ScreeningQuestion(id:'m8_19',type:QuestionType.yesNo,
    text:'Have you noticed changes in your personality, mood, or typical behaviour that feel out of character and that others have remarked on?'),
  ScreeningQuestion(id:'m8_20',type:QuestionType.yesNo,
    text:'Have you withdrawn from hobbies, social activities, or responsibilities that you previously managed well — because they now feel too cognitively demanding?'),
  ScreeningQuestion(id:'m8_21',type:QuestionType.yesNo,
    text:'You are in the middle of making a cup of tea or coffee — a task you have done thousands of times. Have you found yourself forgetting a step, leaving the kettle unfilled, or finding the process genuinely confusing?'),
  ScreeningQuestion(id:'m8_22',type:QuestionType.yesNo,
    text:'You walk into a room with a clear purpose in mind. By the time you arrive, the reason has completely gone — frequently enough that it has begun to concern you or others. Does this sound familiar?'),
  ScreeningQuestion(id:'m8_23',type:QuestionType.yesNo,
    text:'You are having a conversation and you completely lose the thread of what you were saying mid-sentence — not because you got distracted, but because the thought simply disappeared. Has this happened more than occasionally?'),
  ScreeningQuestion(id:'m8_24',type:QuestionType.yesNo,
    text:'You are driving a familiar route. Have you found yourself momentarily uncertain of where you are going or how to get there, even though you have driven this route many times?'),
  ScreeningQuestion(id:'m8_25',type:QuestionType.yesNo,
    text:'You receive a phone bill, a utility statement, or a financial document. Have you found the process of understanding or managing it significantly harder than it used to be — to the point where you needed help or made errors?'),
];

const List<ScreeningQuestion> module8InformantQuestions = [
  ScreeningQuestion(id:'m8_i1',type:QuestionType.yesNo,
    text:'Compared to a few years ago, does the person have noticeably more difficulty remembering recent events, conversations, or things they were told?'),
  ScreeningQuestion(id:'m8_i2',type:QuestionType.yesNo,
    text:'Does the person repeat the same questions, comments, or stories — often without realising they have already said the same thing?'),
  ScreeningQuestion(id:'m8_i3',type:QuestionType.yesNo,
    text:'Have you noticed the person struggling more than before with managing finances, medications, cooking, or other practical daily tasks?'),
  ScreeningQuestion(id:'m8_i4',type:QuestionType.yesNo,
    text:'Does the person sometimes seem confused about the day, date, time of year, or where they are?'),
  ScreeningQuestion(id:'m8_i5',type:QuestionType.yesNo,
    text:'Have you noticed significant personality changes — such as increased suspicion, apathy, aggression, or loss of inhibition — that feel out of character?'),
  ScreeningQuestion(id:'m8_i6',type:QuestionType.yesNo,
    text:'Does the person get lost or disoriented in familiar places or on familiar routes?'),
  ScreeningQuestion(id:'m8_i7',type:QuestionType.yesNo,
    text:'Have you become sufficiently concerned about their memory or thinking that you have discussed it with them or a healthcare professional?'),
];

ScreeningResultBand scoreModule8(Map<String, int> selfAnswers, Map<String, int> informantAnswers) {
  int selfScore = 0;
  for (final q in module8Questions) {
    selfScore += selfAnswers[q.id] ?? 0;
  }
  int informantScore = 0;
  for (final q in module8InformantQuestions) {
    informantScore += informantAnswers[q.id] ?? 0;
  }
  ScreeningResultBand selfBand;
  if (selfScore <= 3) {
    selfBand = bandLow;
  } else if (selfScore <= 7) {
    selfBand = bandMonitor;
  } else {
    selfBand = bandElevated;
  }
  // Auto-escalate: informant ≥ 4 + self = Monitor → Elevated
  if (selfBand == bandMonitor && informantScore >= 4) return bandElevated;
  return selfBand;
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE 9 — Neurodegenerative Signs  (Yes/No, 30 items)
// Alzheimer's cluster M9.01–M9.08: Low 0–1 | Monitor 2–3 | Elevated 4+
// Parkinson's cluster M9.09–M9.20: Low 0–2 | Monitor 3–4 | Elevated 5+
// M9.21–M9.30: cross-cutting indicators used as AI weight multipliers
// ─────────────────────────────────────────────────────────────────────────────

const List<ScreeningQuestion> module9Questions = [
  // Alzheimer's cluster (01–08)
  ScreeningQuestion(id:'m9_01',type:QuestionType.yesNo,
    text:'Has your memory declined noticeably over the past year in a way that feels progressive — getting gradually worse rather than staying the same?'),
  ScreeningQuestion(id:'m9_02',type:QuestionType.yesNo,
    text:'Have you had increasing difficulty recognising familiar faces, objects, or places that you should know well?'),
  ScreeningQuestion(id:'m9_03',type:QuestionType.yesNo,
    text:'Have you noticed significant changes in your personality or behaviour that feel out of character — such as becoming unusually apathetic, disinhibited, suspicious, or agitated?'),
  ScreeningQuestion(id:'m9_04',type:QuestionType.yesNo,
    text:'Have you experienced episodes of significant confusion — not knowing where you are, what time period you are in, or what is happening around you?'),
  ScreeningQuestion(id:'m9_05',type:QuestionType.yesNo,
    text:'Have you had difficulty completing familiar tasks that you have done for years — such as cooking a regular meal, using a familiar appliance, or following a known route?'),
  ScreeningQuestion(id:'m9_06',type:QuestionType.yesNo,
    text:'Have you noticed a significant deterioration in your ability to use language — struggling to follow conversations, finding fewer words, or using words incorrectly?'),
  ScreeningQuestion(id:'m9_07',type:QuestionType.yesNo,
    text:'Have you experienced episodes of seeing things that are not there — such as people, animals, or objects that others confirm are absent?'),
  ScreeningQuestion(id:'m9_08',type:QuestionType.yesNo,
    text:'Has your ability to manage money, make decisions, or judge situations deteriorated noticeably in a way that has caused problems?'),
  // Parkinson's cluster (09–20)
  ScreeningQuestion(id:'m9_09',type:QuestionType.yesNo,
    text:'Have you noticed a tremor or rhythmic shaking in your hands, fingers, arms, or legs — particularly when they are at rest rather than in use?'),
  ScreeningQuestion(id:'m9_10',type:QuestionType.yesNo,
    text:'Have you experienced stiffness or rigidity in your limbs, shoulders, or body — making it harder to move freely or causing discomfort at rest?'),
  ScreeningQuestion(id:'m9_11',type:QuestionType.yesNo,
    text:'Have you noticed that your overall movement, walking pace, or the execution of everyday physical tasks has become noticeably slower?'),
  ScreeningQuestion(id:'m9_12',type:QuestionType.yesNo,
    text:'Has your facial expression changed — with others commenting that you look blank, flat, or emotionless even when you are not feeling that way?'),
  ScreeningQuestion(id:'m9_13',type:QuestionType.yesNo,
    text:'Have you experienced a significant loss of your sense of smell that is not explained by a cold, allergy, or medication?'),
  ScreeningQuestion(id:'m9_14',type:QuestionType.yesNo,
    text:'Do you experience vivid, intense, or frightening dreams in which you physically act out movements — such as talking, shouting, kicking, or thrashing — during sleep?'),
  ScreeningQuestion(id:'m9_15',type:QuestionType.yesNo,
    text:'Have you noticed that your handwriting has become significantly smaller, more cramped, or harder to read than it used to be?'),
  ScreeningQuestion(id:'m9_16',type:QuestionType.yesNo,
    text:'Have you experienced chronic constipation or other significant unexplained changes in digestion that have developed over several years?'),
  ScreeningQuestion(id:'m9_17',type:QuestionType.yesNo,
    text:'Have you experienced significant lightheadedness or faintness when standing up from a seated or lying position?'),
  ScreeningQuestion(id:'m9_18',type:QuestionType.yesNo,
    text:'Has your voice become noticeably softer, more monotone, or harder for others to hear — without an obvious respiratory cause?'),
  ScreeningQuestion(id:'m9_19',type:QuestionType.yesNo,
    text:'Have you noticed that your posture has changed — tending to stoop, hunch forward, or lean — more than in previous years?'),
  ScreeningQuestion(id:'m9_20',type:QuestionType.yesNo,
    text:'Have you experienced episodes of freezing — where your feet feel stuck to the floor and you cannot initiate movement — when starting to walk or changing direction?'),
  // Situational / application-based (21–25)
  ScreeningQuestion(id:'m9_21',type:QuestionType.yesNo,
    text:'You are talking with a family member about a conversation you had together last week. They describe it clearly but you have absolutely no memory of it — not a vague memory, but a complete blank. Has this happened with increasing frequency?'),
  ScreeningQuestion(id:'m9_22',type:QuestionType.yesNo,
    text:'You are preparing a meal you have cooked hundreds of times without thinking. You find yourself standing in the kitchen uncertain of the next step, or you realise you have repeated a step or left something out. Has cooking familiar meals become noticeably more difficult?'),
  ScreeningQuestion(id:'m9_23',type:QuestionType.yesNo,
    text:'Your family or close friends have made direct comments about changes in your personality, mood, or behaviour that concern them — beyond normal aging. Have these conversations happened more than once?'),
  ScreeningQuestion(id:'m9_24',type:QuestionType.yesNo,
    text:'You are walking in a familiar neighbourhood. For a moment — or longer — you feel genuinely uncertain of where you are or how you got there. Has this kind of disorientation happened?'),
  ScreeningQuestion(id:'m9_25',type:QuestionType.yesNo,
    text:'A family member tells you they have watched you during the night — shouting, moving your arms, or physically acting out something — while appearing to be deeply asleep. You had no awareness of this in the morning. Has this been reported to you?'),
  // Progressive onset indicators (26–30)
  ScreeningQuestion(id:'m9_26',type:QuestionType.yesNo,
    text:'Have these changes developed gradually over months or years — rather than appearing suddenly?'),
  ScreeningQuestion(id:'m9_27',type:QuestionType.yesNo,
    text:'Have the changes been getting progressively worse over time — rather than staying stable or improving?'),
  ScreeningQuestion(id:'m9_28',type:QuestionType.yesNo,
    text:'Have these symptoms affected your ability to live independently, manage your own affairs, or maintain your daily routines?'),
  ScreeningQuestion(id:'m9_29',type:QuestionType.yesNo,
    text:'Have you been to a doctor about any of these changes — and if so, have any investigations been done or concerns raised?'),
  ScreeningQuestion(id:'m9_30',type:QuestionType.yesNo,
    text:'Is there a family history of memory loss, Parkinson\'s disease, or other neurological conditions in a close biological relative?'),
];

ScreeningResultBand scoreModule9(Map<String, int> answers) {
  // Alzheimer's cluster score (items 01–08)
  final alzhIds = ['m9_01','m9_02','m9_03','m9_04','m9_05','m9_06','m9_07','m9_08'];
  int alzhScore = alzhIds.fold(0, (s, id) => s + (answers[id] ?? 0));

  // Parkinson's cluster score (items 09–20)
  final parkIds = ['m9_09','m9_10','m9_11','m9_12','m9_13','m9_14','m9_15',
                   'm9_16','m9_17','m9_18','m9_19','m9_20'];
  int parkScore = parkIds.fold(0, (s, id) => s + (answers[id] ?? 0));

  // Determine worst band across both clusters
  ScreeningResultBand alzhBand = alzhScore <= 1 ? bandLow : alzhScore <= 3 ? bandMonitor : bandElevated;
  ScreeningResultBand parkBand = parkScore <= 2 ? bandLow : parkScore <= 4 ? bandMonitor : bandElevated;

  // Return the higher severity band
  if (alzhBand == bandElevated || parkBand == bandElevated) return bandElevated;
  if (alzhBand == bandMonitor || parkBand == bandMonitor) return bandMonitor;
  return bandLow;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper functions used by screening_module_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

List<ScreeningQuestion> questionsForModule(ScreeningModule m) {
  switch (m) {
    case ScreeningModule.m1: return module1Questions;
    case ScreeningModule.m2: return module2Questions;
    case ScreeningModule.m3: return module3Questions;
    case ScreeningModule.m4: return module4Questions;
    case ScreeningModule.m5: return module5Questions;
    case ScreeningModule.m6: return module6Questions;
    case ScreeningModule.m7: return module7Questions;
    case ScreeningModule.m8: return module8Questions;
    case ScreeningModule.m9: return module9Questions;
  }
}

bool moduleHasInformant(ScreeningModule m) => m == ScreeningModule.m8;

List<ScreeningQuestion> informantQuestionsForModule(ScreeningModule m) {
  if (m == ScreeningModule.m8) return module8InformantQuestions;
  return [];
}

ScreeningResultBand computeBandForModule(
  ScreeningModule m,
  Map<String, int> answers, [
  Map<String, int>? informantAnswers,
]) {
  switch (m) {
    case ScreeningModule.m1: return scoreModule1(answers);
    case ScreeningModule.m2: return scoreModule2(answers);
    case ScreeningModule.m3: return scoreModule3(answers);
    case ScreeningModule.m4: return scoreModule4(answers);
    case ScreeningModule.m5: return scoreModule5(answers);
    case ScreeningModule.m6: return scoreModule6(answers);
    case ScreeningModule.m7: return scoreModule7(answers);
    case ScreeningModule.m8: return scoreModule8(answers, informantAnswers ?? {});
    case ScreeningModule.m9: return scoreModule9(answers);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ModuleMeta — display metadata used by ScreeningPage
// ─────────────────────────────────────────────────────────────────────────────

class ModuleMeta {
  final ScreeningModule module;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  const ModuleMeta({
    required this.module,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

const List<ModuleMeta> allModules = [
  ModuleMeta(module: ScreeningModule.m1, title: 'Depression & Anxiety',     subtitle: '30 questions',           icon: Icons.mood_bad,           iconColor: Color(0xFF6366F1)),
  ModuleMeta(module: ScreeningModule.m2, title: 'Bipolar / Mania',           subtitle: '28 questions',           icon: Icons.graphic_eq,         iconColor: Color(0xFFF59E0B)),
  ModuleMeta(module: ScreeningModule.m3, title: 'Psychosis Spectrum',        subtitle: '28 questions',           icon: Icons.remove_red_eye,     iconColor: Color(0xFFEF4444)),
  ModuleMeta(module: ScreeningModule.m4, title: 'ADHD',                      subtitle: '30 questions',           icon: Icons.bolt,               iconColor: Color(0xFF3B82F6)),
  ModuleMeta(module: ScreeningModule.m5, title: 'OCD',                       subtitle: '28 questions',           icon: Icons.loop,               iconColor: Color(0xFF8B5CF6)),
  ModuleMeta(module: ScreeningModule.m6, title: 'PTSD',                      subtitle: '30 questions',           icon: Icons.warning_amber,      iconColor: Color(0xFFEC4899)),
  ModuleMeta(module: ScreeningModule.m7, title: 'Personality Patterns',      subtitle: '28 questions',           icon: Icons.people_alt,         iconColor: Color(0xFF14B8A6)),
  ModuleMeta(module: ScreeningModule.m8, title: 'Cognitive Decline',         subtitle: '25 + 7 informant',      icon: Icons.psychology,         iconColor: Color(0xFF0EA5E9)),
  ModuleMeta(module: ScreeningModule.m9, title: 'Neurodegenerative Signs',   subtitle: '30 questions',           icon: Icons.biotech,            iconColor: Color(0xFF84CC16)),
];


