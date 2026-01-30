import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppUtils {
  // Setup Supabase notifications
  static Future<void> setupNotifications() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Subscribe to weather alerts channel
        final channel = Supabase.instance.client.channel('weather_alerts');

        channel
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'weather_alerts',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: user.id,
              ),
              callback: (payload) {
                // Handle real-time weather alerts
                _handleWeatherAlert(payload);
              },
            )
            .subscribe();
      }
    } catch (e) {
      debugPrint('Error setting up notifications: $e');
    }
  }

  static void _handleWeatherAlert(PostgresChangePayload payload) {
    // Handle incoming weather alerts
    debugPrint('Weather alert received: ${payload.newRecord}');
    // You can show local notifications here
  }

  // Rate the app functionality
  static Future<void> rateApp(BuildContext context) async {
    try {
      // For iOS
      const iosUrl = 'https://apps.apple.com/app/id123456789';
      // For Android
      const androidUrl =
          'https://play.google.com/store/apps/details?id=com.example.glasscast';

      // Try to launch the appropriate store
      final Uri url = Uri.parse(Theme.of(context).platform == TargetPlatform.iOS
          ? iosUrl
          : androidUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          _showErrorSnackBar(context, 'Could not open app store');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error opening app store');
      }
    }
  }

  // Open privacy policy
  static Future<void> openPrivacyPolicy(BuildContext context) async {
    try {
      const url = 'https://glasscast.app/privacy';
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          _showErrorSnackBar(context, 'Could not open privacy policy');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error opening privacy policy');
      }
    }
  }

  // Share app functionality
  static Future<void> shareApp(BuildContext context) async {
    try {
      const text =
          'Check out Glasscast - AI-powered weather insights! Download now: https://glasscast.app';
      await Clipboard.setData(const ClipboardData(text: text));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App link copied to clipboard!'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error sharing app');
      }
    }
  }

  // Show contact support dialog
  static void showContactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Contact Support',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Need help? Contact us:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              _buildContactOption(
                icon: Icons.email,
                title: 'Email Support',
                subtitle: 'support@glasscast.app',
                onTap: () => _sendEmail(context),
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                icon: Icons.bug_report,
                title: 'Report Bug',
                subtitle: 'Help us improve',
                onTap: () => _reportBug(context),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFF3B82F6)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show about dialog
  static void showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                ),
                child: const Icon(
                  Icons.cloud,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Glasscast',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 8),
              Text(
                'AI-powered weather insights with beautiful glassmorphism design.',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                '© 2024 Glasscast. All rights reserved.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFF3B82F6)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Edit profile dialog
  static void showEditProfileDialog(BuildContext context, String currentName,
      String currentEmail, Function(String, String) onSave) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle:
                      TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(nameController.text.trim(), emailController.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xFF3B82F6)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Private helper methods
  static Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF3B82F6), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _sendEmail(BuildContext context) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'support@glasscast.app',
        query: 'subject=Glasscast Support Request',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        await Clipboard.setData(
            const ClipboardData(text: 'support@glasscast.app'));
        if (context.mounted) {
          _showSuccessSnackBar(context, 'Email copied to clipboard');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error opening email');
      }
    }
  }

  static Future<void> _reportBug(BuildContext context) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'bugs@glasscast.app',
        query: 'subject=Bug Report - Glasscast',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        await Clipboard.setData(
            const ClipboardData(text: 'bugs@glasscast.app'));
        if (context.mounted) {
          _showSuccessSnackBar(context, 'Email copied to clipboard');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error opening email');
      }
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
