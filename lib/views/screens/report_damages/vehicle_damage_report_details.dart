import 'package:cabby/config/formatters.dart';
import 'package:cabby/config/theme.dart';
import 'package:cabby/models/damage_report.dart';
import 'package:cabby/views/screens/image_viewer_screen.dart';
import 'package:cabby/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleDamageReportDetails extends StatefulWidget {
  final DamageReport damageReport;
  const VehicleDamageReportDetails({super.key, required this.damageReport});

  @override
  State<VehicleDamageReportDetails> createState() =>
      _VehicleDamageReportDetailsState();
}

class _VehicleDamageReportDetailsState
    extends State<VehicleDamageReportDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(
        context: context,
        title: 'Details van de schaderapport',
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryLightColor,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReportDateSection(widget.damageReport),
                _buildImagesSection(widget.damageReport),
                _buildDescriptionSection(widget.damageReport),
                _buildRepairInfoSection(widget.damageReport),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportDateSection(DamageReport report) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gemeld op:',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMMM d, y', 'nl_NL')
                .format(DateTime.parse(report.reportedAt)),
            style:
                const TextStyle(fontSize: 16, color: AppColors.darkGreyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection(DamageReport report) {
    return Column(
      children: report.images.map((image) {
        return GestureDetector(
          onTap: () => _navigateToImageViewer(image),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(image,
                  height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionSection(DamageReport report) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schadebeschrijving',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            report.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkGreyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToImageViewer(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageViewerScreen(imageUrl: imageUrl),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    Color textColor;

    switch (status) {
      case 'REPAIRED':
        badgeColor = const Color.fromARGB(255, 220, 255, 214);
        textColor = const Color.fromARGB(255, 91, 188, 75);
        break;
      case 'UNDERPAID': // Assuming 'UNDERPAID' means under repair
        badgeColor = const Color.fromARGB(255, 255, 212, 212);
        textColor = const Color.fromARGB(255, 217, 32, 55);
        break;
      default:
        badgeColor = Colors.grey;
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRepairInfoSection(DamageReport report) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the table
          borderRadius: BorderRadius.circular(8), // Border radius
          border: Border.all(
              color: Colors.grey[300]!, width: 1), // Border color and width
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              8), // To ensure the inner content also gets clipped
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow('Herstelstatus', _buildStatusBadge(report.status)),
              _buildTableRow(
                'Gerepareerd op',
                Text(
                  report.repairedAt != null
                      ? DateFormat('MMMM d, y', 'nl_NL')
                          .format(DateTime.parse(report.repairedAt!))
                      : 'N/A',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              _buildTableRow(
                'reparatiekosten',
                Text(
                  report.amount != null
                      ? euroFormat.format(report.amount)
                      : 'N/A',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String title, Widget content) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content,
            ],
          ),
        ),
      ],
    );
  }
}
