import 'package:cafeconhuellas_front/models/donation.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen that displays a list of donations.
///
/// - Regular users see only their own donations.
/// - Admin users see all donations in the system.
///
/// It also includes the application's shared
/// header and footer components.
class MyDonationsScreen extends StatelessWidget {

  /// Optional API connector instance.
  ///
  /// Allows injecting a mock connector for testing purposes.
  /// Defaults to [ApiConector] if not provided.
  final ApiConector? api;

  /// Creates the donations list screen widget.
  const MyDonationsScreen({super.key, this.api});

  /// Builds the donations screen UI.
  ///
  /// Layout structure:
  /// - Application header.
  /// - Banner image.
  /// - Screen title (dynamic based on user role).
  /// - Donation list loaded asynchronously via [FutureBuilder].
  /// - Application footer.
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final bool isAdmin = authState.user?.role.toUpperCase() == 'ADMIN';
    final _api = api ?? ApiConector();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Shared application header.
            AppHeader(),
            /// Main banner image.
            Image.asset('assets/images/banners/banner-inicio.png',width: double.infinity, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 40),
            /// Screen title, dynamic based on user role.
            Text(
              isAdmin ? 'Todas las Donaciones' : 'Mis Donaciones',
              style: const TextStyle(
                fontSize: 36,
                fontFamily: 'MilkyVintage',
                color: Color(0xFF7B3FE4),
              ),
            ),
            const SizedBox(height: 24),
            /// Donation list loaded asynchronously.
            ///
            /// Calls [getDonations] for admin users,
            /// or [getMeDonation] for regular users.
            FutureBuilder<List<Donation>>(
              future: isAdmin
                  ? _api.getDonations()
                  : _api.getMeDonation(),
              builder: (context, snapshot) {
                /// Loading state.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(color: Color(0xFF7B3FE4)),
                  );
                }
                /// Error state.
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)),
                  );
                }
                final donations = snapshot.data ?? [];
                /// Empty state.
                if (donations.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No hay donaciones disponibles.'),
                  );
                }
                /// Donation list.
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: donations.map((d) => _donationCard(d)).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            /// Shared application footer.
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  /// Creates a styled card that displays a single donation entry.
  ///
  /// Shows:
  /// - Donation amount.
  /// - Category and payment method.
  /// - Optional notes.
  /// - Submission date.
  Widget _donationCard(Donation d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade100),
        boxShadow: [
          BoxShadow(color: Colors.purple.withOpacity(0.06),
              blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          /// Donation icon avatar.
          CircleAvatar(
            backgroundColor: const Color(0xFF7B3FE4),
            child: const Icon(Icons.volunteer_activism, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Donation amount.
                Text('${d.amount} €',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                /// Category and payment method.
                Text('${d.category} · ${d.method}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                /// Optional notes.
                if (d.notes.isNotEmpty)
                  Text(d.notes,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          /// Submission date.
          Text(
            '${d.date.day.toString().padLeft(2, '0')}/'
            '${d.date.month.toString().padLeft(2, '0')}/'
            '${d.date.year}',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}