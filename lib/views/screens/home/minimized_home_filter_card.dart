import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/home/filter_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';

class MinimaziedHomeFilterCard extends StatefulWidget {
  const MinimaziedHomeFilterCard({super.key});

  @override
  _MinimaziedHomeFilterCardState createState() =>
      _MinimaziedHomeFilterCardState();
}

class _MinimaziedHomeFilterCardState extends State<MinimaziedHomeFilterCard> {
  TextEditingController carSelectorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController numberController = TextEditingController(text: '1');
  TextEditingController typeController = TextEditingController(text: 'Dag(en)');

  DateTime? selectedDate;

  void _navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FilterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDatePickerWidget(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButton(
            btnText: 'Zoeken',
            radius: 10,
            width: screenSize.width * 0.95,
            onPressed: _navigate,
          ),
        ),
      ],
    );
  }

  Widget buildDatePickerWidget() {
    return TextFormField(
      controller: dateController,
      keyboardType: TextInputType.text,
      readOnly: true,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
      onTap: _navigate,
      decoration: DecorationInputs.textBoxInputDecorationWithPrefixWidget(
        label: 'dd/mm/yyyy',
        prefix: const Icon(
          Icons.calendar_today_outlined,
        ),
      ),
    );
  }

  Widget buildSpace() {
    return const SizedBox(height: 10.0);
  }
}
