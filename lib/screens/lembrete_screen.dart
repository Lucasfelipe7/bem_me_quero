import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LembreteScreen extends StatefulWidget {
  const LembreteScreen({super.key});

  @override
  _LembreteScreenState createState() => _LembreteScreenState();
}

class _LembreteScreenState extends State<LembreteScreen> {
  int _lembretesPorDia = 3;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initializeFCM();
    _loadPreferences();
  }

  Future<void> _initializeFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notificações permitidas");

      // Obter o token do dispositivo
      String? token = await _firebaseMessaging.getToken();
      print("Token do dispositivo: $token");
    } else {
      print("Notificações não permitidas");
    }
  }


  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lembretesPorDia = prefs.getInt('lembretesPorDia') ?? 3;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lembretesPorDia', _lembretesPorDia);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lembretes Personalizáveis")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Defina quantas vezes por dia deseja receber lembretes para se hidratar:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, size: 32),
                  onPressed: () {
                    setState(() {
                      if (_lembretesPorDia > 1) _lembretesPorDia--;
                    });
                    _savePreferences();
                  },
                ),
                Text(
                  '$_lembretesPorDia',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 32),
                  onPressed: () {
                    setState(() {
                      _lembretesPorDia++;
                    });
                    _savePreferences();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _savePreferences();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Configuração salva! O Firebase enviará lembretes automaticamente.")),
                );
              },
              child: const Text("Salvar Configuração"),
            ),
          ],
        ),
      ),
    );
  }
}
