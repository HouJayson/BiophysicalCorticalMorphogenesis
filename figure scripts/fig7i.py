import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter, AutoMinorLocator

# ===== Path & settings =====
xlsx = r"Epath_to_7i"
sheets = ["Sulcal Depth", "Local GI"]
cases = ["AR", "SR", "MR"]
colors = {"AR": "#1F77B4", "SR": "#00AF66", "MR": "#802268"} 
alpha_val = 0.8
regions = [f"R{i}" for i in range(1, 19)]
bar_w = 0.3

# Nature-ish aesthetics
plt.rcParams.update({
    "font.family": "Arial",
    "axes.linewidth": 0.5,
    "xtick.major.width": 0.5,
    "ytick.major.width": 0.5,
    "xtick.direction": "out",
    "ytick.direction": "out",
})

def load_and_prepare(sheet):
    df = pd.read_excel(xlsx, sheet_name=sheet)
    # If first column is labels (e.g., 'Case'), make it the index
    if not np.issubdtype(df.dtypes.iloc[0], np.number):
        df = df.set_index(df.columns[0])
    # Keep only R1..R18 (in order) and rows RA/R1/R3 (in order)
    cols_present = [c for c in regions if c in df.columns]
    df = df.loc[df.index.intersection(cases), cols_present]
    df = df.reindex(index=cases, columns=cols_present)

    # Convert to percent if values look like fractions
    max_abs = np.nanmax(np.abs(df.to_numpy()))
    if np.isfinite(max_abs) and max_abs <= 1.0:
        df = df * 100.0
    return df

def percent_fmt(y, pos):
    return f"{y:.0f}"

fig, axes = plt.subplots(2, 1, figsize=(4.0, 2), sharex=True, constrained_layout=True)

for ax, sheet in zip(axes, sheets):
    df = load_and_prepare(sheet)

    x = np.arange(len(df.columns))
    for j, c in enumerate(cases):
        # offsets: -1, 0, +1 groups at width bar_w
        offset = (j - 1) * bar_w
        vals = df.loc[c].values.astype(float)
        ax.bar(x + offset, vals, width=bar_w, color=colors[c], alpha=alpha_val, label=c, edgecolor="none")

    # Zero baseline and tidy axes
    ax.axhline(0, color="gray", linewidth=0.25)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.yaxis.set_major_formatter(FuncFormatter(percent_fmt))

    ax.tick_params(axis="both", labelsize=7,length=3)
    ax.set_ylabel(f"Δ {sheet} (%)", fontsize=7, labelpad=2)
    if ax is not axes[-1]:                
        ax.tick_params(axis="x", length=0)
        ax.spines["bottom"].set_visible(False)

axes[0].set_ylim(-55, 25)
axes[1].set_ylim(-55, 25) 
axes[0].set_yticks([-50,-25, 0,25])
axes[1].set_yticks([-50,-25,0,25])
axes[-1].set_xticks(np.arange(len(regions)))
axes[-1].set_xticklabels(regions, rotation=90, ha="center", fontsize=8)
axes[-1].set_xlim(-0.5, len(regions)-0.5)
axes[0].tick_params(axis="y", which="major", pad=2) 
axes[1].tick_params(axis="y", which="major", pad=2) 

# One legend for the whole figure (bottom center)
handles, labels = axes[0].get_legend_handles_labels()
fig.legend(handles, labels, loc="upper right", ncol=3, frameon=False, fontsize=7)


# To save:
out = r"E:\PhD\PINN\WholeBrain\Figures\Figure7\deviation1.tiff"
fig.savefig(out, dpi=600, bbox_inches="tight",pad_inches=0.02)
plt.show()


