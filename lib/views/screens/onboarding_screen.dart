import 'package:cabby/config/theme.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/on_boarding_page.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  List<Map<String, String>> onboardingPages = [
    {
      'image': "assets/Book Lovers.svg",
      'title': "Premium Rental Cabs",
      'description':
          "As a cab driver, you depend on having a reliable vehicle to do your job. Cabby can help you get back on the road quickly and easily, with our all-electric rental cabs available for short-term use."
    },
    {
      'image': "assets/Busy businessman crossing road.svg",
      'title': "Your One-Stop Car Rental Solution",
      'description':
          "Finding a temporary vehicle for work can be a hassle. Rent one of our premium cars and start earning money right away."
    },
    {
      'image': "assets/Building Website.svg",
      'title': "The Key to Your Next Trip",
      'description':
          "Don't let a temporary loss of your own vehicle keep you from taking on new fares. Cabby provides cab drivers with a hassle-free way to rent an all-premium cars and start making money. Book now and get back on the road to success."
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingPages.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) => OnBoardingPage(
                image: onboardingPages[index]['image']!,
                title: onboardingPages[index]['title']!,
                description: onboardingPages[index]['description']!,
              ),
            ),
          ),
          PrimaryButton(
            width: size.width * 0.9,
            height: 50,
            btnText: currentIndex == onboardingPages.length - 1
                ? 'Get Started'
                : 'Next',
            onPressed: currentIndex == onboardingPages.length - 1
                ? () => Navigator.of(context).pushReplacementNamed("/login")
                : () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
          ),
          const SizedBox(height: 15),
          currentIndex == onboardingPages.length - 1
              ? const SizedBox.shrink()
              : OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed("/login"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 1.0,
                      color: AppColors.primaryColor,
                    ),
                    fixedSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
