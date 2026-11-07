
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'resume_analyzer_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon!')),
    );
  }

  Widget featureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color background,
    required Color iconColor,
    required bool isWide,
  }) {
    final iconBox = Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: iconColor, size: 25),
    );

    final details = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF302447),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            maxLines: isWide ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              height: 1.4,
              color: Color(0xFF665D73),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Explore',
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                color: iconColor,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
  if (title == 'AI Resume Analyzer') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResumeAnalyzerScreen(),
      ),
    );
  } else {
    showComingSoon(context, title);
  }
},
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: iconColor.withValues(alpha: 0.12),
          ),
        ),
        child: isWide
            ? Row(
                children: [
                  iconBox,
                  const SizedBox(width: 13),
                  details,
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  iconBox,
                  const SizedBox(height: 12),
                  details,
                ],
              ),
      ),
    );
  }

  Widget sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF302447),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget featureGrid(
    BuildContext context,
    bool isWide,
    List<Widget> cards,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 13,
      mainAxisSpacing: 13,
      childAspectRatio: isWide ? 2.5 : 0.95,
      children: cards,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name']?.toString();
    final name = fullName?.isNotEmpty == true
        ? fullName!
        : user?.email?.split('@').first ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2EEFA),
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              height: 37,
              width: 37,
              decoration: BoxDecoration(
                color: const Color(0xFFE7DCFA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Color(0xFF7651B5),
                size: 23,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'PrepMate AI',
              style: TextStyle(
                color: Color(0xFF49316F),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            tooltip: 'Logout',
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xFF7651B5),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 650;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1050),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(23),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF8060C5),
                            Color(0xFFB29AE9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'YOUR CAREER JOURNEY',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Hello, $name! 👋',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ready to prepare for your dream career?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 17),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.rocket_launch_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Let’s get interview-ready!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    sectionTitle(
                      '01. Resume & Career Preparation',
                      'Build a strong profile and prepare for opportunities.',
                    ),
                    const SizedBox(height: 15),
                    featureGrid(
                      context,
                      isWide,
                      [
                        featureCard(
                          context: context,
                          icon: Icons.description_rounded,
                          title: 'AI Resume Analyzer',
                          description:
                              'Check your ATS score, find missing skills and improve your resume.',
                          background: const Color(0xFFF0E9FF),
                          iconColor: const Color(0xFF7952BB),
                          isWide: isWide,
                        ),
                        featureCard(
                          context: context,
                          icon: Icons.menu_book_rounded,
                          title: 'Interview Preparation',
                          description:
                              'Get AI-generated interview questions based on your target role.',
                          background: const Color(0xFFE8F1FF),
                          iconColor: const Color(0xFF477CC0),
                          isWide: isWide,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    sectionTitle(
                      '02. Practice & Performance',
                      'Practice confidently and track your improvement.',
                    ),
                    const SizedBox(height: 15),
                    featureGrid(
                      context,
                      isWide,
                      [
                        featureCard(
                          context: context,
                          icon: Icons.record_voice_over_rounded,
                          title: 'Mock Interviews',
                          description:
                              'Practice text and voice interviews with AI feedback.',
                          background: const Color(0xFFE5F7ED),
                          iconColor: const Color(0xFF398C61),
                          isWide: isWide,
                        ),
                        featureCard(
                          context: context,
                          icon: Icons.analytics_rounded,
                          title: 'Performance Reports',
                          description:
                              'Review your scores, interview history and progress.',
                          background: const Color(0xFFFFEEE4),
                          iconColor: const Color(0xFFC77949),
                          isWide: isWide,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE6FA),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: Color(0xFF7651B5),
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your future starts here!',
                                  style: TextStyle(
                                    color: Color(0xFF49316F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Learn, practice and become interview-ready with PrepMate AI.',
                                  style: TextStyle(
                                    color: Color(0xFF65577B),
                                    fontSize: 11,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF7651B5),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (index) {
          const labels = ['Home', 'Resume', 'Practice', 'Profile'];

          if (index != 0) {
            showComingSoon(context, labels[index]);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Resume',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_none_rounded),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
