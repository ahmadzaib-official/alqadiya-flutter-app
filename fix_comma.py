import re

with open('lib/features/game/screen/evidence_list_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("                                        )\n                                        if (isLocked)", "                                        ),\n                                        if (isLocked)")

with open('lib/features/game/screen/evidence_list_screen.dart', 'w') as f:
    f.write(content)
