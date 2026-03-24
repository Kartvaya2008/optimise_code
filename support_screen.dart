import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================
//  support_screen.dart
//  ATS – Customer Support Dialog
//
//  USAGE: Call this from anywhere in the app:
//    showSupportDialog(context);
//
//  DEPENDENCY – add to pubspec.yaml:
//    dependencies:
//      url_launcher: ^6.2.5
//
//  Also add to windows/runner/main.cpp or android/app/src/main/
//  AndroidManifest.xml (url_launcher setup per platform).
// ============================================================

// ── Support constants ──────────────────────────────────────────
const String _kWhatsAppNumber = '917581862317'; // country code + number
const String _kSupportEmail   = 'support@kartvaya.com';
const String _kAppVersion     = '1.0.0';
const String _kLicenseStatus  = 'Active – Pro Plan';

// ── Color tokens ───────────────────────────────────────────────
const Color _kNavy      = Color(0xFF1E2A3A);
const Color _kBlue      = Color(0xFF1A73E8);
const Color _kGreen     = Color(0xFF25D366); // WhatsApp green
const Color _kSurface   = Color(0xFFF5F7FA);
const Color _kBorder    = Color(0xFFDDE3EE);
const Color _kTextMain  = Color(0xFF1E2A3A);
const Color _kTextMuted = Color(0xFF6B7280);

// ============================================================
//  Global function – call from anywhere to show support dialog
// ============================================================
void showSupportDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _SupportDialog(),
  );
}

// ============================================================
//  _SupportDialog – main support popup
// ============================================================
class _SupportDialog extends StatefulWidget {
  const _SupportDialog();

  @override
  State<_SupportDialog> createState() => _SupportDialogState();
}

class _SupportDialogState extends State<_SupportDialog> {

  // Which view is showing: 'home' | 'whatsapp' | 'email'
  String _view = 'home';

  // Selected issue type for WhatsApp message
  String? _selectedIssue;

  // All available issue types
  final List<Map<String, dynamic>> _issueTypes = [
    {'label': 'Chat with Support',           'icon': Icons.chat_bubble_outline},
    {'label': 'Report a Bug',                'icon': Icons.bug_report_outlined},
    {'label': 'Request a Feature',           'icon': Icons.lightbulb_outline},
    {'label': 'License Activation Help',     'icon': Icons.vpn_key_outlined},
    {'label': 'Installation Help',           'icon': Icons.download_outlined},
    {'label': 'Software Not Working',        'icon': Icons.error_outline},
    {'label': 'Payment / Purchase Help',     'icon': Icons.payment_outlined},
    {'label': 'Update Problem',              'icon': Icons.system_update_alt_outlined},
    {'label': 'Account / Login Issue',       'icon': Icons.lock_outline},
    {'label': 'Data Import Issue',           'icon': Icons.upload_file_outlined},
    {'label': 'Performance Issue (Slow)',    'icon': Icons.speed_outlined},
    {'label': 'General Inquiry',             'icon': Icons.help_outline},
    {'label': 'Send Feedback',               'icon': Icons.rate_review_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: Container(
        width: 560,
        constraints: const BoxConstraints(maxHeight: 680),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Dialog header ──────────────────────────────
            _buildHeader(),
            // ── Dialog body ────────────────────────────────
            Flexible(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _view == 'home'
                    ? _buildHomeView()
                    : _view == 'whatsapp'
                        ? _buildWhatsAppView()
                        : _buildEmailView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: _kNavy,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          // Back button (only shown in sub-views)
          if (_view != 'home')
            GestureDetector(
              onTap: () => setState(() {
                _view = 'home';
                _selectedIssue = null;
              }),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 14, color: Colors.white70),
              ),
            ),

          // Icon + title
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF34A853).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.headset_mic_outlined,
                color: Color(0xFF34A853), size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _view == 'home'
                    ? 'Customer Support'
                    : _view == 'whatsapp'
                        ? 'WhatsApp Support'
                        : 'Email Support',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _view == 'home'
                    ? 'How can we help you today?'
                    : _view == 'whatsapp'
                        ? 'Select your issue and send message'
                        : 'Send us an email',
                style: const TextStyle(
                    color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),

          // Close button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.close,
                  size: 16, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  HOME VIEW – two main options
  // ══════════════════════════════════════════════════════════
  Widget _buildHomeView() {
    return SingleChildScrollView(
      key: const ValueKey('home'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Contact options ────────────────────────────────
          Row(
            children: [
              // WhatsApp card
              Expanded(
                child: _ContactCard(
                  icon: Icons.chat,
                  iconColor: _kGreen,
                  iconBg: _kGreen.withOpacity(0.1),
                  title: 'WhatsApp Support',
                  subtitle: 'Chat with us on WhatsApp\nInstant response',
                  badge: 'Recommended',
                  badgeColor: _kGreen,
                  onTap: () => setState(() => _view = 'whatsapp'),
                ),
              ),
              const SizedBox(width: 16),
              // Email card
              Expanded(
                child: _ContactCard(
                  icon: Icons.email_outlined,
                  iconColor: _kBlue,
                  iconBg: _kBlue.withOpacity(0.1),
                  title: 'Email Support',
                  subtitle: 'Send us a detailed email\nReply within 24 hours',
                  badge: '24h Response',
                  badgeColor: _kBlue,
                  onTap: () => setState(() => _view = 'email'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Info row ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 16, color: _kTextMuted),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Support hours: Mon–Sat, 9 AM – 7 PM IST\n'
                    'Phone / WhatsApp: +91 75818 62317',
                    style: const TextStyle(
                        fontSize: 12,
                        color: _kTextMuted,
                        height: 1.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Quick issue links ──────────────────────────────
          const Text(
            'QUICK HELP',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _kTextMuted,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Report a Bug',
              'License Help',
              'Installation Help',
              'Software Slow',
              'Send Feedback',
            ].map((issue) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIssue = issue;
                  _view = 'whatsapp';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _kGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: _kGreen.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat,
                        size: 13, color: _kGreen),
                    const SizedBox(width: 5),
                    Text(issue,
                        style: TextStyle(
                            fontSize: 11,
                            color: _kGreen,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  WHATSAPP VIEW – issue picker + send
  // ══════════════════════════════════════════════════════════
  Widget _buildWhatsAppView() {
    return Column(
      key: const ValueKey('whatsapp'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Issue list
        Flexible(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 16),
            shrinkWrap: true,
            itemCount: _issueTypes.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: _kBorder),
            itemBuilder: (context, index) {
              final issue = _issueTypes[index];
              final label = issue['label'] as String;
              final isSelected = _selectedIssue == label;

              return Material(
                color: isSelected
                    ? _kGreen.withOpacity(0.07)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () =>
                      setState(() => _selectedIssue = label),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 11),
                    child: Row(
                      children: [
                        Icon(
                          issue['icon'] as IconData,
                          size: 18,
                          color: isSelected
                              ? _kGreen
                              : _kTextMuted,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? _kTextMain
                                  : _kTextMain,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              size: 18, color: _kGreen),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Send button
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: _kBorder)),
          ),
          child: Column(
            children: [
              // Message preview
              if (_selectedIssue != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: _kGreen.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _kGreen.withOpacity(0.2)),
                  ),
                  child: Text(
                    _buildWhatsAppMessage(_selectedIssue!),
                    style: const TextStyle(
                        fontSize: 11.5,
                        color: _kTextMuted,
                        height: 1.6,
                        fontFamily: 'monospace'),
                  ),
                ),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _selectedIssue == null
                      ? null
                      : () => _openWhatsApp(_selectedIssue!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        _kGreen.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.chat, size: 18),
                  label: Text(
                    _selectedIssue == null
                        ? 'Select an issue above'
                        : 'Open WhatsApp & Send Message',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  EMAIL VIEW
  // ══════════════════════════════════════════════════════════
  Widget _buildEmailView() {
    return SingleChildScrollView(
      key: const ValueKey('email'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email details card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _kBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: _kBlue.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _emailDetailRow(
                    Icons.email_outlined, 'To', _kSupportEmail),
                const Divider(
                    height: 20, color: Color(0xFFDDE3EE)),
                _emailDetailRow(
                    Icons.subject_outlined,
                    'Subject',
                    'ATS Software Support Request'),
                const Divider(
                    height: 20, color: Color(0xFFDDE3EE)),
                _emailDetailRow(
                    Icons.info_outline,
                    'App Version',
                    'v$_kAppVersion'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Email template preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EMAIL TEMPLATE PREVIEW',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _kTextMuted,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _buildEmailBody(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: _kTextMuted,
                    height: 1.7,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Open email button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text(
                'Open Email Client',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: Text(
              'Opens your default email app (Outlook, Gmail, etc.)',
              style: TextStyle(
                  fontSize: 11,
                  color: _kTextMuted.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build WhatsApp pre-filled message ─────────────────────
  String _buildWhatsAppMessage(String issueType) {
    return 'Hello Support Team,\n\n'
        'I need help with the ATS software.\n\n'
        'Issue Type: $issueType\n'
        'Software Version: v$_kAppVersion\n'
        'License Status: $_kLicenseStatus\n\n'
        'Please assist me.\n\n'
        'Thank you.';
  }

  // ── Build email body ───────────────────────────────────────
  String _buildEmailBody() {
    return 'Hello Support Team,\n\n'
        'I need assistance with ATS by Kartvaya.\n\n'
        'Software Version: v$_kAppVersion\n'
        'License Status: $_kLicenseStatus\n\n'
        'Issue Description:\n'
        '[Please describe your issue here]\n\n'
        'Steps to reproduce:\n'
        '1. \n2. \n3. \n\n'
        'Thank you.';
  }

  // ── Open WhatsApp ──────────────────────────────────────────
  Future<void> _openWhatsApp(String issueType) async {
    final message = _buildWhatsAppMessage(issueType);
    // URL encode the message
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/$_kWhatsAppNumber?text=$encodedMessage';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Could not open WhatsApp. Please install WhatsApp and try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ── Open Email client ──────────────────────────────────────
  Future<void> _openEmail() async {
    final subject = Uri.encodeComponent('ATS Software Support Request');
    final body = Uri.encodeComponent(_buildEmailBody());
    final uri = Uri.parse(
        'mailto:$_kSupportEmail?subject=$subject&body=$body');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Could not open email client. Please email $_kSupportEmail directly.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ── Helper: email detail row ───────────────────────────────
  Widget _emailDetailRow(IconData icon, String key, String value) {
    return Row(
      children: [
        Icon(icon, size: 15, color: _kBlue),
        const SizedBox(width: 10),
        Text(
          '$key:',
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _kTextMuted),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _kTextMain),
          ),
        ),
      ],
    );
  }
}

// ============================================================
//  _ContactCard – home view option card
// ============================================================
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _kTextMain,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: _kTextMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Get Help',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward,
                      size: 13, color: iconColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}