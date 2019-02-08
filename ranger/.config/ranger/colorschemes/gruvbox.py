from __future__ import absolute_import, division, print_function

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import normal, bold, reverse, BRIGHT, default_colors


GB_GRAY_245 = 245
GB_GRAY_246 = 246

GB_BG0_SOFT = 236
GB_BG0 = 235
GB_BG0_HARD = 234
GB_BG1 = 237
GB_BG2 = 239
GB_BG3 = 241
GB_BG4 = 243
GB_BG = GB_BG0

GB_FG0 = 229
GB_FG1 = 223
GB_FG2 = 250
GB_FG3 = 248
GB_FG4 = 246
GB_FG = GB_FG1

GB_NEUTRAL_RED = 124
GB_BRIGHT_RED = 167
GB_NEUTRAL_GREEN = 106
GB_BRIGHT_GREEN = 142
GB_NEUTRAL_YELLOW = 172
GB_BRIGHT_YELLOW = 214
GB_NEUTRAL_BLUE = 66
GB_BRIGHT_BLUE = 109
GB_NEUTRAL_PURPLE = 132
GB_BRIGHT_PURPLE = 175
GB_BRIGHT_AQUA = 72
GB_NEUTRAL_AQUA = 108
GB_NEUTRAL_ORANGE = 166
GB_BRIGHT_ORANGE = 208

# TERM
T_BLACK = GB_BG0
T_GRAY = GB_GRAY_245
T_RED = GB_NEUTRAL_RED
T_BRIGHT_RED = GB_BRIGHT_RED
T_GREEN = GB_NEUTRAL_GREEN
T_BRIGHT_GREEN = GB_BRIGHT_GREEN
T_YELLOW = GB_NEUTRAL_YELLOW
T_BRIGHT_YELLOW = GB_BRIGHT_YELLOW
T_BLUE = GB_NEUTRAL_BLUE
T_BRIGHT_BLUE = GB_BRIGHT_BLUE
T_PURPLE = GB_NEUTRAL_PURPLE
T_BRIGHT_PURPLE = GB_BRIGHT_PURPLE
T_AQUA = GB_NEUTRAL_AQUA
T_BRIGHT_AQUA = GB_BRIGHT_AQUA
T_WHITE = GB_FG4
T_BRIGHT_WHITE = GB_FG1


class Default(ColorScheme):
    progress_bar_color = T_BLUE

    def use(
        self, context
    ):  # pylint: disable=too-many-branches,too-many-statements
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        # Browser
        if context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal

            if context.empty or context.error:
                bg = T_RED
            if context.border:
                fg = T_GREEN

            if context.container:
                fg = T_RED

            # Directory
            if context.directory:
                attr |= bold
                fg = T_BRIGHT_BLUE
            # File
            elif context.file:
                fg = T_GREEN
                # Media
                if context.media:
                    if context.image:
                        fg = T_YELLOW
                    else:
                        fg = T_PURPLE
                # Executable
                if context.executable and not any(
                    (
                        context.media,
                        context.container,
                        context.fifo,
                        context.socket,
                    )
                ):
                    attr |= bold
                    fg = T_BRIGHT_GREEN
                elif context.document:
                    fg = T_BRIGHT_WHITE
                if context.socket:
                    attr |= bold
                    fg = T_BRIGHT_PURPLE
                if context.fifo or context.device:
                    fg = T_YELLOW
                    if context.device:
                        attr |= bold
                        fg = T_BRIGHT_YELLOW
                if context.link:
                    fg = T_BRIGHT_PURPLE if context.good else T_BRIGHT_RED

            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (T_RED, T_PURPLE):
                    fg = T_BRIGHT_WHITE
                else:
                    fg = T_BRIGHT_RED
            if not context.selected and (context.cut or context.copied):
                attr |= bold
                fg = T_GRAY
            if context.main_column:
                # Doubling up with BRIGHT here causes issues because it's
                # additive not idempotent.
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = T_YELLOW
            if context.badinfo:
                if attr & reverse:
                    bg = T_PURPLE
                else:
                    fg = T_PURPLE

            if context.inactive_pane:
                fg = T_AQUA

        elif context.in_titlebar:
            if context.hostname:
                fg = T_BRIGHT_RED if context.bad else T_BRIGHT_GREEN
            elif context.directory:
                fg = T_BRIGHT_BLUE
            elif context.tab:
                if context.good:
                    bg = T_BRIGHT_GREEN
            elif context.link:
                fg = T_BRIGHT_AQUA
            attr |= bold

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = T_AQUA
                elif context.bad:
                    fg = T_PURPLE
            if context.marked:
                attr |= bold | reverse
                fg = T_YELLOW
                fg += BRIGHT
            if context.frozen:
                attr |= bold | reverse
                fg = T_AQUA
                fg += BRIGHT
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = T_RED
                    fg += BRIGHT
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = T_BLUE
                attr &= ~bold
            if context.vcscommit:
                fg = T_YELLOW
                attr &= ~bold
            if context.vcsdate:
                fg = T_AQUA
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = T_BLUE

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = T_PURPLE
            elif context.vcsuntracked:
                fg = T_AQUA
            elif context.vcschanged:
                fg = T_RED
            elif context.vcsunknown:
                fg = T_RED
            elif context.vcsstaged:
                fg = T_GREEN
            elif context.vcssync:
                fg = T_GREEN
            elif context.vcsignored:
                fg = T_GREEN

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = T_GREEN
            elif context.vcsbehind:
                fg = T_RED
            elif context.vcsahead:
                fg = T_BLUE
            elif context.vcsdiverged:
                fg = T_PURPLE
            elif context.vcsunknown:
                fg = T_RED

        return fg, bg, attr
