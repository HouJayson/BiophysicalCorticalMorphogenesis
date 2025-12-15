import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
from matplotlib.ticker import FixedLocator, FuncFormatter,FormatStrFormatter

# -------- File & sheets --------
xlsx_path = r"path_to_7g"
sheets = ["SulcDepth_alpha_HYT", "SulcDepth_alpha_GOM", "SulcDepth_alpha_POL"]   # 3 cases
row_order = ["AR", "SR", "MR"]     
txt_colors = {"HYT":"#79AF97", "GOM":"#df8f44", "POL":"#6a6599"}           
regions   = [f"R{i}" for i in range(1, 19)]

# -------- Robust loader: expect a table with a row label column + R1..R18 columns --------
def load_matrix_3x18(xlsx, sheet, wanted_rows):
    df = pd.read_excel(xlsx, sheet_name=sheet)
    # Try to set first column as index (row labels)
    if df.columns[0] not in regions:
        df = df.set_index(df.columns[0])
    # Keep only region columns (R1..R18); if missing, fall back to numeric-only cells
    keep = [c for c in df.columns if c in regions]
    if len(keep) == 18:
        df = df[keep]
    else:
        df = pd.DataFrame(
            pd.to_numeric(np.ravel(df.select_dtypes(include=[np.number]).values),
                          errors="coerce")
        ).dropna().T
        # now shape should be (1, >=54); reshape to (rows, 18)
        arr = df.values.ravel()
        if arr.size < 18*len(wanted_rows):
            raise ValueError(f"{sheet}: need {18*len(wanted_rows)} numeric values.")
        arr = arr[:18*len(wanted_rows)].reshape(len(wanted_rows), 18)
        return arr

    # Align row order robustly (case-insensitive, trimmed)
    idx_map = {str(i).strip().lower(): i for i in df.index}
    rows = []
    for r in wanted_rows:
        key = r.strip().lower()
        if key not in idx_map:
            raise ValueError(f"Row '{r}' not found in {sheet}.")
        rows.append(df.loc[idx_map[key]].to_numpy(dtype=float))
    return np.vstack(rows)

# Load all sheets -> dict[sheet] = (3 x 18) values
M = {sh: load_matrix_3x18(xlsx_path, sh, row_order) for sh in sheets}

# ----- Scale to percentage for BOTH color and size -----
# values are assumed to be fractions; multiply by 100 to get %
M_pct = {sh: M[sh] for sh in sheets}

# Global symmetric color/size limits across all panels
all_vals = np.concatenate([M_pct[sh].ravel() for sh in sheets])
vmax = float(np.nanmax(np.abs(all_vals))) if np.isfinite(all_vals).any() else 1.0
norm = Normalize(vmin=-0.35, vmax=0.35)

# Size scaling (area in points^2)
s_base = 160.0
# def sizes_from(vals):
#     return s_base * (np.abs(vals) / vmax + 1e-6)

def sizes_from(vals):
    return s_base * (np.log1p(np.abs(vals)) / np.log1p(vmax))
# -------- Plot (3 rows, shared x) --------
plt.rcParams.update({
    "font.family": "Arial",
    "axes.linewidth": 0.5, "xtick.major.width": 0.5, "ytick.major.width": 0.5
})

# fig, axes = plt.subplots(3, 1, figsize=(4, 2.8), sharex=True,
#                          constrained_layout=True)
fig, axes = plt.subplots(3, 1, figsize=(4.3, 3), sharex=True)
plt.subplots_adjust(hspace=0.05)
ypos = [2, 1, 0]  # top, middle, bottom within each subplot
for ax, sh in zip(axes, sheets):
    last_sc = None
    for rname, y in zip(row_order, ypos):
        vals = M_pct[sh][row_order.index(rname)]
        x = np.arange(1, 19)
        last_sc = ax.scatter(
            x, np.full_like(x, y),
            s=sizes_from(vals), c=vals, cmap="RdBu_r", norm=norm,
            edgecolors="black", linewidths=0.5
        )

    # Axes cosmetics
    ax.set_yticks(ypos)
    ax.set_yticklabels(row_order, fontsize=7)
    ax.set_xlim(0.5, 18.5)
    ax.set_ylim(-0.5, 2.5)
    ax.tick_params(axis="y", length=2,pad=2)              # no y tick marks
    ax.tick_params(axis="x", length=2, width=0.5)
    if ax is not axes[-1]:                
        ax.tick_params(axis="x", length=0)
    # Panel title inside, upper-right
    case = sh.replace("SulcDepth_alpha_", "")
    ax.set_ylabel(case, fontsize=8, rotation=90, labelpad=90, va="center", ha="right",color=txt_colors.get(case, "black"))
    ax.yaxis.set_label_coords(-0.08, 0.7)


# Shared X
axes[-1].set_xticks(np.arange(1, 19))
axes[-1].set_xticklabels(regions, rotation = 90, fontsize=8)


# Single shared colorbar labeled as percentage
cbar = fig.colorbar(last_sc, ax=axes, orientation="vertical",
                    fraction=0.02, pad=0.02, shrink=0.5, aspect=20)
# cbar.set_label("Difference (%)", fontsize=10)
cbar.ax.tick_params(labelsize=7, length=2)
cbar.locator = FixedLocator([-0.20, 0, 0.20]) 
cbar.update_ticks()
cbar.outline.set_linewidth(0.25)
cbar.ax.yaxis.set_major_formatter(FuncFormatter(lambda x, _: f"{x*100:.0f}%"))
cbar.ax.tick_params(pad=2)

# Save
out_path = r"E:\PhD\PINN\WholeBrain\Figures\Figure7\SulcDepth_diff_circles2.tiff"
plt.savefig(out_path,  dpi=600,bbox_inches="tight",pad_inches=0.02)
plt.show()
