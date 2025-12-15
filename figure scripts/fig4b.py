import os
import math
import pandas as pd
import matplotlib.pyplot as plt

# -------------------------------
# 1) Path to your Excel file
# -------------------------------
excel_path = "path-to-localGI"

# -------------------------------
# 2) Load sheets
# -------------------------------
real_df = pd.read_excel(excel_path, sheet_name="real_data")
simu_df = pd.read_excel(excel_path, sheet_name="simu_data")

# Expectation (based on your example file):
#   Row 0 = means per region
#   Row 1 = errors per region
#   Columns = "region 1", "region 2", ..., "region N"

# Extract means and errors as Series aligned by column/region
real_means = real_df.iloc[0]
real_errs  = real_df.iloc[1]

simu_means = simu_df.iloc[0]
simu_errs  = simu_df.iloc[1]

# Regions (column names)
regions = list(real_df.columns)

# Basic sanity checks
assert regions == list(simu_df.columns), "real_data and simu_data columns (regions) must match."
assert len(real_df) >= 2 and len(simu_df) >= 2, "Each sheet needs >=2 rows (mean row, error row)."

# -------------------------------
# 3) Sort regions ascending
# -------------------------------
sorted_regions = [f"Region {i}" for i in range(1, 19)]

# Reorder all series by the sorted regions
real_means = real_means[sorted_regions]
real_errs  = real_errs[sorted_regions]
simu_means = simu_means[sorted_regions]
simu_errs  = simu_errs[sorted_regions]

# -------------------------------
# 4) Plot (Nature-like minimal style)
# -------------------------------
plt.rcParams.update({
    "font.family": "Arial",
    "axes.linewidth": 0.5,
    "axes.spines.top": True,
    "axes.spines.right": True,
    "axes.spines.left": True,
    "axes.spines.bottom": True,
    "xtick.direction": "out",
    "ytick.direction": "out",
    "xtick.major.width": 0.8,
    "ytick.major.width": 0.8,
})

# Muted, print‑friendly colors
color_real = (0.25, 0.45, 0.75)  # muted blue
color_simu = (0.80, 0.45, 0.20)  # muted orange

n_regions = len(sorted_regions)
x = range(n_regions)
bar_width = 0.38
gap = 0.06  # small gap between paired bars

fig_h = 3.2
fig_w = max(6.0, min(14.0, 0.45 * n_regions + 2.0))  # scale sensibly with #regions
fig, ax = plt.subplots(figsize=(fig_w, fig_h))

# Positions: left bar slightly left of tick, right bar slightly right
x_real = [i - (bar_width/2 + gap/2) for i in x]
x_simu = [i + (bar_width/2 + gap/2) for i in x]

# Draw bars
real_bars = ax.bar(x_real, real_means.values, bar_width, yerr=real_errs.values,
                   capsize=2, linewidth=0, color=color_real, label="Real brain")
simu_bars = ax.bar(x_simu, simu_means.values, bar_width, yerr=simu_errs.values,
                   capsize=2, linewidth=0, color=color_simu, label="Simulated brain")

# Axis/labels
ax.set_xticks(list(x))
ax.set_xticklabels(sorted_regions, rotation=45, ha="right", fontsize=14)
ax.set_ylabel("Local GI", fontsize=16)
ax.tick_params(axis='y', labelsize=15)
ax.set_xlim(-0.75, n_regions - 0.25)
ax.set_axisbelow(True)

# Legend
leg = ax.legend(frameon=False, ncols=2, loc="upper left", handlelength=2,handletextpad=0.5,columnspacing=1, bbox_to_anchor=(0.53, 1.01), fontsize=16)


# Tight layout and export
plt.tight_layout()

# Save next to the Excel
out_dir = os.path.dirname(excel_path) if os.path.dirname(excel_path) else "."
tif_path = os.path.join(out_dir, "LocalGI_barplot1.tiff")
fig.savefig(tif_path, dpi=600, bbox_inches='tight', pad_inches=0.05)
plt.show()
