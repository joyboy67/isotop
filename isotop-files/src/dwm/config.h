/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "DejaVuSansMono:size=10" };
static const char dmenufont[]       = "DejaVuSansMono:size=10";
static const char col_bg[]          = "#2e3440";
static const char col_fg[]          = "#d8dee9";
static const char col_border[]      = "#4c566a";
static const char col_selbg[]       = "#81a1c1";
static const char col_selfg[]       = "#2e3440";
static const char col_selborder[]   = "#bf616a";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_fg, col_bg, col_border },
	[SchemeSel]  = { col_selfg, col_selbg,  col_selborder  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ NULL,               NULL,   "glxgears",    0,          1,    -1 },
	{ NULL,               NULL,   "xmessage",    0,          1,    -1 },
	{ "Dunst",            NULL,   NULL,          0,          1,    -1 },
	{ "manisotop",        NULL,   NULL,          0,          1,    -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle }, /* click on symbol to set monocle : 2nd entry*/
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "DD",       doubledeck },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "bdmenu", NULL };
static const char *termcmd[]  = { "term", NULL };

/* custom funcs definition */
void resetnmaster(const Arg *arg);

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	/** u is closer to "i" than d to decrease nmaster **/
	{ MODKEY,                       XK_u,      incnmaster,     {.i = -1 } },
	/** custom func to reset nmaster **/
	{ MODKEY,                       XK_o,      resetnmaster,   {0} },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	/* monocle with Mod-z : all layout on the left */
	{ MODKEY,                       XK_z,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_d,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },

	/* easier shortcuts */
	{ MODKEY,                       XK_F4,     killclient,     {0} },
	{ MODKEY,                       XK_F2,     spawn,          {.v = dmenucmd } },

	/* azerty */
	{ MODKEY,                       XK_semicolon,   focusmon,  {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_semicolon,   tagmon,    {.i = +1 } },
	{ MODKEY,                       XK_agrave,      view,      {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_agrave,      tag,       {.ui = ~0 } },
	TAGKEYS(                        XK_ampersand,              0)
	TAGKEYS(                        XK_eacute,                 1)
	TAGKEYS(                        XK_quotedbl,               2)
	TAGKEYS(                        XK_apostrophe,             3)
	TAGKEYS(                        XK_parenleft,              4)
	TAGKEYS(                        XK_minus,                  5)
	TAGKEYS(                        XK_egrave,                 6)
	TAGKEYS(                        XK_underscore,             7)
	TAGKEYS(                        XK_ccedilla,               8)

	/* shortcuts */
	{ MODKEY,                     XK_equal,      spawn,      SHCMD("sndioctl -q output.level=+0.1") },
	{ MODKEY,                     XK_parenright, spawn,      SHCMD("sndioctl -q output.level=-0.1") },
	{ MODKEY,                     XK_s,          spawn,      SHCMD("dsch") },
	{ MODKEY,                     XK_w,          spawn,      SHCMD("dloadbmk") },
	{ MODKEY,                     XK_q,          spawn,      SHCMD("dmpc") },
	{ MODKEY|ControlMask,         XK_h,          spawn,      SHCMD("mpc prev") },
	{ MODKEY|ControlMask,         XK_j,          spawn,      SHCMD("mpc toggle") },
	{ MODKEY|ControlMask,         XK_k,          spawn,      SHCMD("mpc play") },
	{ MODKEY|ControlMask,         XK_l,          spawn,      SHCMD("mpc next") },
	{ MODKEY|ShiftMask,           XK_Delete,     spawn,      SHCMD("xlock") },
	{ MODKEY|ShiftMask,           XK_Delete,     spawn,      SHCMD("xlock") },
	{ 0,                          XK_Print,      spawn,      SHCMD("dshot") },

	/* focusmaster patch Mod-m */
	{ MODKEY,                     XK_m,  focusmaster,    {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
	/* isotop */
	/* scroll or left click change window */
	{ ClkWinTitle,          0,              Button1,        focusstack,     {.i = +1 } },
	{ ClkWinTitle,          0,              Button4,        focusstack,     {.i = +1 } },
	{ ClkWinTitle,          0,              Button5,        focusstack,     {.i = -1 } },
	/* right click on title = close */
	{ ClkWinTitle,          0,              Button3,        killclient,     {0} },
	/* scroll on status : change volume */
	{ ClkStatusText,        0,              Button4,        spawn,          SHCMD("sndioctl -q output.level=+0.1") },
	{ ClkStatusText,        0,              Button5,        spawn,          SHCMD("sndioctl -q output.level=-0.1") },
	/* on status and background: 
	 *   left or right-click : menu
	 */
	{ ClkStatusText,        0,              Button3,        spawn,          SHCMD("sessionmenuisotop") },
	{ ClkStatusText,        0,              Button1,        spawn,          SHCMD("ddesktop") },
	{ ClkRootWin,           0,              Button3,        spawn,          SHCMD("sessionmenuisotop") },
	{ ClkRootWin,           0,              Button1,        spawn,          SHCMD("ddesktop") },
};

/* custom funcs */
void
resetnmaster(const Arg *arg)
{
	selmon->nmaster = 1;
	arrange(selmon);
}
