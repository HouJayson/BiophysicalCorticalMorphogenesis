import os
import re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
# -----------------------------
# Paths
# -----------------------------
# Use your local path:
EXCEL_PATH = r"path-to-fig5c"


OUTPUT_DIR = r"path_to_5c"
OUTPUT_TIFF = os.path.join(OUTPUT_DIR, "LGI_CT_Radar.tiff")

# -----------------------------
# Style settings
# -----------------------------
FIGSIZE = (3.8, 1.8)   # two panels side-by-side
DPI = 600
FONT_FAMILY = "Arial"

FALLBACK_COLORS = {
    "IGU": "#ffcd00",
    "TGU": "#9632B8",
    "TGR": "#2CA02C",
    "OGR": "#DC0000",
    "REAL": "#8491b4",
}

ZORDERS_LGI = {"IGU": 2, "TGU": 4, "TGR": 5, "OGR": 6, "REAL": 10}
ZORDERS_CT  = {"IGU": 8, "TGU": 5, "TGR": 4, "OGR": 7, "REAL": 10}
ALPHAS_LGI  = {"IGU": 0.15, "TGU": 0.15, "TGR": 0.15}
ALPHAS_CT   = {"IGU": 0.3, "TGU": 0.15, "TGR": 0.15}

# Outer radius for the normalized scale (nice round number for tick marks)
OUTER_R_Lgi = 1
OUTER_R_CT = 1

# -----------------------------
# Helpers
# -----------------------------
def norm_key(s: str) -> str:
    s = str(s).upper().strip()
    return re.sub(r"[^A-Z0-9]", "", s)

def read_sheet(sheet_name: str):
    df = pd.read_excel(EXCEL_PATH, sheet_name=sheet_name)
    label_col = df.columns[0]
    df = df.rename(columns={label_col: "Case"}).set_index("Case")
    region_cols = [c for c in df.columns if re.fullmatch(r"R\d+", str(c))]
    region_cols = sorted(region_cols, key=lambda x: int(str(x)[1:]))
    df = df[region_cols].apply(pd.to_numeric, errors="coerce")
    return df, region_cols

def build_theta(n_regions: int):
    theta = np.linspace(0, 2*np.pi, n_regions, endpoint=False)
    return theta, np.r_[theta, theta[:1]]

def plot_radar_panel(ax, df_panel: pd.DataFrame, title: str, theta, theta_closed, colors_map,zorders,alphas,OUTER_R, ticks_angle=90):

    row_candidates = ["IGU", "TGU", "TGR", "OGR", "Real"]
    rows_present = [r for r in row_candidates if norm_key(r) in {norm_key(i) for i in df_panel.index}]
    real_name = next((idx for idx in df_panel.index if norm_key(idx) == "REAL"), None)

    # Plot filled areas first (skip Real and OGR)
    for idx in df_panel.index:
        if (real_name and idx == real_name) or norm_key(idx) == "OGR":
            continue
        key = norm_key(idx)
        color = colors_map.get(key, colors_map.get(idx, "#000000"))
        vals = df_panel.loc[idx].to_numpy(dtype=float)
        vals_closed = np.r_[vals, vals[:1]]
        ax.fill(theta_closed, vals_closed,
                alpha=alphas.get(key, 0.4),
                color=color, linewidth=0.5,
                zorder=zorders.get(key, 1))

        # Then draw the solid outline (no transparency)
        ax.plot(theta_closed, vals_closed,
                linewidth=0.5, color=color,
                label=idx, zorder=zorders.get(key, 1) + 0.1)

    # Plot OGR as line only
    if any(norm_key(i) == "OGR" for i in df_panel.index):
        ogr_name = [i for i in df_panel.index if norm_key(i) == "OGR"][0]
        color = colors_map.get("OGR", "#000000")
        vals = df_panel.loc[ogr_name].to_numpy(dtype=float)
        vals_closed = np.r_[vals, vals[:1]]
        ax.plot(theta_closed, vals_closed,
                linestyle="-", linewidth=1, marker="s", markersize=1.5,alpha = 0.9,
                color=color, label="OGR", zorder=zorders.get("OGR", 5))

    # Plot Real last (dashed outline with markers)
    if real_name is not None:
        color = colors_map.get("REAL", "#000000")
        vals = df_panel.loc[real_name].to_numpy(dtype=float)
        vals_closed = np.r_[vals, vals[:1]]
        ax.plot(theta_closed, vals_closed,
                linestyle="--", linewidth=1, marker="o", markersize=1.5,
                color=color, label="Real", zorder=zorders.get("REAL", 10))    

    # Cosmetics & grids
    ax.spines["polar"].set_visible(False)
    ax.set_rlim(0, OUTER_R)

    # Tidy grid
    ax.yaxis.grid(True, linewidth=0.25, alpha=0.4)
    ax.xaxis.grid(True, linewidth=0.25, alpha=0.4)

    # Region labels around the circle
    n_regions = df_panel.shape[1]
    ax.set_xticks(theta)
    # ax.set_xticklabels([f"R{i+1}" for i in range(n_regions)], fontsize=8,fontfamily="Arial")
    angles_deg = np.degrees(theta)
    labels = [f"R{i+1}" for i in range(n_regions)]
    gridlines, label_texts = ax.set_thetagrids(angles_deg, labels=labels)
    for t in label_texts:
        # Force the radial position to the outer axes radius (1.0 in axes coords)
        th, _ = t.get_position()
        t.set_position((th, 0.1))
        t.set_fontsize(8)
    ax.tick_params(axis="x", pad=2)

    # Radial ticks (0..10)
    rticks = np.linspace(0, OUTER_R, 3)  

    gridlines, labels = ax.set_rgrids(rticks, angle=ticks_angle, fontsize=6)

    theta_pos = np.deg2rad(ticks_angle)
    offset = 0.3
    for r, lab in zip(rticks, labels):
        lab.set_position((theta_pos, r - offset))

    # ax.set_title(title, fontsize=9, pad=6, fontfamily="Arial")
    ax.set_title(title, fontsize=8, pad=5, fontfamily="Arial", x=0.5, y=1.1)

# -----------------------------
# Load both sheets
SHEET_LGI = "Lgi_Normalized_log"
SHEET_CT  = "CT_GM_Normalized_log"

df_lgi, region_cols = read_sheet(SHEET_LGI)
df_ct,  _           = read_sheet(SHEET_CT)

# Build angles
theta, theta_closed = build_theta(len(region_cols))

# -----------------------------
# Render
# -----------------------------

fig, axes = plt.subplots(
    1, 2,
    figsize=FIGSIZE, dpi=DPI,
    subplot_kw=dict(polar=True),
    gridspec_kw={"wspace": 0.28, "left": 0.05, "right": 0.95, "bottom": 0.05, "top": 0.95}
)

# Left = LGI, Right = CT
plot_radar_panel(axes[0], df_lgi, "Local GI", theta, theta_closed, FALLBACK_COLORS,ZORDERS_LGI,ALPHAS_LGI,OUTER_R_Lgi,ticks_angle=96)
plot_radar_panel(axes[1], df_ct,  "Cortical Thickness", theta, theta_closed, FALLBACK_COLORS, ZORDERS_CT,ALPHAS_CT,OUTER_R_CT,ticks_angle=96)

handles, labels = [], []
for ax in axes:
    h, l = ax.get_legend_handles_labels()
    handles += h; labels += l

seen = {}
uniq_handles, uniq_labels = [], []
for h, lab in zip(handles, labels):
    key = norm_key(lab)
    if key not in seen:
        seen[key] = True
        uniq_labels.append(lab)

        if key in ["REAL", "OGR"]:
            uniq_handles.append(h)  # keep the line style
        else:
            color = h.get_color() if hasattr(h, "get_color") else h.get_facecolor()[0]
            uniq_handles.append(mpatches.Patch(facecolor=color, edgecolor=color, label=lab))

fig.legend(
    uniq_handles, uniq_labels,
    loc="lower center",ncol=len(uniq_labels),
    frameon=False, fontsize=7,
    handlelength=2,
    handletextpad=0.7,
    columnspacing=2,
    bbox_to_anchor=(0.5, -0.13),
)


fig.subplots_adjust(left=0.00, right=1, top=1, bottom=0.35, wspace=0.05)

os.makedirs(OUTPUT_DIR, exist_ok=True)
fig.savefig(OUTPUT_TIFF, bbox_inches="tight", dpi=DPI, format="tiff",pad_inches=0.01)
# plt.show()
plt.close(fig)
print(f"Saved TIFF: {OUTPUT_TIFF}")
