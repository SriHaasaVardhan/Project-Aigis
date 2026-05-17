import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/auth_provider.dart';
import 'package:health_guardian/ui/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  late AnimationController _animC;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animC = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animC, curve: Curves.easeInOut);
    _animC.forward();
  }

  @override
  void dispose() { _emailC.dispose(); _passwordC.dispose(); _animC.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (_emailC.text.trim().isEmpty || _passwordC.text.isEmpty) {
      _showSnack('Please enter email and password'); return;
    }
    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final result = await auth.login(_emailC.text.trim(), _passwordC.text);
    setState(() => _loading = false);
    if (result['success'] == true) {
      if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      _showSnack(result['error'] ?? 'Login failed');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  void _showForgotPassword() {
    final emailC = TextEditingController();
    final passC = TextEditingController();
    final confirmC = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24.w, right: 24.w, top: 24.h),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Reset Password', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          TextField(controller: emailC, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
          SizedBox(height: 12.h),
          TextField(controller: passC, obscureText: true, decoration: const InputDecoration(labelText: 'New Password', prefixIcon: Icon(Icons.lock))),
          SizedBox(height: 12.h),
          TextField(controller: confirmC, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outline))),
          SizedBox(height: 20.h),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () async {
              if (passC.text != confirmC.text) { _showSnack('Passwords do not match'); return; }
              if (passC.text.length < 6) { _showSnack('Password must be at least 6 characters'); return; }
              final auth = context.read<AuthProvider>();
              final r = await auth.resetPassword(emailC.text.trim(), passC.text);
              Navigator.pop(ctx);
              _showSnack(r['success'] == true ? 'Password reset successful!' : (r['error'] ?? 'Failed'));
            },
            child: const Text('Reset Password'),
          )),
          SizedBox(height: 24.h),
        ]),
      ),
    );
  }

  void _showRegistration() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _RegistrationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Theme.of(context).scaffoldBackgroundColor, Theme.of(context).primaryColor.withOpacity(0.05)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(height: 40.h),
                Icon(Icons.shield, size: 70.sp, color: Theme.of(context).primaryColor),
                SizedBox(height: 16.h),
                Text('AIGIS', textAlign: TextAlign.center, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w900, letterSpacing: 6)),
                SizedBox(height: 6.h),
                Text('Sign in to continue', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                SizedBox(height: 40.h),
                TextField(controller: _emailC, keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)))),
                SizedBox(height: 16.h),
                TextField(controller: _passwordC, obscureText: _obscure,
                  decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)))),
                SizedBox(height: 8.h),
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _showForgotPassword, child: const Text('Forgot Password?'))),
                SizedBox(height: 12.h),
                SizedBox(height: 52.h, child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r))),
                  child: _loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('Sign In', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                )),
                SizedBox(height: 24.h),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account? ", style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                  GestureDetector(onTap: _showRegistration, child: Text('Create Account', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))),
                ]),
                SizedBox(height: 20.h),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistrationScreen extends StatefulWidget {
  const _RegistrationScreen();
  @override
  State<_RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<_RegistrationScreen> {
  int _step = 0;
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  final _confirmPassC = TextEditingController();
  final _phoneC = TextEditingController();
  final _dobC = TextEditingController();
  final _bioC = TextEditingController();
  final _heightC = TextEditingController();
  final _weightC = TextEditingController();
  final _allergiesC = TextEditingController();
  final _conditionsC = TextEditingController();
  final _medicationsC = TextEditingController();
  final _emergNameC = TextEditingController();
  final _emergPhoneC = TextEditingController();
  final _emergRelC = TextEditingController();
  String _bloodType = 'O+';
  String _gender = 'Male';
  bool _loading = false;
  DateTime? _dob;

  final _bloodTypes = ['A+','A-','B+','B-','AB+','AB-','O+','O-'];
  final _genders = ['Male','Female','Other','Prefer not to say'];

  @override
  void dispose() {
    for (var c in [_nameC,_emailC,_passwordC,_confirmPassC,_phoneC,_dobC,_bioC,_heightC,_weightC,_allergiesC,_conditionsC,_medicationsC,_emergNameC,_emergPhoneC,_emergRelC]) c.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final userData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'email': _emailC.text.trim(),
      'password': _passwordC.text,
      'name': _nameC.text.trim(),
      'phone': _phoneC.text.trim(),
      'date_of_birth': _dob?.toIso8601String() ?? '',
      'blood_type': _bloodType,
      'gender': _gender,
      'height': _heightC.text.trim(),
      'weight': _weightC.text.trim(),
      'bio': _bioC.text.trim(),
      'allergies': _allergiesC.text.trim(),
      'medical_conditions': _conditionsC.text.trim(),
      'current_medications': _medicationsC.text.trim(),
      'emergency_contact_name': _emergNameC.text.trim(),
      'emergency_contact_phone': _emergPhoneC.text.trim(),
      'emergency_contact_relationship': _emergRelC.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
    };
    final result = await auth.register(userData);
    setState(() => _loading = false);
    if (result['success'] == true && mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['error'] ?? 'Registration failed'), behavior: SnackBarBehavior.floating));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1920), lastDate: DateTime.now());
    if (picked != null) {
      _dob = picked;
      _dobC.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  bool _validateStep() {
    switch (_step) {
      case 0:
        if (_nameC.text.trim().isEmpty || _emailC.text.trim().isEmpty || _passwordC.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields'), behavior: SnackBarBehavior.floating)); return false;
        }
        if (_passwordC.text != _confirmPassC.text) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), behavior: SnackBarBehavior.floating)); return false;
        }
        if (_passwordC.text.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters'), behavior: SnackBarBehavior.floating)); return false;
        }
        return true;
      default: return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Account', 'Personal', 'Medical', 'Emergency'];
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), elevation: 0),
      body: SafeArea(
        child: Column(children: [
          // Step indicator
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(children: List.generate(steps.length, (i) => Expanded(
              child: GestureDetector(
                onTap: i <= _step ? () => setState(() => _step = i) : null,
                child: Column(children: [
                  Container(
                    height: 4.h, margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(color: i <= _step ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2.r)),
                  ),
                  SizedBox(height: 4.h),
                  Text(steps[i], style: TextStyle(fontSize: 10.sp, color: i <= _step ? Theme.of(context).primaryColor : Colors.grey)),
                ]),
              ),
            ))),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStep(),
              ),
            ),
          ),
          // Navigation buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(children: [
              if (_step > 0) Expanded(child: OutlinedButton(onPressed: () => setState(() => _step--), child: const Text('Back'))),
              if (_step > 0) SizedBox(width: 12.w),
              Expanded(child: ElevatedButton(
                onPressed: _loading ? null : () {
                  if (_step < 3) { if (_validateStep()) setState(() => _step++); }
                  else { _register(); }
                },
                child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_step < 3 ? 'Next' : 'Create Account'),
              )),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0: return _accountStep();
      case 1: return _personalStep();
      case 2: return _medicalStep();
      case 3: return _emergencyStep();
      default: return const SizedBox();
    }
  }

  Widget _field(TextEditingController c, String label, {IconData? icon, TextInputType? type, bool obscure = false, VoidCallback? onTap, bool readOnly = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: TextField(controller: c, keyboardType: type, obscureText: obscure, readOnly: readOnly, onTap: onTap,
        decoration: InputDecoration(labelText: label, prefixIcon: icon != null ? Icon(icon) : null, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
    );
  }

  Widget _accountStep() => Column(key: const ValueKey(0), crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Account Details', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
    SizedBox(height: 6.h),
    Text('Create your AIGIS account', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
    SizedBox(height: 20.h),
    _field(_nameC, 'Full Name *', icon: Icons.person),
    _field(_emailC, 'Email *', icon: Icons.email, type: TextInputType.emailAddress),
    _field(_phoneC, 'Phone Number', icon: Icons.phone, type: TextInputType.phone),
    _field(_passwordC, 'Password *', icon: Icons.lock, obscure: true),
    _field(_confirmPassC, 'Confirm Password *', icon: Icons.lock_outline, obscure: true),
  ]);

  Widget _personalStep() => Column(key: const ValueKey(1), crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Personal Information', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
    SizedBox(height: 6.h),
    Text('Help us personalize your experience', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
    SizedBox(height: 20.h),
    _field(_dobC, 'Date of Birth', icon: Icons.calendar_today, readOnly: true, onTap: _pickDate),
    Padding(padding: EdgeInsets.only(bottom: 14.h), child: DropdownButtonFormField<String>(
      value: _gender, items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
      onChanged: (v) => setState(() => _gender = v!),
      decoration: InputDecoration(labelText: 'Gender', prefixIcon: const Icon(Icons.wc), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
    )),
    _field(_heightC, 'Height (cm)', icon: Icons.height, type: TextInputType.number),
    _field(_weightC, 'Weight (kg)', icon: Icons.monitor_weight, type: TextInputType.number),
    _field(_bioC, 'Bio', icon: Icons.info_outline),
    Padding(padding: EdgeInsets.only(bottom: 14.h), child: DropdownButtonFormField<String>(
      value: _bloodType, items: _bloodTypes.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
      onChanged: (v) => setState(() => _bloodType = v!),
      decoration: InputDecoration(labelText: 'Blood Type', prefixIcon: const Icon(Icons.bloodtype), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
    )),
  ]);

  Widget _medicalStep() => Column(key: const ValueKey(2), crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Medical Information', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
    SizedBox(height: 6.h),
    Text('This helps in emergencies', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
    SizedBox(height: 20.h),
    _field(_allergiesC, 'Allergies (comma separated)', icon: Icons.warning_amber),
    _field(_conditionsC, 'Medical Conditions (comma separated)', icon: Icons.medical_services),
    _field(_medicationsC, 'Current Medications (comma separated)', icon: Icons.medication),
  ]);

  Widget _emergencyStep() => Column(key: const ValueKey(3), crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Emergency Contact', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
    SizedBox(height: 6.h),
    Text('Who should we contact in emergencies?', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
    SizedBox(height: 20.h),
    _field(_emergNameC, 'Contact Name', icon: Icons.person_outline),
    _field(_emergPhoneC, 'Contact Phone', icon: Icons.phone, type: TextInputType.phone),
    _field(_emergRelC, 'Relationship', icon: Icons.family_restroom),
  ]);
}
