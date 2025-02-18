import sys
from pathlib import Path
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import ViInsertMode
from prompt_toolkit.key_binding.key_processor import KeyPress
try:
    from ptpython.repl import embed
    def configure(repl):
        # Enable Vi mode
        
        repl.vi_mode = True
        repl.insert_blank_line_after_output = False
        repl.confirm_exit = False
        repl.enable_history_search = True

        @repl.add_key_binding("j", "k", filter=ViInsertMode())
        def _(event):
            event.cli.key_processor.feed(KeyPress(Keys("escape")))
except ImportError:
    print("ptpython is not available: falling back to standard prompt")
else:
    history_filename=Path.home() / '.ptpython_history'
    history_filename.touch()
    sys.exit(embed(history_filename = history_filename, globals=globals(), locals=locals(),configure=configure))
