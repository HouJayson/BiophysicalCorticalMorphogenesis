import os
import re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# -----------------------------
# Paths
# -----------------------------
EXCEL_PATH = r"path_to_6c_radar"
OUTPUT_DIR = r"path_to_6c_radar"
OUTPUT_TIFF = os.path.join(OUTPUT_DIR, "SulcDepth_Radar_two_panels2.tiff")

# -----------------------------
# Style settings (scaled for tiny canvas)
# -----------------------------
FIGSIZE = (2.7, 1.3)   # tiny 2-panel figure
DPI = 600
FONT_FAMILY = "Arial"

# Compact typography & strokes
LABEL_FONTSIZE  = 5.5  # region labels (theta)
RTICK_FONTSIZE  = 4     # radial tick labels
LEGEND_FONTSIZE = 5.5
LINE_WIDTH      = 0.75  # series lines
GRID_WIDTH      = 0.25
MARKER_SIZE     = 1.5
OUTLINE_WIDTH   = 0.5   # outer ring

XTICK_PAD       = 2     # tighter xtick padding

SERIES_COLORS = {
    "ICT1": "#ff7f0e",
    "ICT2": "#DC0000",
    "RCT1": "#1F77B4",
    "RCT2": "#3C5488",
    "NCT" : "#7F7F7F",
}

# Which rows (cases) to plot per panel
CASES_LEFT  = ["ICT1", "RCT1", "NCT"]
CASES_RIGHT = ["ICT2", "RCT2", "NCT"]   # change if you truly want RCT2 twice

# -----------------------------
# Load and normalize table
# -----------------------------
sheet_name = "sulcDepth"   # use "sulcDepth_alpha" if needed
df = pd.read_excel(EXCEL_PATH, sheet_name=sheet_name)

# First column holds case labels (often named 'Unnamed: 0'); set it as index
label_col = df.columns[0]
df = df.rename(columns={label_col: "Case"})
df = df.set_index("Case")

# Keep only region columns R1..R18 and sort them numerically
region_cols = [c for c in df.columns if re.fullmatch(r"R\d+", str(c))]
region_cols = sorted(region_cols, key=lambda x: int(str(x)[1:]))
df = df[region_cols].apply(pd.to_numeric, errors="coerce")

# Build a normalization map for robust matching
def norm(s: str) -> str:
    s = str(s).upper().strip()
    return re.sub(r"[^A-Z0-9]", "", s)

index_map = {norm(idx): idx for idx in df.index}

# -----------------------------
# Polar coordinates
# -----------------------------
Nregions = len(region_cols)
theta = np.linspace(0, 2*np.pi, Nregions, endpoint=False)
theta_closed = np.r_[theta, theta[:1]]

# -----------------------------
# radial compression to improve readability
# -----------------------------
gamma = 1/3
rvalue = 0.95
OUTER_R = 11.0

def f(x):
    x = np.asarray(x, float)
    x = np.clip(x - rvalue, 0, None) + 1e-12
    return np.power(x, gamma)

def finv(y):
    y = np.asarray(y, float)
    return np.power(y, 1.0/gamma)

# -----------------------------
# Helpers
# -----------------------------
def get_series(case_name: str):
    key = norm(case_name)
    if key not in index_map:
        return None
    return df.loc[index_map[key], region_cols].to_numpy(dtype=float)

def plot_panel(ax, case_list, ticks_angle, title):
    # collect available series
    series = []
    found = []
    missing = []
    for c in case_list:
        s = get_series(c)
        if s is None:
            missing.append(c)
        else:
            series.append((c, s))
            found.append(c)

    if not series:
        raise ValueError(f"No requested cases found in sheet '{sheet_name}'. Missing: {missing}")

    # functional radial scale
    ax.set_rscale("function", functions=(f, finv))

    # grid & aesthetics
    ax.spines["polar"].set_visible(False)
    ax.set_rlim(0, OUTER_R)

    # outer ring
    ax.plot(
        theta_closed, np.full_like(theta_closed, OUTER_R),
        linewidth=OUTLINE_WIDTH, linestyle="-", color="black", alpha=0.8
    )

    # light grids for tiny figure
    ax.yaxis.grid(True, linewidth=GRID_WIDTH, alpha=0.7)
    ax.xaxis.grid(True, linewidth=GRID_WIDTH, alpha=0.7)

    # region labels
    ax.set_xticks(theta)

    angles_deg = np.degrees(theta)
    labels = [f"R{i+1}" for i in range(Nregions)]
    gridlines, label_texts = ax.set_thetagrids(angles_deg, labels=labels)
    for t in label_texts:
        # Force the radial position to the outer axes radius (1.0 in axes coords)
        th, _ = t.get_position()
        t.set_position((th, 0.4))
        t.set_fontsize(LABEL_FONTSIZE)

    # No extra radial padding
    ax.tick_params(axis="x", pad=0)

    # angles_deg = np.degrees(theta)
    # labels = [f"R{i+1}" for i in range(Nregions)]
    # ax.set_thetagrids(angles_deg, labels=labels) 

    # compact radial ticks (fixed, readable)
    rticks_lin = np.linspace(0, 8, 5)
    ax.set_rgrids(rticks_lin, angle=ticks_angle, fontsize=RTICK_FONTSIZE)

    # plot series
    for name, vals in series:
        vals_closed = np.r_[vals, vals[:1]]
        if norm(name) == "NCT":
            ax.fill(theta_closed, vals_closed, alpha=0.35, color=SERIES_COLORS["NCT"],
                    linewidth=0, label="NCT")
        else:
            nameU = name.upper()
            color = SERIES_COLORS.get(nameU, "#000000")
            marker = "o" if "ICT" in nameU else "s" if "RCT" in nameU else "o"
            ax.plot(
                theta_closed, vals_closed,
                linewidth=LINE_WIDTH, linestyle="-",
                marker=marker, markersize=MARKER_SIZE,
                color=color, alpha=0.9, label=name
            )

# -----------------------------
# Render
# -----------------------------
plt.rcParams.update({"font.family": FONT_FAMILY})

fig, axes = plt.subplots(
    1, 2,
    figsize=FIGSIZE, dpi=DPI,
    subplot_kw=dict(polar=True),
    gridspec_kw={"wspace": 0.05, "left": 0.05, "right": 0.95, "bottom": 0.2, "top": 0.95}
)

plot_panel(axes[0], CASES_LEFT, 120, "Regional Sulcal Depth (ICT1, RCT1, NCT)")
plot_panel(axes[1], CASES_RIGHT, 60,  "Regional Sulcal Depth (ICT2, RCT2, NCT)")

# Deduplicate & order legend
handles, labels = [], []
for ax in axes:
    h, l = ax.get_legend_handles_labels()
    handles += h; labels += l

seen = set()
uniq_handles, uniq_labels = [], []
for h, lab in zip(handles, labels):
    if lab in seen:
        continue
    seen.add(lab)
    uniq_handles.append(h)
    uniq_labels.append(lab)

order = [lbl for lbl in ["RCT1","ICT1","RCT2","ICT2","NCT"] if lbl in seen]
if order:
    map_h = {lab: h for h, lab in zip(uniq_handles, uniq_labels)}
    uniq_handles = [map_h[o] for o in order]
    uniq_labels  = order

# Compact legend; tuned paddings so it fits beneath a 1.2" tall figure
fig.legend(
    uniq_handles, uniq_labels,
    loc="lower center",
    ncol=len(uniq_labels),
    frameon=False,
    fontsize=LEGEND_FONTSIZE,
    handlelength=2,
    handletextpad=0.6,
    columnspacing=0.7,
    bbox_to_anchor=(0.5, -0.05),
)

# Tight spacing for tiny canvas
fig.subplots_adjust(left=0.04, right=0.98, top=0.98, bottom=0.35, wspace=0.06)

os.makedirs(OUTPUT_DIR, exist_ok=True)
fig.savefig(OUTPUT_TIFF, bbox_inches="tight", dpi=DPI, format="tiff",pad_inches=0.01)
plt.close(fig)
print(f"Saved TIFF: {OUTPUT_TIFF}")
