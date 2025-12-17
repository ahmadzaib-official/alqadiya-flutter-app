import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/casestore/controller/player_selection_controller.dart';
import 'package:alqadiya_game/widgets/draggable_player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TeamContainer extends StatelessWidget {
  final Team team;
  final PlayerSelectionController controller;

  const TeamContainer({Key? key, required this.team, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<Player>(
      onAccept: (player) {
        // Find which team the player is currently in
        for (var t in controller.teams) {
          if (t.hasPlayer(player.id)) {
            controller.removePlayerFromTeam(player, t);
            break;
          }
        }
        // Add to this team
        controller.addPlayerToTeam(player, team);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: MyColors.black.withValues(alpha: 0.1),
            border:
                candidateData.isNotEmpty
                    ? Border.all(color: MyColors.greenColor, width: 2.w)
                    : null,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Team name
              Text(
                team.name,
                style: AppTextStyles.heading1().copyWith(fontSize: 8.sp),
              ),
              SizedBox(height: 20.h),
              // Players horizontal scrollable list
              Expanded(
                child: Obx(
                  () =>
                      team.players.isEmpty
                          ? Center(
                            child: Text(
                              'Drop players here',
                              style: AppTextStyles.captionRegular12().copyWith(
                                color: MyColors.white.withValues(alpha: 0.4),
                                fontSize: 6.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                          : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  team.players
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => Transform.translate(
                                          offset: Offset(-8.w * entry.key, 0),
                                          child: GestureDetector(
                                            onLongPress: () {
                                              // Remove player on long press
                                              controller.removePlayerFromTeam(
                                                entry.value,
                                                team,
                                              );
                                            },
                                            child: DraggablePlayerCard(
                                              player: entry.value,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
