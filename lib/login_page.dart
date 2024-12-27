import 'package:endometriosis_web/dashboard_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Define valid usernames and passwords
  final Map<String, String> validUsers = {
    "doctor1": "password123",
    "admin": "admin123",
    "surgeon": "surgeonpass",
    "user1": "userpass1",
    "user2": "userpass2",
  };

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = "";

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (validUsers.containsKey(username) && validUsers[username] == password) {
      // Navigate to the Dashboard Page with animation
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const DashboardPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid username or password";
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Endometriosis Assist",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Login form
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Username field
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Password field
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Error message
                          Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 20),
                          // Login button
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
