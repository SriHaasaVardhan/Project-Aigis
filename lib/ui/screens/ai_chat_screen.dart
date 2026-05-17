import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollC = ScrollController();
  bool _isTyping = false;
  final List<Map<String, String>> _messages = [
    {'role': 'bot', 'text': 'Hello! I am your AIGIS Health Assistant. I can help with health questions, first aid tips, medication info, symptoms, and general wellness advice. How can I help you today?'}
  ];

  static const Map<String, List<String>> _keywords = {
    'headache': ['headache', 'head pain', 'head hurts', 'migraine', 'head ache'],
    'fever': ['fever', 'temperature', 'hot body', 'feverish', 'chills'],
    'cold': ['cold', 'runny nose', 'sneezing', 'stuffy nose', 'congestion', 'blocked nose'],
    'cough': ['cough', 'coughing', 'sore throat', 'throat pain', 'throat hurts'],
    'stomach': ['stomach', 'belly', 'abdomen', 'tummy', 'nausea', 'vomiting', 'diarrhea', 'indigestion', 'acidity', 'gastric'],
    'back_pain': ['back pain', 'backache', 'back hurts', 'spine', 'lower back'],
    'allergy': ['allergy', 'allergic', 'rash', 'hives', 'itching', 'itchy', 'swelling'],
    'anxiety': ['anxiety', 'anxious', 'nervous', 'panic', 'panic attack', 'stressed', 'stress', 'worried'],
    'sleep': ['sleep', 'insomnia', 'cant sleep', 'sleepless', 'tired', 'fatigue', 'exhausted'],
    'blood_pressure': ['blood pressure', 'bp', 'hypertension', 'low bp', 'high bp'],
    'diabetes': ['diabetes', 'sugar', 'blood sugar', 'glucose', 'insulin', 'diabetic'],
    'breathing': ['breathing', 'breath', 'breathless', 'shortness of breath', 'asthma', 'wheezing'],
    'chest_pain': ['chest pain', 'chest hurts', 'chest tight', 'heart pain'],
    'skin': ['skin', 'acne', 'pimple', 'eczema', 'dry skin', 'skin rash', 'sunburn'],
    'eye': ['eye', 'eyes', 'vision', 'blurry', 'eye pain', 'red eyes', 'dry eyes'],
    'dental': ['tooth', 'teeth', 'dental', 'toothache', 'gum', 'cavity'],
    'muscle': ['muscle', 'cramp', 'sprain', 'strain', 'sore muscles', 'muscle pain', 'body pain'],
    'dehydration': ['dehydration', 'dehydrated', 'thirsty', 'dry mouth', 'water'],
    'diet': ['diet', 'nutrition', 'food', 'eat', 'eating', 'weight loss', 'weight gain', 'calories', 'protein', 'vitamin'],
    'exercise': ['exercise', 'workout', 'fitness', 'gym', 'running', 'walking', 'yoga'],
    'greeting': ['hi', 'hello', 'hey', 'good morning', 'good evening', 'good afternoon', 'how are you', 'whats up'],
    'thanks': ['thank', 'thanks', 'thank you', 'appreciate'],
    'help': ['help', 'what can you do', 'features', 'abilities'],
    'burn': ['burn', 'burned', 'scald', 'burnt'],
    'cut': ['cut', 'wound', 'bleeding', 'bleed', 'injury', 'injured'],
    'fracture': ['fracture', 'broken bone', 'bone break', 'sprain'],
    'pregnancy': ['pregnancy', 'pregnant', 'prenatal', 'morning sickness'],
    'mental_health': ['depression', 'depressed', 'sad', 'lonely', 'mental health', 'therapy', 'counseling'],
    'heart': ['heart', 'heart rate', 'pulse', 'palpitation', 'heartbeat', 'cardiac'],
    'joint': ['joint', 'joint pain', 'arthritis', 'knee pain', 'knee', 'elbow', 'wrist'],
  };

  static const Map<String, String> _responses = {
    'headache': '🤕 **Headache Relief:**\n\n• Take paracetamol (500mg) or ibuprofen (200-400mg) with food\n• Drink plenty of water — dehydration is a common cause\n• Rest in a quiet, dark room\n• Apply a cold compress to your forehead\n• Try gentle neck and temple massage\n• If headaches persist for more than 3 days or are severe, please consult a doctor\n\n⚠️ Seek immediate help if accompanied by vision changes, confusion, or neck stiffness.',
    'fever': '🌡️ **Fever Management:**\n\n• Take paracetamol or ibuprofen as directed\n• Stay well hydrated with water, soups, and electrolyte drinks\n• Rest as much as possible\n• Wear light clothing and use a light blanket\n• Sponge with lukewarm (not cold) water if temperature is high\n• Monitor temperature every 4 hours\n\n⚠️ Seek medical attention if fever exceeds 103°F (39.4°C), lasts more than 3 days, or is accompanied by rash or difficulty breathing.',
    'cold': '🤧 **Common Cold Relief:**\n\n• Rest and stay hydrated\n• Drink warm liquids (tea, soup, warm water with honey & lemon)\n• Use saline nasal drops for congestion\n• Steam inhalation can help clear sinuses\n• Gargle with warm salt water for sore throat\n• Over-the-counter decongestants can help if needed\n• Vitamin C and zinc may help reduce duration\n\nColds typically resolve in 7-10 days.',
    'cough': '😷 **Cough & Sore Throat:**\n\n• Drink warm water with honey and lemon\n• Gargle with warm salt water (½ tsp salt in 1 cup water)\n• Use throat lozenges or hard candy\n• Stay hydrated — sip warm fluids throughout the day\n• Use a humidifier to add moisture to air\n• Avoid irritants like smoke and dust\n• Over-the-counter cough suppressants for dry cough\n\n⚠️ See a doctor if cough persists over 2 weeks or produces blood.',
    'stomach': '🤢 **Stomach Issues:**\n\n• For nausea: Try ginger tea, peppermint, or small sips of clear fluids\n• For acidity: Antacids, avoid spicy/oily food, don\'t lie down after eating\n• For diarrhea: Stay hydrated with ORS (Oral Rehydration Solution), eat bland foods (BRAT diet: Bananas, Rice, Applesauce, Toast)\n• For vomiting: Small sips of clear fluid, avoid solid food until vomiting stops\n• Avoid caffeine, alcohol, and dairy temporarily\n\n⚠️ See a doctor if symptoms persist over 48 hours or there\'s blood in stool.',
    'back_pain': '🔙 **Back Pain Relief:**\n\n• Apply ice for first 48 hours, then switch to heat\n• Take ibuprofen or naproxen for inflammation\n• Gentle stretching and walking can help\n• Maintain good posture while sitting\n• Sleep on a firm surface with a pillow between knees\n• Avoid heavy lifting\n• Consider gentle yoga or swimming for ongoing relief\n\n⚠️ See a doctor if pain radiates down legs, causes numbness, or follows an injury.',
    'allergy': '🤧 **Allergy Management:**\n\n• Take antihistamines (cetirizine, loratadine) for mild symptoms\n• Apply calamine lotion or hydrocortisone cream for skin rashes\n• Use cold compress for swelling\n• Identify and avoid allergen triggers\n• Keep an allergy diary to track reactions\n• For nasal allergies, saline rinse can help\n\n⚠️ **EMERGENCY:** If experiencing throat swelling, difficulty breathing, or severe reaction, use epinephrine (EpiPen) and call emergency services immediately!',
    'anxiety': '🧘 **Anxiety & Stress Relief:**\n\n• Practice deep breathing: Inhale 4 sec, hold 4 sec, exhale 6 sec\n• Try the 5-4-3-2-1 grounding technique (5 things you see, 4 you touch, 3 you hear, 2 you smell, 1 you taste)\n• Regular exercise helps reduce anxiety\n• Limit caffeine and alcohol\n• Maintain a regular sleep schedule\n• Try guided meditation or progressive muscle relaxation\n• Journal your thoughts and feelings\n\n💬 If anxiety is frequent or overwhelming, consider speaking with a mental health professional.',
    'sleep': '😴 **Better Sleep Tips:**\n\n• Maintain a consistent sleep schedule\n• Avoid screens 1 hour before bed\n• Keep your room cool, dark, and quiet\n• Avoid caffeine after 2 PM\n• Try relaxation techniques like deep breathing\n• Limit naps to 20-30 minutes\n• Exercise regularly but not close to bedtime\n• Avoid heavy meals before sleep\n• Consider herbal teas like chamomile\n\nIf insomnia persists over 3 weeks, consult a doctor.',
    'blood_pressure': '💓 **Blood Pressure Management:**\n\n• Monitor BP regularly\n• Reduce salt intake (< 5g/day)\n• Eat potassium-rich foods (bananas, spinach, sweet potatoes)\n• Exercise 30 minutes daily\n• Maintain healthy weight\n• Limit alcohol and quit smoking\n• Manage stress through meditation/yoga\n• Take prescribed medications consistently\n\n⚠️ If BP is above 180/120, seek immediate medical attention.',
    'diabetes': '🩸 **Diabetes Management:**\n\n• Monitor blood sugar regularly\n• Follow a balanced diet with low glycemic index foods\n• Exercise 30 minutes daily\n• Take medications as prescribed\n• Stay hydrated\n• Check feet daily for sores\n• Regular eye and kidney checkups\n• Carry glucose tablets for hypoglycemia\n\n⚠️ If blood sugar drops below 70 mg/dL, consume fast-acting sugar immediately.',
    'breathing': '🫁 **Breathing Difficulties:**\n\n• Sit upright to open airways\n• Practice pursed lip breathing\n• Use prescribed inhaler if available\n• Stay calm — anxiety worsens breathlessness\n• Remove tight clothing\n• Move to fresh air if in a stuffy room\n• Steam inhalation may help if caused by congestion\n\n⚠️ **EMERGENCY:** If breathing difficulty is severe, lips turn blue, or you can\'t speak in full sentences, call emergency services immediately!',
    'chest_pain': '❤️ **Chest Pain:**\n\n⚠️ **IMPORTANT:** Chest pain can be a medical emergency.\n\n• If you suspect a heart attack (crushing pain, pain radiating to arm/jaw, sweating), call emergency services (108) IMMEDIATELY\n• Chew an aspirin (300mg) if not allergic\n• Sit upright and try to stay calm\n• Loosen tight clothing\n\nNon-cardiac causes may include acid reflux, muscle strain, or anxiety. If pain is mild and related to eating, try antacids.\n\n🚨 Always err on the side of caution with chest pain.',
    'skin': '🧴 **Skin Care:**\n\n• For acne: Wash face twice daily with gentle cleanser, avoid touching face\n• For dry skin: Moisturize after bathing, drink enough water\n• For eczema: Use fragrance-free moisturizer, avoid scratching\n• For sunburn: Apply aloe vera gel, stay hydrated, take cool showers\n• For rashes: Try hydrocortisone cream, antihistamines\n\nSee a dermatologist if skin conditions don\'t improve in 2 weeks.',
    'eye': '👁️ **Eye Care:**\n\n• For dry eyes: Use artificial tears, follow 20-20-20 rule (every 20 min, look 20 feet away for 20 sec)\n• For red eyes: Cold compress, avoid rubbing\n• For eye strain: Adjust screen brightness, take regular breaks\n• Clean contact lenses properly\n• Wear sunglasses in bright sunlight\n\n⚠️ See an eye doctor immediately for sudden vision changes, pain, or flashes of light.',
    'dental': '🦷 **Dental Care:**\n\n• For toothache: Rinse with warm salt water, take ibuprofen, apply clove oil\n• For gum pain: Gentle brushing with soft bristle, warm salt rinse\n• Brush twice daily with fluoride toothpaste\n• Floss daily\n• Avoid very hot or cold foods if sensitive\n\nVisit a dentist if pain persists more than 2 days.',
    'muscle': '💪 **Muscle Pain Relief:**\n\n• RICE method: Rest, Ice, Compression, Elevation\n• Take ibuprofen or apply topical pain relief\n• Gentle stretching after rest\n• Warm bath or heat pad after 48 hours\n• Stay hydrated — dehydration causes cramps\n• Eat potassium and magnesium rich foods\n\n⚠️ See a doctor if you hear a snap during injury or can\'t bear weight.',
    'dehydration': '💧 **Staying Hydrated:**\n\n• Drink 8-10 glasses of water daily\n• More if exercising, hot weather, or ill\n• Signs of dehydration: dark urine, dry mouth, dizziness, fatigue\n• Use ORS for severe dehydration\n• Eat water-rich fruits (watermelon, cucumber, oranges)\n• Avoid excess caffeine and alcohol\n\n⚠️ Severe dehydration with confusion or fainting needs immediate medical attention.',
    'diet': '🥗 **Nutrition & Diet Tips:**\n\n• Eat a balanced diet with fruits, vegetables, whole grains, lean protein\n• Reduce processed foods, sugar, and excess salt\n• Eat regular meals — don\'t skip breakfast\n• Portion control is key for weight management\n• Include fiber for digestive health\n• Stay hydrated throughout the day\n• Consider multivitamins if diet is restricted\n\nConsult a nutritionist for personalized diet plans.',
    'exercise': '🏃 **Exercise Guidelines:**\n\n• Aim for 150 minutes of moderate exercise per week\n• Start slow if you\'re a beginner\n• Include both cardio and strength training\n• Warm up before and stretch after exercise\n• Stay hydrated during workouts\n• Rest days are important for recovery\n• Listen to your body — stop if you feel pain\n\nConsult a doctor before starting intense exercise if you have health conditions.',
    'greeting': '👋 Hello! Welcome to AIGIS Health Assistant!\n\nI can help you with:\n• 💊 Medication information\n• 🩺 Symptom guidance\n• 🏥 First aid tips\n• 🧘 Wellness advice\n• 🥗 Diet & nutrition\n• 🏃 Exercise tips\n• 🧠 Mental health support\n\nJust describe what you\'re feeling or ask any health question!',
    'thanks': '😊 You\'re welcome! I\'m always here to help. Take care of your health and don\'t hesitate to ask if you need anything else!\n\n⚠️ Remember: I provide general health information. For specific medical concerns, always consult a healthcare professional.',
    'help': '🤖 **AIGIS Health Assistant Capabilities:**\n\n• Answer health & wellness questions\n• Provide first-aid guidance\n• Share medication information\n• Offer symptom-based suggestions\n• Give diet & nutrition tips\n• Exercise recommendations\n• Mental health support\n• Emergency guidance\n\nJust type your question or describe your symptoms!',
    'burn': '🔥 **Burn First Aid:**\n\n• Cool the burn under running cool (not cold) water for 10-20 minutes\n• Remove jewelry/clothing near the burn (if not stuck)\n• Cover with sterile gauze or clean cloth\n• Take pain relievers if needed\n• DO NOT apply ice, butter, or toothpaste\n• DO NOT pop blisters\n\n⚠️ Seek emergency care for burns larger than your palm, on face/hands/genitals, or if skin is charred/white.',
    'cut': '🩹 **Cut/Wound First Aid:**\n\n• Apply firm pressure with clean cloth to stop bleeding\n• Clean wound with clean water\n• Apply antibiotic ointment\n• Cover with sterile bandage\n• Change bandage daily\n• Watch for signs of infection (redness, swelling, warmth, pus)\n\n⚠️ Seek medical help if: wound is deep, won\'t stop bleeding after 10 min, or caused by rusty/dirty object (may need tetanus shot).',
    'fracture': '🦴 **Fracture First Aid:**\n\n• Immobilize the injured area — DON\'T try to realign\n• Apply ice wrapped in cloth to reduce swelling\n• Keep the injured area elevated if possible\n• Use a splint or sling for support\n• Take pain medication\n\n⚠️ GO TO EMERGENCY if: bone is visible, there\'s severe swelling, numbness, or the person can\'t move the limb.',
    'pregnancy': '🤰 **Pregnancy Wellness:**\n\n• Take prenatal vitamins (especially folic acid)\n• Eat a balanced diet, avoid raw/undercooked foods\n• Stay hydrated\n• Light exercise is beneficial (walking, prenatal yoga)\n• Get adequate rest\n• Attend all prenatal appointments\n• For morning sickness: try ginger tea, small frequent meals\n\n⚠️ Contact your doctor immediately for heavy bleeding, severe pain, or reduced baby movement.',
    'mental_health': '🧠 **Mental Health Support:**\n\n• You\'re not alone — it\'s okay to seek help\n• Talk to someone you trust\n• Practice self-care: exercise, sleep, healthy eating\n• Try mindfulness or meditation\n• Limit social media if it affects your mood\n• Set small achievable goals each day\n• Professional help (therapy) is effective and recommended\n\n🆘 If you\'re in crisis, call a mental health helpline: Vandrevala Foundation: 1860-2662-345 or iCall: 9152987821',
    'heart': '❤️ **Heart Health:**\n\n• Normal resting heart rate: 60-100 BPM\n• Exercise strengthens your heart\n• Eat heart-healthy foods (fish, nuts, fruits, vegetables)\n• Reduce salt and saturated fats\n• Don\'t smoke\n• Manage stress\n• Monitor cholesterol and BP regularly\n\n⚠️ Seek immediate help for chest pain, irregular heartbeat with dizziness, or sudden severe palpitations.',
    'joint': '🦵 **Joint Pain Relief:**\n\n• Rest the affected joint\n• Apply ice for 15-20 minutes several times a day\n• Use compression bandage for support\n• Elevate the joint above heart level\n• Over-the-counter NSAIDs (ibuprofen) for pain\n• Gentle range-of-motion exercises\n• Maintain healthy weight to reduce joint stress\n\nSee a doctor if pain persists over 2 weeks or joint is hot/red.',
  };

  String _getResponse(String query) {
    final lower = query.toLowerCase().trim();
    for (final entry in _keywords.entries) {
      for (final kw in entry.value) {
        if (lower.contains(kw)) {
          return _responses[entry.key] ?? _defaultResponse();
        }
      }
    }
    return _defaultResponse();
  }

  String _defaultResponse() {
    return '🩺 I understand your concern. Here are some general health tips:\n\n'
        '• Stay hydrated and eat a balanced diet\n'
        '• Get 7-8 hours of sleep\n'
        '• Exercise regularly\n'
        '• Manage stress through relaxation techniques\n\n'
        'Could you provide more details about your symptoms? For example:\n'
        '• Where is the discomfort?\n'
        '• How long have you had it?\n'
        '• Any other symptoms?\n\n'
        'I can give more specific advice with more details. For serious concerns, please consult a healthcare professional.';
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': _controller.text});
      _isTyping = true;
    });
    final query = _controller.text;
    _controller.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages.add({'role': 'bot', 'text': _getResponse(query)});
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollC.hasClients) _scrollC.animateTo(_scrollC.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('AIGIS Health Assistant')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollC,
              padding: EdgeInsets.all(16.w),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return Align(alignment: Alignment.centerLeft, child: Container(
                    margin: EdgeInsets.only(bottom: 12.h), padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[200], borderRadius: BorderRadius.circular(16.r)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor)),
                      SizedBox(width: 8.w), Text('Thinking...', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    ]),
                  ));
                }
                final msg = _messages[index];
                final isBot = msg['role'] == 'bot';
                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h, left: isBot ? 0 : 40.w, right: isBot ? 40.w : 0),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isBot ? (isDark ? Colors.grey[800] : Colors.grey[200]) : Theme.of(context).primaryColor.withOpacity(0.85),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(isBot ? 4.r : 16.r), bottomRight: Radius.circular(isBot ? 16.r : 4.r),
                      ),
                    ),
                    child: Text(msg['text']!, style: TextStyle(color: isBot ? (isDark ? Colors.white : Colors.black87) : Colors.white, fontSize: 14.sp, height: 1.4)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
            child: Row(children: [
              Expanded(child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(hintText: 'Describe your symptoms...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.r)), contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h)),
              )),
              SizedBox(width: 8.w),
              CircleAvatar(radius: 22.r, backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: _sendMessage)),
            ]),
          ),
        ]),
      ),
    );
  }
}
