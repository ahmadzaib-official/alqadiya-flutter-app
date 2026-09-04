#!/bin/bash
# Rename c.dart
mv "lib/features/transactions/screen/ c.dart" lib/features/transactions/screen/transaction_receipt_screen.dart

# Rename providers to controllers
for file in $(find lib -name "*_provider.dart"); do
  new_file="${file/_provider.dart/_controller.dart}"
  mv "$file" "$new_file"
done

# Update imports for c.dart
find lib -type f -name "*.dart" -exec perl -pi -e 's/screen\/ c\.dart/screen\/transaction_receipt_screen.dart/g' {} +

# Update imports for providers
find lib -type f -name "*.dart" -exec perl -pi -e 's/_provider\.dart/_controller.dart/g' {} +

echo "Renamed c.dart and providers, and updated imports."
