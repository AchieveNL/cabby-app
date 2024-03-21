import 'package:cabby/state/app_provider.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      'image': "assets/svg/Book Lovers.svg",
      'title': "Premium Rental Cabs",
      'description':
          "As a cab driver, you depend on having a reliable vehicle to do your job. Cabby can help you get back on the road quickly and easily, with our all-electric rental cabs available for short-term use."
    },
    {
      'image': "assets/svg/Busy businessman crossing road.svg",
      'title': "Your One-Stop Car Rental Solution",
      'description':
          "Finding a temporary vehicle for work can be a hassle. Rent one of our premium cars and start earning money right away."
    },
    {
      'image': "assets/svg/Building Website.svg",
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
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
                ? 'Begin'
                : 'Volgende',
            onPressed: currentIndex == onboardingPages.length - 1
                ? () async {
                    final appProvider =
                        Provider.of<AppProvider>(context, listen: false);
                    await appProvider.markOnboardingAsSeen();
                    Navigator.of(context).pushReplacementNamed("/login");
                  }
                : () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
          ),
          const SizedBox(height: 15),
          currentIndex == onboardingPages.length - 1
              ? const SizedBox.shrink()
              : SecondaryButton(
                  width: size.width * 0.9,
                  height: 50,
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed("/login"),
                  btnText: "Overslaan",
                ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
