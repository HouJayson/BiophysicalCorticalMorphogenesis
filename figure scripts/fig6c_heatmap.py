import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
from matplotlib.colors import TwoSlopeNorm
from matplotlib.colors import PowerNorm
from matplotlib.colors import LogNorm
from matplotlib.ticker import FixedLocator, FormatStrFormatter

# -----------------------------
# Paths
# -----------------------------
EXCEL_PATH = r"path_to_6c_heatmap"
OUTPUT_DIR = r"path_to_6c_heatmap"
OUTPUT_TIFF = os.path.join(OUTPUT_DIR, "sulcal_heatmap_2.tiff")

# -----------------------------
# Figure / style settings (Nature-like)
# -----------------------------
FIGSIZE = (2.8, 1.5)    # portrait-ish for 18 rows
DPI = 600
FONT_FAMILY = "Arial"  # falls back to 'serif' if unavailable
TICK_FONTSIZE = 6


LINEWIDTH = 0.25


ROBUST_SCALE = False   
CMAP = "RdBu_r"  
# CMAP = "Purples" 

# -----------------------------
# Load data
# -----------------------------
xls = pd.ExcelFile(EXCEL_PATH)
sheet_name = xls.sheet_names[0]  # use first sheet; change if needed
df = pd.read_excel(EXCEL_PATH, sheet_name=sheet_name)

if df.shape[1] >= 2 and not pd.api.types.is_numeric_dtype(df.iloc[:, 0]):
    df = df.set_index(df.columns[0])
df_num = df.select_dtypes(include=[np.number]).copy()
if df_num.shape[0] > 18:
    idx_str = df_num.index.astype(str).str.lower()
    if (idx_str.str.contains("region").sum() >= 18):
        df_num = df_num.loc[idx_str.str.contains("region")].head(18)
    else:
        df_num = df_num.iloc[:18, :]

# regions = sorted(df_num.index.astype(str).tolist(), key=_region_key)
# df_num = df_num.loc[regions]

cases = df_num.columns.astype(str).tolist()

H = df_num.values 

# norm = TwoSlopeNorm(vmin=0, vcenter=4, vmax=8)
# norm = PowerNorm(gamma=0.4, vmin=0, vmax=8)
norm = PowerNorm(gamma=0.3, vmin=np.nanmin(H), vmax=np.nanmax(H))

# vmin = np.nanpercentile(H, 2)
# vmax = np.nanpercentile(H, 98)
# norm = LogNorm(vmin=max(vmin, 1e-6), vmax=vmax)

# H0 = H.astype(float)
# Z = (H0 - np.nanmean(H0)) / (np.nanstd(H0) if np.nanstd(H0) else 1)
# m = np.nanmax(np.abs(Z)) or 1
# norm = TwoSlopeNorm(vmin=-m, vcenter=0, vmax=m)

try:
    plt.rcParams["font.family"] = FONT_FAMILY
except Exception:
    plt.rcParams["font.family"] = "serif"

fig, ax = plt.subplots(figsize=FIGSIZE, dpi=DPI)


im = ax.imshow(H, aspect="auto", interpolation="nearest", cmap=CMAP, norm=norm)

ax.set_xticks(np.arange(len(cases)))
ax.set_xticklabels([f"R{i+1}" for i in range(18)],rotation=90, ha="center",fontsize=TICK_FONTSIZE)

ax.set_yticks(np.arange(5))
ax.set_yticklabels(["ICT2", "ICT1", "NCT","RCT1", "RCT2"], fontsize=TICK_FONTSIZE)
# ax.set_title('Regional Mean Sulcal Depth',fontsize=20, pad = 10 )

ax.tick_params(axis="both", which="both", width=LINEWIDTH, length=2)
for spine in ax.spines.values():
    spine.set_linewidth(LINEWIDTH)

# Slim colorbar
cbar = plt.colorbar(im, ax=ax, orientation="vertical", pad=0.02, fraction = 0.04)
cbar.ax.xaxis.set_ticks_position("bottom")
cbar.ax.xaxis.set_label_position("top")
cbar.outline.set_linewidth(LINEWIDTH)
cbar.ax.tick_params(width=LINEWIDTH, labelsize=6)
cbar.ax.set_ylabel("[mm]",fontsize=6, rotation=0, labelpad=4, y=1.01,va="bottom", ha="right")
cbar.locator = FixedLocator([2, 4, 6, 8])     # only 0 and 8
cbar.formatter = FormatStrFormatter('%.0f')
cbar.update_ticks()


# Save TIFF
os.makedirs(OUTPUT_DIR, exist_ok=True)
fig.tight_layout()
fig.savefig(OUTPUT_TIFF, bbox_inches="tight", dpi=DPI, format="tiff",pad_inches=0.04)
plt.close(fig)

print(f"Saved TIFF: {OUTPUT_TIFF}")
