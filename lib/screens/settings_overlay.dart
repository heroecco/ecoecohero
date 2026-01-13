import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class SettingsOverlay extends StatefulWidget {
  const SettingsOverlay({super.key});

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay>
    with SingleTickerProviderStateMixin {
  bool musicEnabled = true;
  bool soundEnabled = true;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEcoPartGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _EcoPartGuideDialog(),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _PrivacyPolicyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 420,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.deepNavy, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepNavy.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.deepNavy,
                              AppColors.deepNavy.withValues(alpha: 0.9),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: AppColors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'OPTIONS',
                              style: GoogleFonts.comfortaa(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content - Scrollable
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            children: [
                              // Audio section header
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: AppColors.cyan,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'AUDIO',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.deepNavy.withValues(
                                        alpha: 0.6,
                                      ),
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Music toggle
                              _SettingsToggle(
                                icon: Icons.music_note_rounded,
                                label: 'Music',
                                subtitle: 'Background melodies',
                                value: musicEnabled,
                                onChanged: (val) {
                                  setState(() => musicEnabled = val);
                                },
                              ),
                              const SizedBox(height: 12),

                              // Sound toggle
                              _SettingsToggle(
                                icon: Icons.volume_up_rounded,
                                label: 'Sound Effects',
                                subtitle: 'Gameplay audio',
                                value: soundEnabled,
                                onChanged: (val) {
                                  setState(() => soundEnabled = val);
                                },
                              ),
                              const SizedBox(height: 28),

                              // Divider
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppColors.deepNavy.withValues(alpha: 0.2),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Info section header
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: AppColors.green,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'INFO',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.deepNavy.withValues(
                                        alpha: 0.6,
                                      ),
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Eco Part Guide button
                              _SettingsButton(
                                icon: Icons.help_outline_rounded,
                                label: 'Eco Part Guide',
                                subtitle: 'Learn how to play',
                                onPressed: () => _showEcoPartGuide(context),
                              ),
                              const SizedBox(height: 12),

                              // Privacy button
                              _SettingsButton(
                                icon: Icons.privacy_tip_outlined,
                                label: 'Privacy',
                                subtitle: 'Privacy policy',
                                onPressed: () => _showPrivacyPolicy(context),
                              ),
                              const SizedBox(height: 28),

                              // Close button
                              _CloseButton(
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value
              ? AppColors.green.withValues(alpha: 0.1)
              : AppColors.deepNavy.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value
                ? AppColors.green.withValues(alpha: 0.5)
                : AppColors.deepNavy.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: value
                    ? AppColors.green.withValues(alpha: 0.2)
                    : AppColors.deepNavy.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: value
                    ? AppColors.green
                    : AppColors.deepNavy.withValues(alpha: 0.5),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.comfortaa(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.comfortaa(
                      fontSize: 12,
                      color: AppColors.deepNavy.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // Custom toggle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: value ? AppColors.green : const Color(0xFFCBD5E1),
                border: Border.all(
                  color: value
                      ? AppColors.green
                      : AppColors.deepNavy.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    left: value ? 30 : 2,
                    top: 2,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          value ? Icons.check : Icons.close,
                          size: 14,
                          color: value
                              ? AppColors.green
                              : AppColors.deepNavy.withValues(alpha: 0.4),
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
  }
}

class _SettingsButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onPressed;

  const _SettingsButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  State<_SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<_SettingsButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.deepNavy.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.deepNavy.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: AppColors.cyan, size: 24),
            ),
            const SizedBox(width: 16),

            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.comfortaa(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: GoogleFonts.comfortaa(
                      fontSize: 12,
                      color: AppColors.deepNavy.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.deepNavy.withValues(alpha: 0.3),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _CloseButton({required this.onPressed});

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 4 : 0, 0),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.deepNavy,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.deepNavy, width: 3),
          boxShadow: _isPressed
              ? []
              : [
                  const BoxShadow(
                    color: AppColors.deepNavy,
                    offset: Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.close_rounded, color: AppColors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              'CLOSE',
              style: GoogleFonts.comfortaa(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Eco Part Guide Dialog
class _EcoPartGuideDialog extends StatelessWidget {
  const _EcoPartGuideDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.deepNavy, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepNavy.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.green,
                    AppColors.green.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'ECO PART GUIDE',
                    style: GoogleFonts.comfortaa(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GuideSection(
                      icon: Icons.swipe_rounded,
                      title: 'Controls',
                      description:
                          'Tap or drag anywhere on the screen to move your submarine up and down. Avoid obstacles and collect trash!',
                    ),
                    const SizedBox(height: 20),
                    _GuideSection(
                      icon: Icons.delete_outline_rounded,
                      title: 'Collect Trash',
                      description:
                          'Collect bottles, bags, and tires floating in the ocean. Each type gives different points. Clean up the ocean!',
                    ),
                    const SizedBox(height: 20),
                    _GuideSection(
                      icon: Icons.warning_amber_rounded,
                      title: 'Avoid Obstacles',
                      description:
                          'Watch out for fish, rocks, and jellyfish! Hitting them damages your submarine and reduces your score.',
                    ),
                    const SizedBox(height: 20),
                    _GuideSection(
                      icon: Icons.favorite_rounded,
                      title: 'Health Kits',
                      description:
                          'Collect green health kits to restore your submarine\'s health. Keep your hearts full to survive!',
                    ),
                    const SizedBox(height: 20),
                    _GuideSection(
                      icon: Icons.star_rounded,
                      title: 'Earn Stars',
                      description:
                          'Complete levels and collect trash to earn stars. Get 3 stars by collecting 90% or more of all trash!',
                    ),
                  ],
                ),
              ),
            ),

            // Close button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepNavy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'GOT IT!',
                    style: GoogleFonts.comfortaa(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
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

class _GuideSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _GuideSection({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.comfortaa(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.comfortaa(
                  fontSize: 13,
                  color: AppColors.deepNavy.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Privacy Policy Dialog
class _PrivacyPolicyDialog extends StatelessWidget {
  const _PrivacyPolicyDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 450),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.deepNavy, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepNavy.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.deepNavy,
                    AppColors.deepNavy.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.privacy_tip_rounded,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'PRIVACY POLICY',
                    style: GoogleFonts.comfortaa(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Privacy Matters',
                      style: GoogleFonts.comfortaa(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Eco Hero is committed to protecting your privacy. Here\'s what you need to know:',
                      style: GoogleFonts.comfortaa(
                        fontSize: 14,
                        color: AppColors.deepNavy.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _PrivacyItem(
                      icon: Icons.storage_rounded,
                      title: 'Local Data Only',
                      description:
                          'All game progress, settings, and preferences are stored locally on your device. We do not collect or transmit any personal data.',
                    ),
                    const SizedBox(height: 16),
                    _PrivacyItem(
                      icon: Icons.cloud_off_rounded,
                      title: 'No Internet Required',
                      description:
                          'Eco Hero works completely offline. No account creation or internet connection is needed to play.',
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.eco_rounded,
                            color: AppColors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Play with peace of mind and help save our oceans!',
                              style: GoogleFonts.comfortaa(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Close button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepNavy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'CLOSE',
                    style: GoogleFonts.comfortaa(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
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

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.comfortaa(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.comfortaa(
                  fontSize: 12,
                  color: AppColors.deepNavy.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
