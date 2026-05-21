// lib/features/auth/presentation/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translations.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/providers/language_provider.dart';
import '../providers/admin_auth_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) async {
    final adminProvider = context.read<AdminAuthProvider>();
    await adminProvider.logoutAdmin();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Dashboard'),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: () => showLanguageSelector(context),
                tooltip: 'Select Language / اختر اللغة / Sélectionner la langue',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Consumer<AdminAuthProvider>(
                    builder: (context, adminProvider, _) {
                      return Text(
                        'Admin: ${adminProvider.adminName ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _handleLogout(context),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome to Admin Panel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Verify and manage patient assessments',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Stats
                  _buildStatsSection(context),
                  const SizedBox(height: 24),

                  // Features Section
                  Text(
                    'Management Features',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),

                  // View Assessments Button
                  _buildFeatureCard(
                    context,
                    icon: Icons.assessment,
                    title: 'Patient Assessments',
                    description: 'View all patient assessment results and verify data',
                    onTap: () => Navigator.of(context).pushNamed('/assessment_list'),
                  ),
                  const SizedBox(height: 12),

                  // Statistics Button
                  _buildFeatureCard(
                    context,
                    icon: Icons.bar_chart,
                    title: 'Assessment Statistics',
                    description: 'View aggregated data and trends',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  // Reports Button
                  _buildFeatureCard(
                    context,
                    icon: Icons.description,
                    title: 'Generate Reports',
                    description: 'Create and export patient reports',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  // Settings Button
                  _buildFeatureCard(
                    context,
                    icon: Icons.settings,
                    title: 'Admin Settings',
                    description: 'Configure system settings and preferences',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(context, '0', 'Total Patients'),
          _buildStatCard(context, '0', 'Assessments'),
          _buildStatCard(context, '0', 'This Month'),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
