import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
from matplotlib.ticker import FixedLocator, FuncFormatter,FormatStrFormatter

# -----------------------------
# Paths
# -----------------------------
EXCEL_PATH = r"E:\PhD\PINN\WholeBrain\Figures\Figure7\Lgi_diff_Average.xlsx"
OUTPUT_DIR = r"E:\PhD\PINN\WholeBrain\Figures\Figure7"
OUTPUT_TIFF = os.path.join(OUTPUT_DIR, "Lgi_heatmap.tiff")

# -----------------------------
# Figure / style settings (Nature-like)
# -----------------------------
FIGSIZE = (3.1, 1.5)    # portrait-ish for 18 rows
DPI = 600
FONT_FAMILY = "Arial"  # falls back to 'serif' if unavailable

LINEWIDTH = 0.5


ROBUST_SCALE = False   
CMAP = "RdBu_r"  
# CMAP = "Purples" 

# -----------------------------
# Load data
# -----------------------------
xls = pd.ExcelFile(EXCEL_PATH)
sheet_name = xls.sheet_names[1]  # use first sheet; change if needed
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

cases = df_num.columns.astype(str).tolist()

H = df_num.values


fig, ax = plt.subplots(figsize=FIGSIZE)


im = ax.imshow(H, aspect="auto", interpolation="nearest", cmap=CMAP, norm=Normalize(vmin=-0.08, vmax=0.08))

ax.set_xticks(np.arange(len(cases)))
ax.set_xticklabels([f"R{i+1}" for i in range(18)],rotation=90, ha="center",fontsize=7)
ax.tick_params(axis="x", pad=2)
ax.set_yticks(np.arange(3))
ax.set_yticklabels(["HYT", "GOM", "POL"], fontsize=7)
ax.tick_params(axis="y", pad=2)

# ax.set_title('Relative Regional Local GI',fontsize=8, pad =3)

ax.tick_params(axis="both", which="both", width=LINEWIDTH, length=2)
for spine in ax.spines.values():
    spine.set_linewidth(LINEWIDTH)

# Slim colorbar
cbar = plt.colorbar(im, ax=ax, orientation="vertical", pad=0.02,aspect=15)
cbar.ax.xaxis.set_ticks_position("bottom")
cbar.ax.xaxis.set_label_position("top")
cbar.outline.set_linewidth(0.25)
cbar.ax.tick_params(width=LINEWIDTH, labelsize=7)
# cbar.ax.set_ylabel("Regional Local GI",fontsize=10, rotation=0, labelpad=4, y=1.02,va="bottom", ha="right")
cbar.locator = FixedLocator([-0.05, 0, 0.05]) 
cbar.update_ticks()
cbar.ax.yaxis.set_major_formatter(FuncFormatter(lambda x, _: f"{x*100:.0f}%"))
cbar.ax.tick_params(pad=1)


# Save TIFF
os.makedirs(OUTPUT_DIR, exist_ok=True)
fig.tight_layout()
fig.savefig(OUTPUT_TIFF, bbox_inches="tight", dpi=DPI, format="tiff",pad_inches=0.01)
plt.close(fig)

print(f"Saved TIFF: {OUTPUT_TIFF}")
