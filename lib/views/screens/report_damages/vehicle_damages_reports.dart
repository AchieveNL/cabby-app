import 'package:cabby/config/theme.dart';
import 'package:cabby/models/damage_report.dart';
import 'package:cabby/services/damage_report.dart';
import 'package:cabby/views/screens/report_damages/vehicle_damage_report_details.dart';
import 'package:cabby/views/widgets/app_bar.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class VehicleDamageReports extends StatefulWidget {
  final String vehicleId;
  const VehicleDamageReports({super.key, required this.vehicleId});

  @override
  State<VehicleDamageReports> createState() => _VehicleDamageReportsState();
}

class _VehicleDamageReportsState extends State<VehicleDamageReports> {
  List<DamageReport> damageReports = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDamageReports();
  }

  void _fetchDamageReports() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      damageReports =
          await DamageReportService().fetchDamageReports(widget.vehicleId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(
        context: context,
        title: 'Schaderapporten',
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
          padding: const EdgeInsets.all(15),
          child: isLoading
              ? _buildLoadingUI()
              : errorMessage != null
                  ? _buildErrorUI()
                  : damageReports.isNotEmpty
                      ? _buildReportsUI()
                      : _buildEmptyMessageUI(),
        ),
      ),
    );
  }

  Widget _buildLoadingUI() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: .6,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 132,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey[300],
                    width: 150,
                    height: 15,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.grey[300],
                    width: 100,
                    height: 15,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.grey[300],
                    width: 120,
                    height: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Text(errorMessage ?? 'Een onbekende fout is opgetreden'),
    );
  }

  Widget _buildEmptyMessageUI() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "🚗🛠️ Geen schaderapporten gevonden! 🛠️🚗",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Dit voertuig verkeert in uitstekende staat! ✨ \n Houd de schaderapporten in de gaten voor toekomstige updates.🌟",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsUI() {
    return SingleChildScrollView(
      child: Column(
        children: damageReports
            .map((report) => _buildDamageReportCard(report))
            .toList(),
      ),
    );
  }

  Widget _buildDamageReportCard(DamageReport report) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: .6,
        ),
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Gemeld op:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              DateFormat('MMMM d, y', 'nl_NL')
                  .format(DateTime.parse(report.reportedAt)),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            if (report.images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  report.images[0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Schadebeschrijving",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    report.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SecondaryButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) =>
                      VehicleDamageReportDetails(damageReport: report),
                );
                Navigator.push(context, route);
              },
              width: double.infinity,
              btnText: 'Details bekijken',
            ),
          ],
        ),
      ),
    );
  }
}
