import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

# ---- Config ----
xlsx_path = Path(r"path_to_7e")
out_path = Path(r"path_to_7e.tiff")

custom_colors = {
    "POL": "#6a6599",
    "SYR": "#b24745",    
    "GOM": "#df8f44",    
    "HYT": "#79AF97",
}
alpha = 0.5  # transparency
bar_height = 0.5   # thickness of bars
bar_interval = 0.6 # space between bars
tick_fontsize = 7 # font size for ticks

# ---- Load Excel ----
df = pd.read_excel(xlsx_path, sheet_name=0)
df.columns = [str(c).strip() for c in df.columns]

# Summarize mean ± SD
num_cols = [c for c in df.columns if np.issubdtype(df[c].dropna().dtype, np.number)]
means = df[num_cols].mean()
sds = df[num_cols].std(ddof=1)
summary = pd.DataFrame({"Case": means.index, "Mean": means.values, "SD": sds.values})

# Order cases as defined in custom_colors
ordered_cases = [c for c in custom_colors.keys() if c in summary["Case"].tolist()]
extras = [c for c in summary["Case"].tolist() if c not in ordered_cases]
case_order = ordered_cases + extras
summary = summary.set_index("Case").loc[case_order].reset_index()

# ---- Plot ----
plt.rcParams.update({"font.family": "Arial"})

fig, ax = plt.subplots(figsize=(2.4, 1.5))

y_pos = np.arange(len(summary)) * bar_interval
bar_colors = [custom_colors.get(c, "#999999") for c in summary["Case"]]

ax.barh(
    y=y_pos,
    width=summary["Mean"],
    xerr=summary["SD"],
    height=bar_height,
    color=bar_colors,
    alpha=alpha,
    edgecolor="black",
    linewidth=0.5,
    capsize=2,
    error_kw={"elinewidth": 0.5, "capthick": 0.5}
)

ax.set_yticks(y_pos, summary["Case"])
ax.tick_params(axis="x", labelsize=7,pad=2, length=2)
ax.tick_params(axis="y",labelsize=7, pad=2, length=2)
ax.set_xlabel("Sulcus Counts", fontsize=7,labelpad=1)
# Show top and right spines
for spine in ["top", "right", "left", "bottom"]:
    ax.spines[spine].set_visible(True)

# Axis line width
for spine in ax.spines.values():
    spine.set_linewidth(0.5)   # change 1.2 to what you need

# Tick line width
ax.tick_params(width=0.5)      # controls tick mark thickness
# Remove grid
ax.grid(False)

fig.tight_layout()
fig.savefig(out_path, dpi=600, bbox_inches="tight", pad_inches=0.01)
print(f"Saved to {out_path}")
