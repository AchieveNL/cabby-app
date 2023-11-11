import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

var loggerLn = Logger();

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _messageController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;
  Stream<List<Map<String, dynamic>>>? _messageStream;
  String? _adminUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAdminUserId();
    });
  }

  void _fetchAdminUserId() async {
    try {
      final response = await _supabaseClient
          .from('CustomerSupportRepresentative')
          .select('userId')
          .single();
      logger(response);
      ;
      if (response != null && mounted) {
        setState(() {
          _adminUserId = response['userId'];
          _initializeMessageStream();
        });
      }
    } catch (error) {
      logger('Error fetching admin user ID: $error');
      return;
    }
  }

  void _initializeMessageStream() {
    final String currentUserId =
        provider.Provider.of<UserProvider>(context, listen: false).user!.id;

    _messageStream = _supabaseClient
        .from('message')
        .stream(primaryKey: ['id'])
        .order('createdAt', ascending: true)
        .map((List<Map<String, dynamic>> dataList) {
          var filteredData = dataList.where((message) {
            bool isCurrentUserIdInvolved =
                message['senderId'] == currentUserId ||
                    message['recipientId'] == currentUserId;
            return isCurrentUserIdInvolved;
          }).toList();
          var filteredAndSortedData = filteredData
            ..sort((a, b) => DateTime.parse(a['createdAt'])
                .compareTo(DateTime.parse(b['createdAt'])));
          return filteredAndSortedData;
        });

    setState(() {});
  }

  void _sendMessage() async {
    logger(_messageController.text);
    if (_messageController.text.isNotEmpty && _adminUserId != null) {
      logger(_adminUserId);
      final senderId =
          provider.Provider.of<UserProvider>(context, listen: false).user!.id;
      const uuid = Uuid();

      try {
        await _supabaseClient.from('message').insert({
          'id': uuid.v4(),
          'content': _messageController.text,
          'senderId': senderId,
          'recipientId': _adminUserId,
        });
        _messageController.clear();
      } catch (e) {
        logger('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.userProfile;
          return user == null
              ? const Center(child: Text('User profile not available!'))
              : Container(
                  decoration: DecorationBoxes.decorationBackground(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(screenSize, user.fullName),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(
                            bottom: 80,
                          ),
                          child: StreamBuilder<List<Map<String, dynamic>>>(
                            stream: _messageStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                logger(snapshot.error);
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No messages yet.'));
                              }

                              final messages = snapshot.data!
                                ..sort((a, b) => DateTime.parse(a['createdAt'])
                                    .compareTo(DateTime.parse(b['createdAt'])));
                              loggerLn.i(messages);
                              return ListView.builder(
                                reverse:
                                    false, // Changed this to false to not reverse the order
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message =
                                      messages[index]; // Directly use index
                                  final bool isSentByMe = message['senderId'] ==
                                      provider.Provider.of<UserProvider>(
                                        context,
                                      ).user!.id;
                                  return _buildMessageTile(message, isSentByMe);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
      bottomSheet: _buildMessageInputField(),
    );
  }

  Widget _buildHeader(Size screenSize, String name) {
    return Column(
      children: [
        SizedBox(height: screenSize.height * 0.1),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $name,',
                style:
                    const TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'How Can I help you today?',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }

  Widget _buildMessageTile(Map<String, dynamic> message, bool isSentByMe) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isSentByMe ? AppColors.primaryLightColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['content'],
              style: TextStyle(
                fontSize: 16.0,
                color: isSentByMe ? AppColors.whiteColor : AppColors.blackColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                Utils.formatDateTime(message['createdAt']),
                style: TextStyle(
                  fontSize: 12.0,
                  color:
                      isSentByMe ? AppColors.whiteColor : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: AppColors.whiteColor),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: DecorationInputs.textBoxInputDecoration(
                  label: 'Type your message...'),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.primaryColor,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/send.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
