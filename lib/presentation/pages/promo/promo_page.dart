import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/feature_icon.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final promos = [
      {
        't': 'Cashback 30% at campus canteen',
        'd': 'Max. Rp10,000 · until Jun 30',
        'tone': 'red',
        'icon': Icons.restaurant_outlined
      },
      {
        't': 'Free inter-bank transfer fee',
        'd': 'Every Friday · all banks',
        'tone': 'green',
        'icon': Icons.send_rounded
      },
      {
        't': '0% UKT discount, 6-month installment',
        'd': 'New users only',
        'tone': 'violet',
        'icon': Icons.receipt_long_outlined
      },
      {
        't': 'Bonus 5,000 points on first top-up',
        'd': 'Min. Rp50,000',
        'tone': 'amber',
        'icon': Icons.star_outline_rounded
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).padding.top + 14, 20, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Deals',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.5,
                        )),
                    SizedBox(height: 2),
                    Text('Exclusive for campus students',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          color: AppColors.slate400,
                        )),
                  ],
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F1FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_outlined,
                      color: Color(0xFF6C5CE7), size: 20),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                // Hero card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(24),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -40,
                          bottom: -50,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('✦ STUDENT SPECIAL',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFFD97D),
                                  letterSpacing: 1,
                                )),
                            const SizedBox(height: 10),
                            const Text('Pay tuition,\nget cashback 💸',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.3,
                                )),
                            const SizedBox(height: 6),
                            const Text('Earn points on every transaction.',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 13,
                                  color: Colors.white54,
                                )),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Claim now',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF6C5CE7),
                                      )),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded,
                                      size: 13, color: Color(0xFF6C5CE7)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Section label
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text('ACTIVE PROMOS',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate400,
                        letterSpacing: 0.9,
                      )),
                ),

                // Promo list — grouped card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Column(
                      children: List.generate(promos.length, (i) {
                        final p = promos[i];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: i < promos.length - 1
                                  ? BorderSide(color: AppColors.line2, width: 1)
                                  : BorderSide.none,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              FeatureIcon(
                                icon: p['icon'] as IconData,
                                tone: p['tone'] as String,
                                size: 44,
                                iconSize: 22,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p['t'] as String,
                                        style: const TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                          height: 1.3,
                                        )),
                                    const SizedBox(height: 2),
                                    Text(p['d'] as String,
                                        style: const TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 12,
                                          color: AppColors.slate400,
                                        )),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: Color(0xFFD8D8E8), size: 20),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
