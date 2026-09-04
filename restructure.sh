#!/bin/bash

# Move directories
mv lib/features/notifcation lib/features/notification
mv lib/features/casestore lib/features/case_store
mv lib/features/onboard lib/features/onboarding

# Find all dart files and replace imports using perl for fast inplace replacement
find lib -type f -name "*.dart" -exec perl -pi -e 's/features\/notifcation/features\/notification/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/features\/casestore/features\/case_store/g' {} +
find lib -type f -name "*.dart" -exec perl -pi -e 's/features\/onboard/features\/onboarding/g' {} +

echo "Directories renamed and imports updated."
