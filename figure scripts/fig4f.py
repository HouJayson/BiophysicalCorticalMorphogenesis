import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
from matplotlib.ticker import FixedLocator, FormatStrFormatter

# ---------- Paths ----------
FILE = r"path_to_4f"
OUTPUT_DIR = r"path_to_4f"


# ---------- Config ----------
plt.rcParams["font.family"] = "Arial"
# CMAP = "coolwarm"
CMAP = "RdBu_r"
# CMAP = "Purples" 

# Labels
cols = [f"GW{i}" for i in [22,29,32,35,38,40]]          # GW22..GW40
rows = [f"S{str(i).zfill(2)}" for i in range(1, 11)]  # S01..S10

# ---------- Load data (robust) ----------
df_raw = pd.read_excel(FILE, sheet_name=0)

# If the first column contains S01..S10, set it as index
if df_raw.iloc[:, 0].astype(str).str.match(r"^S\d{2}$").any():
    first_col = df_raw.columns[0]
    df_raw = df_raw.rename(columns={first_col: "ID"}).set_index("ID")

# Keep only GW columns present
present_cols = [c for c in cols if c in df_raw.columns]
df = df_raw.loc[:, present_cols].copy()

# Reindex to force the desired structure (fills missing with NaN)
df = df.reindex(index=rows, columns=cols)

# Convert to numeric
df = df.apply(pd.to_numeric, errors="coerce")

H = df.values 
norm = Normalize(vmin=0.7, vmax=1.0)

# ---------- Plot ----------
fig, ax = plt.subplots(figsize=(3, 2.5))

im = ax.imshow(df.values, cmap=CMAP, aspect="auto",norm=norm)

# Axes ticks/labels
ax.set_xticks(np.arange(len(cols)))
ax.set_xticklabels(cols, rotation=45, fontsize=8)
ax.set_yticks(np.arange(len(rows)))
ax.set_yticklabels(rows, fontsize=8)
ax.tick_params(axis="both", which="both", width=0.5, length=2)
for spine in ax.spines.values():
    spine.set_linewidth(0.5)

# Colorbar
cbar = fig.colorbar(im, ax=ax, fraction=0.046, pad=0.04, shrink = 0.9, aspect=30)
cbar.outline.set_linewidth(0.25)
cbar.ax.tick_params(width=0.25, labelsize=7)

cbar.locator = FixedLocator([0.8, 0.9, 1.0])   
cbar.formatter = FormatStrFormatter('%.1f')
cbar.update_ticks()

# Annotate values inside boxes
norm = im.norm if im.norm is not None else Normalize(
    # vmin=np.nanmin(df.values), vmax=np.nanmax(df.values)
    vmin=0.7, vmax=1.0
)
for i in range(df.shape[0]):
    for j in range(df.shape[1]):
        val = df.iat[i, j]
        if pd.notna(val):
            nv = norm(val)
            text_color = "white" if (nv < 0.25 or nv > 0.75) else "gray"
            # text_color = "gray"
            ax.text(j, i, f"{val:.2f}", ha="center", va="center",
                    fontsize=7, color=text_color)

plt.tight_layout()
OUTPUT_TIFF = os.path.join(OUTPUT_DIR, "SI_heatmap1.tiff")
fig.savefig(OUTPUT_TIFF, bbox_inches="tight", dpi=600, format="tiff",pad_inches=0.04)
plt.show()
