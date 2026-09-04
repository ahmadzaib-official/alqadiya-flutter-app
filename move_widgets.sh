#!/bin/bash
mkdir -p lib/core/widgets
mkdir -p lib/features/auth/widgets
mkdir -p lib/features/case_store/widgets
mkdir -p lib/features/game/widgets
mkdir -p lib/features/payment/widgets

# Core Widgets
mv lib/widgets/animation_entry_wrapper.dart lib/core/widgets/
mv lib/widgets/app_bar.dart lib/core/widgets/
mv lib/widgets/cahnetwork_image_component.dart lib/core/widgets/
mv lib/widgets/custom_app_widget.dart lib/core/widgets/
mv lib/widgets/custom_button.dart lib/core/widgets/
mv lib/widgets/custom_header.dart lib/core/widgets/
mv lib/widgets/custom_icon_text_button.dart lib/core/widgets/
mv lib/widgets/custom_textfield.dart lib/core/widgets/
mv lib/widgets/dense_text_field.dart lib/core/widgets/
mv lib/widgets/gradient_box_border.dart lib/core/widgets/
mv lib/widgets/spinkkit_ripple_efffect.dart lib/core/widgets/
mv lib/widgets/toaster.dart lib/core/widgets/
mv lib/widgets/social_button.dart lib/core/widgets/
mv lib/widgets/auth_required_dialog.dart lib/core/widgets/
mv lib/widgets/language_selection_bottomsheet.dart lib/core/widgets/
mv lib/widgets/language_selection_button.dart lib/core/widgets/
mv lib/widgets/language_selection_drawer.dart lib/core/widgets/
mv lib/widgets/localization_footer.dart lib/core/widgets/
mv lib/widgets/copy_code_button.dart lib/core/widgets/
mv lib/widgets/leave_dialog.dart lib/core/widgets/
mv lib/widgets/screen_mirror_guide_dialog.dart lib/core/widgets/
mv lib/widgets/cast_debug_widget.dart lib/core/widgets/
mv lib/widgets/cast_video_button.dart lib/core/widgets/
mv lib/widgets/home_header.dart lib/core/widgets/
mv lib/widgets/home_menu lib/core/widgets/

# Auth Widgets
mv lib/widgets/auth_heading.dart lib/features/auth/widgets/

# Case Store Widgets
mv lib/widgets/case_store_filter lib/features/case_store/widgets/
mv lib/widgets/case_detail_shimmer.dart lib/features/case_store/widgets/
mv lib/widgets/draggable_player_card.dart lib/features/case_store/widgets/
mv lib/widgets/available_players_section.dart lib/features/case_store/widgets/
mv lib/widgets/team_leader_card.dart lib/features/case_store/widgets/
mv lib/widgets/team_container.dart lib/features/case_store/widgets/

# Game Widgets
mv lib/widgets/game_background.dart lib/features/game/widgets/
mv lib/widgets/game_card.dart lib/features/game/widgets/
mv lib/widgets/game_card_shimmer.dart lib/features/game/widgets/
mv lib/widgets/game_footer.dart lib/features/game/widgets/
mv lib/widgets/start_play_button.dart lib/features/game/widgets/

# Payment / Transactions
mv lib/widgets/invoicePdf lib/features/payment/widgets/

# Cleanup
rm -f lib/widgets/.DS_Store
rm -f lib/core/widgets/home_menu/.DS_Store
rmdir lib/widgets

# Update imports
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/animation_entry_wrapper.dart/core\/widgets\/animation_entry_wrapper.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/app_bar.dart/core\/widgets\/app_bar.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/cahnetwork_image_component.dart/core\/widgets\/cahnetwork_image_component.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/custom_app_widget.dart/core\/widgets\/custom_app_widget.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/custom_button.dart/core\/widgets\/custom_button.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/custom_header.dart/core\/widgets\/custom_header.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/custom_icon_text_button.dart/core\/widgets\/custom_icon_text_button.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/custom_textfield.dart/core\/widgets\/custom_textfield.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/dense_text_field.dart/core\/widgets\/dense_text_field.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/gradient_box_border.dart/core\/widgets\/gradient_box_border.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/spinkkit_ripple_efffect.dart/core\/widgets\/spinkkit_ripple_efffect.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/toaster.dart/core\/widgets\/toaster.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/social_button.dart/core\/widgets\/social_button.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/auth_required_dialog.dart/core\/widgets\/auth_required_dialog.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/language_selection_bottomsheet.dart/core\/widgets\/language_selection_bottomsheet.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/language_selection_button.dart/core\/widgets\/language_selection_button.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/language_selection_drawer.dart/core\/widgets\/language_selection_drawer.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/localization_footer.dart/core\/widgets\/localization_footer.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/copy_code_button.dart/core\/widgets\/copy_code_button.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/leave_dialog.dart/core\/widgets\/leave_dialog.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/screen_mirror_guide_dialog.dart/core\/widgets\/screen_mirror_guide_dialog.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/cast_debug_widget.dart/core\/widgets\/cast_debug_widget.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/cast_video_button.dart/core\/widgets\/cast_video_button.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/home_header.dart/core\/widgets\/home_header.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/home_menu\/home_drawer_menu.dart/core\/widgets\/home_menu\/home_drawer_menu.dart/g' {} +

find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/auth_heading.dart/features\/auth\/widgets\/auth_heading.dart/g' {} +

find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/case_store_filter\/case_store_filter_drawer.dart/features\/case_store\/widgets\/case_store_filter\/case_store_filter_drawer.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/case_detail_shimmer.dart/features\/case_store\/widgets\/case_detail_shimmer.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/draggable_player_card.dart/features\/case_store\/widgets\/draggable_player_card.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/available_players_section.dart/features\/case_store\/widgets\/available_players_section.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/team_leader_card.dart/features\/case_store\/widgets\/team_leader_card.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/team_container.dart/features\/case_store\/widgets\/team_container.dart/g' {} +

find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/game_background.dart/features\/game\/widgets\/game_background.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/game_card.dart/features\/game\/widgets\/game_card.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/game_card_shimmer.dart/features\/game\/widgets\/game_card_shimmer.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/game_footer.dart/features\/game\/widgets\/game_footer.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/start_play_button.dart/features\/game\/widgets\/start_play_button.dart/g' {} +

find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/invoicePdf\/incoice_pdf.dart/features\/payment\/widgets\/invoicePdf\/incoice_pdf.dart/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/widgets\/invoicePdf\/invoice_pdf_modal.dart/features\/payment\/widgets\/invoicePdf\/invoice_pdf_modal.dart/g' {} +

echo "Widgets moved and imports updated."
