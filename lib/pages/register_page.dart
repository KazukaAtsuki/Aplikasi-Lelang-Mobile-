
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  
  late AnimationController _animationController;
  late AnimationController _bounceController;
  late AnimationController _floatingController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _floatingAnimation;

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

    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

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

    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _bounceController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bounceController.dispose();
    _floatingController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  bool _validateInputs() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = passwordConfirmController.text.trim();

    if (name.isEmpty) {
      _showSnackBar("Nama lengkap harus diisi!", Color(0xFFE57373));
      return false;
    }

    if (name.length < 2) {
      _showSnackBar("Nama lengkap minimal 2 karakter!", Color(0xFFE57373));
      return false;
    }

    if (email.isEmpty) {
      _showSnackBar("Email harus diisi!", Color(0xFFE57373));
      return false;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar("Format email tidak valid!", Color(0xFFE57373));
      return false;
    }

    if (password.isEmpty) {
      _showSnackBar("Password harus diisi!", Color(0xFFE57373));
      return false;
    }

    if (!_isValidPassword(password)) {
      _showSnackBar("Password minimal 6 karakter!", Color(0xFFE57373));
      return false;
    }

    if (password != confirmPassword) {
      _showSnackBar("Password dan konfirmasi password tidak sama!", Color(0xFFE57373));
      return false;
    }

    if (!_agreeToTerms) {
      _showSnackBar("Anda harus menyetujui syarat dan ketentuan!", Color(0xFFFFB74D));
      return false;
    }

    return true;
  }

  void _register() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        passwordConfirmation: passwordConfirmController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        _showSnackBar("Registrasi berhasil! Silakan login.", Color(0xFF81C784));
        
        // Delay sebentar untuk memberikan feedback visual
        await Future.delayed(Duration(seconds: 1));
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      } else {
        // Handle error response dari Laravel
        String errorMessage = "Registrasi gagal!";
        
        if (result['message'] != null) {
          errorMessage = result['message'];
        } else if (result['errors'] != null) {
          // Handle validation errors dari Laravel
          Map<String, dynamic> errors = result['errors'];
          List<String> errorList = [];
          
          errors.forEach((field, messages) {
            if (messages is List) {
              errorList.addAll(messages.cast<String>());
            }
          });
          
          if (errorList.isNotEmpty) {
            errorMessage = errorList.first;
          }
        }
        
        _showSnackBar(errorMessage, Color(0xFFE57373));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      _showSnackBar("Terjadi kesalahan koneksi. Periksa koneksi internet Anda.", Color(0xFFE57373));
      print("Register error: $e");
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Color(0xFF81C784) ? Icons.check_circle : 
              color == Color(0xFFFFB74D) ? Icons.warning : Icons.error,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message, 
                style: TextStyle(
                  fontWeight: FontWeight.w500, 
                  color: Colors.white
                )
              )
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 4),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0D1B2A).withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE2E8F0),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E293B),
                  Color(0xFF334155),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF0F172A).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Color(0xFF60A5FA), size: 20),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: Color(0xFF64748B),
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          filled: true,
          fillColor: Color(0xFF1E293B),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildFloatingElement(Widget child, double delay) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value + delay),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A), // Dark navy
              Color(0xFF1E293B), // Deep blue-gray
              Color(0xFF334155), // Medium blue-gray
              Color(0xFF475569), // Light blue-gray
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Floating decorative elements
            Positioned(
              top: 100,
              right: 30,
              child: _buildFloatingElement(
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E293B).withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3B82F6).withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: Color(0xFF60A5FA),
                    size: 30,
                  ),
                ),
                5.0,
              ),
            ),
            Positioned(
              top: 200,
              left: 40,
              child: _buildFloatingElement(
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E293B).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3B82F6).withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFF60A5FA),
                    size: 20,
                  ),
                ),
                -3.0,
              ),
            ),
            Positioned(
              bottom: 200,
              right: 50,
              child: _buildFloatingElement(
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E293B).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3B82F6).withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF60A5FA),
                    size: 25,
                  ),
                ),
                7.0,
              ),
            ),
            
            // Main content
            SafeArea(
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
                                  padding: EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF1E293B).withOpacity(0.4),
                                        Color(0xFF334155).withOpacity(0.3),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF3B82F6).withOpacity(0.4),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF0F172A).withOpacity(0.3),
                                        blurRadius: 25,
                                        spreadRadius: 0,
                                        offset: Offset(0, 10),
                                      ),
                                      BoxShadow(
                                        color: Color(0xFF3B82F6).withOpacity(0.1),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person_add_alt_1_rounded,
                                    size: 75,
                                    color: Color(0xFF60A5FA),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                "Daftar Akun Baru",
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFF8FAFC),
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFF0F172A).withOpacity(0.5),
                                      offset: Offset(0, 2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1E293B).withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF3B82F6).withOpacity(0.1),
                                      blurRadius: 15,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "✨ Bergabunglah dengan aplikasi lelang terpercaya",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),

                              // Register Form Container
                              Container(
                                padding: EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1E293B),
                                      Color(0xFF334155),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Color(0xFF475569).withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF0F172A).withOpacity(0.4),
                                      blurRadius: 30,
                                      offset: Offset(0, 15),
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Color(0xFF3B82F6).withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFF3B82F6).withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.app_registration_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          "Buat Akun Anda",
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFF8FAFC),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 4,
                                      width: 60,
                                      margin: EdgeInsets.symmetric(horizontal: 120),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    SizedBox(height: 32),

                                    // Form Fields
                                    _buildTextField(
                                      controller: nameController,
                                      label: "Nama Lengkap",
                                      icon: Icons.person_rounded,
                                    ),

                                    _buildTextField(
                                      controller: emailController,
                                      label: "Alamat Email",
                                      icon: Icons.email_rounded,
                                    ),

                                    _buildTextField(
                                      controller: passwordController,
                                      label: "Kata Sandi",
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
                                      controller: passwordConfirmController,
                                      label: "Konfirmasi Kata Sandi",
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
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF0F172A).withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(0xFF3B82F6).withOpacity(0.2),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              gradient: _agreeToTerms
                                                  ? LinearGradient(
                                                      colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                                                    )
                                                  : null,
                                              boxShadow: _agreeToTerms ? [
                                                BoxShadow(
                                                  color: Color(0xFF3B82F6).withOpacity(0.4),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 3),
                                                ),
                                              ] : [],
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
                                              side: BorderSide(
                                                color: Color(0xFF3B82F6),
                                                width: 2,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _agreeToTerms = !_agreeToTerms;
                                                });
                                              },
                                              child: Text(
                                                "Saya setuju dengan syarat dan ketentuan yang berlaku",
                                                style: TextStyle(
                                                  color: Color(0xFF94A3B8),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 32),

                                    // Register Button
                                    Container(
                                      height: 58,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1D4ED8),
                                            Color(0xFF3B82F6),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF3B82F6).withOpacity(0.4),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Color(0xFF1D4ED8).withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: Offset(0, 5),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: _isLoading ? null : _register,
                                        child: _isLoading
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Text(
                                                    "Sedang Mendaftar...",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.rocket_launch_rounded,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "Daftar Sekarang",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 24),

                                    // Login Link
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Color(0xFF475569).withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: TextButton(
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
                                                style: TextStyle(
                                                  color: Color(0xFF94A3B8),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Masuk di sini",
                                                style: TextStyle(
                                                  color: Color(0xFF60A5FA),
                                                  fontWeight: FontWeight.w600,
                                                  decoration: TextDecoration.underline,
                                                ),
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}