import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/core/constants/category_enum.dart';
import 'package:inovola_flutter_task/core/theme/app_theme.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/bloc/filter/filter_cubit.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/balance_card_widget.dart';
import 'package:inovola_flutter_task/features/expenses/presentation/widgets/filter_widget.dart';

class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;

  HomeHeaderDelegate({required this.minExtent, required this.maxExtent});

  @override
  Widget build(BuildContext context, _, _) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: kBottomNavigationBarHeight + 20,
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/33.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Ahmed Sabahi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const Dialog(child: FilterWidget()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      BlocBuilder<FilterCubit, FilterType>(
                        builder: (context, currentFilter) {
                          return Text(
                            currentFilter.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment(0, 2.5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: BalanceCardWidget(),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate _) => true;
}
