# Form validation: acceptance criteria

Requirement: instead of silently disabling Save entry, the form must tell the user what is wrong. Notes may be at most 2000 characters.

1. Given no score is selected, when I tap Save entry, then the message "Choose a score from 1 to 10" appears and nothing is added to the history.

2. Given a score is selected and the note is 2001 characters, when I tap Save entry, then the message "Note must be at most 2000 characters" appears and nothing is added to the history.

3. Given a score is selected and the note is exactly 2000 characters, when I tap Save entry, then the entry is added to the history and no error appears.

4. Given a score is selected and the note is left empty, when I tap Save entry, the entry is added with no note, and no error appears.