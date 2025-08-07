import 'package:flutter/material.dart';
import 'beranda_peserta_page.dart';
import 'register_page.dart';
import 'user_data.dart'; // Import data user lokal

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    // Simulasi delay untuk loading effect
    await Future.delayed(Duration(milliseconds: 1500));

    final emailInput = _emailController.text.trim();
    final passwordInput = _passwordController.text.trim();

    setState(() {
      _isLoading = false;
    });

    if (UserData.email == null || UserData.password == null) {
      _showSnackBar(context, "Belum ada akun terdaftar. Silakan daftar dulu.", Colors.orange);
    } else if (emailInput == UserData.email && passwordInput == UserData.password) {
      _showSnackBar(context, "Login berhasil! Selamat datang!", Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BerandaPesertaPage(),
        ),
      );
    } else {
      _showSnackBar(context, "Email atau password salah.", Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
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
                                Icons.gavel_rounded,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Aplikasi Lelang",
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
                            "Selamat datang kembali",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 50),

                          // Login Form Container
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
                                  "Masuk ke Akun Anda",
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

                                // Email Field
                                Container(
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
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      labelStyle: TextStyle(color: Color(0xFF1E3C72)),
                                      prefixIcon: Container(
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(Icons.email_rounded, color: Colors.white),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Password Field
                                Container(
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
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      labelStyle: TextStyle(color: Color(0xFF1E3C72)),
                                      prefixIcon: Container(
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(Icons.lock_rounded, color: Colors.white),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                          color: Color(0xFF1E3C72),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),

                                // Login Button
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
                                    onPressed: _isLoading ? null : () => _login(context),
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
                                              Text("Masuk...", style: TextStyle(fontSize: 16, color: Colors.white)),
                                            ],
                                          )
                                        : Text(
                                            "Masuk",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Register Link
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 16),
                                      children: [
                                        TextSpan(
                                          text: "Belum punya akun? ",
                                          style: TextStyle(color: Colors.grey.shade600),
                                        ),
                                        TextSpan(
                                          text: "Daftar di sini",
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