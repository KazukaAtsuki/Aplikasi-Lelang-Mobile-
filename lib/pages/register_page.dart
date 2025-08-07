import 'package:flutter/material.dart';
import 'login_page.dart';
import 'user_data.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  
  late AnimationController _animationController;
  late AnimationController _bounceController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _bounceController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bounceController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  void _register() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulasi delay untuk loading effect
    await Future.delayed(Duration(milliseconds: 1500));

    // Simpan data user
    UserData.nama = _namaController.text.trim();
    UserData.email = _emailController.text.trim();
    UserData.password = _passwordController.text.trim();

    setState(() {
      _isLoading = false;
    });

    _showSnackBar("Registrasi berhasil! Silakan login.", Colors.green);
    
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  bool _validateInputs() {
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (nama.isEmpty) {
      _showSnackBar("Nama lengkap harus diisi!", Colors.red);
      return false;
    }

    if (nama.length < 2) {
      _showSnackBar("Nama lengkap minimal 2 karakter!", Colors.red);
      return false;
    }

    if (email.isEmpty) {
      _showSnackBar("Email harus diisi!", Colors.red);
      return false;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar("Format email tidak valid!", Colors.red);
      return false;
    }

    if (password.isEmpty) {
      _showSnackBar("Password harus diisi!", Colors.red);
      return false;
    }

    if (!_isValidPassword(password)) {
      _showSnackBar("Password minimal 6 karakter!", Colors.red);
      return false;
    }

    if (password != confirmPassword) {
      _showSnackBar("Password dan konfirmasi password tidak sama!", Colors.red);
      return false;
    }

    if (!_agreeToTerms) {
      _showSnackBar("Anda harus menyetujui syarat dan ketentuan!", Colors.orange);
      return false;
    }

    return true;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : 
              color == Colors.orange ? Icons.warning : Icons.error,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF1E3C72)),
          prefixIcon: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF1E3C72),
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3C72), // Deep blue
              Color(0xFF2A5298), // Medium blue
              Color(0xFF87CEEB), // Sky blue
              Color(0xFFF0F8FF), // Alice blue (very light)
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: AnimatedBuilder(
                animation: _fadeInAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeInAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo and Title Section
                          ScaleTransition(
                            scale: _bounceAnimation,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person_add_alt_1_rounded,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Daftar Akun Baru",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Bergabunglah dengan aplikasi lelang",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 40),

                          // Register Form Container
                          Container(
                            padding: EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 25,
                                  offset: Offset(0, 10),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Buat Akun Anda",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E3C72),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  height: 3,
                                  width: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 100),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(height: 30),

                                // Form Fields
                                _buildTextField(
                                  controller: _namaController,
                                  label: "Nama Lengkap",
                                  icon: Icons.person_rounded,
                                ),

                                _buildTextField(
                                  controller: _emailController,
                                  label: "Email",
                                  icon: Icons.email_rounded,
                                ),

                                _buildTextField(
                                  controller: _passwordController,
                                  label: "Password",
                                  icon: Icons.lock_rounded,
                                  obscureText: !_isPasswordVisible,
                                  isPassword: true,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),

                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  label: "Konfirmasi Password",
                                  icon: Icons.lock_outline_rounded,
                                  obscureText: !_isConfirmPasswordVisible,
                                  isPassword: true,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),

                                // Terms and Conditions Checkbox
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        gradient: _agreeToTerms
                                            ? LinearGradient(
                                                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                              )
                                            : null,
                                      ),
                                      child: Checkbox(
                                        value: _agreeToTerms,
                                        onChanged: (value) {
                                          setState(() {
                                            _agreeToTerms = value ?? false;
                                          });
                                        },
                                        activeColor: Colors.transparent,
                                        checkColor: Colors.white,
                                        side: BorderSide(color: Color(0xFF1E3C72), width: 2),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _agreeToTerms = !_agreeToTerms;
                                          });
                                        },
                                        child: Text(
                                          "Saya setuju dengan syarat dan ketentuan",
                                          style: TextStyle(
                                            color: Color(0xFF1E3C72),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),

                                // Register Button
                                Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF1E3C72).withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: _isLoading ? null : _register,
                                    child: _isLoading
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text("Mendaftar...", style: TextStyle(fontSize: 16, color: Colors.white)),
                                            ],
                                          )
                                        : Text(
                                            "Daftar Sekarang",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Login Link
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => LoginPage()),
                                    );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 16),
                                      children: [
                                        TextSpan(
                                          text: "Sudah punya akun? ",
                                          style: TextStyle(color: Colors.grey.shade600),
                                        ),
                                        TextSpan(
                                          text: "Masuk di sini",
                                          style: TextStyle(
                                            color: Color(0xFF1E3C72),
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
} 