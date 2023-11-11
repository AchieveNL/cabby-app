import 'package:cabby/config/theme.dart';
import 'package:cabby/models/profile.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:cabby/views/screens/home/home_filter_card.dart';
import 'package:cabby/views/screens/home/minimized_home_filter_card.dart';
import 'package:cabby/views/screens/home/popular_vehicles.dart';
import 'package:cabby/views/screens/home/sliver_header_delegate.dart';
import 'package:cabby/views/screens/home/welcome_header.dart';
import 'package:cabby/views/screens/notification_screen.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showTitleNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showTitleNotifier.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        (MediaQuery.of(context).size.height * 0.25) - kToolbarHeight) {
      _showTitleNotifier.value = true;
    } else {
      _showTitleNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.userProfile;
          return user == null
              ? const Center(child: Text('User profile not available!'))
              : Container(
                  decoration: DecorationBoxes.decorationBackground(),
                  child: Stack(
                    children: [
                      CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          _buildSliverAppBar(screenSize, user),
                          _buildSliverPersistentHeader(screenSize),
                          _buildContentSection(),
                        ],
                      ),
                      _backToTopButton(),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _backToTopButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showTitleNotifier,
      builder: (context, showTitle, child) {
        return showTitle
            ? Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _scrollController.animateTo(
                        0.0,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                        padding: const EdgeInsets.only(left: 20, right: 20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.chevron_up,
                          color: AppColors.primaryColor,
                          size: 13,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Back to top',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildSliverAppBar(Size screenSize, UserProfileModel user) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showTitleNotifier,
      builder: (context, showTitle, child) => SliverAppBar(
        expandedHeight: screenSize.height * 0.25,
        floating: false,
        pinned: true,
        backgroundColor:
            showTitle ? AppColors.primaryLightColor : Colors.transparent,
        elevation: 0,
        title: showTitle
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${user.fullName}!'),
                  GestureDetector(
                    onTap: () {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/svg/bell.svg',
                      color: Colors.white,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              )
            : null,
        flexibleSpace: FlexibleSpaceBar(
          background: WelcomeHeader(
            screenSize: screenSize,
            userName: user.fullName,
          ),
        ),
      ),
    );
  }

  Widget _buildSliverPersistentHeader(Size screenSize) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverHeaderDelegate(
        minHeight: 80,
        maxHeight: 80,
        child: ValueListenableBuilder<bool>(
          valueListenable: _showTitleNotifier,
          builder: (context, showTitle, child) => showTitle
              ? Container(
                  decoration:
                      const BoxDecoration(color: AppColors.primaryLightColor),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.03,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: const MinimaziedHomeFilterCard(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return SliverToBoxAdapter(
      child: ValueListenableBuilder<bool>(
        valueListenable: _showTitleNotifier,
        builder: (context, showTitle, child) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: !showTitle
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )
                : BorderRadius.zero,
          ),
          child: Stack(
            children: [
              if (!showTitle)
                Transform.translate(
                  offset: const Offset(0, -190),
                  child: const HomeFilterCard(
                    isInScreen: false,
                  ),
                ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 70, 0, 50),
                child: PopularVehicles(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
