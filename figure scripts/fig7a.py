import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib import rcParams
# Load data
file_path = r"path_to_7a"
df = pd.read_excel(file_path, sheet_name="Sheet2")

time = df.iloc[:, 0]
growth_data = df.iloc[:, 1:] + 1.0

# Define custom colors for each curve
custom_colors = {
    "HYT": "#79AF97",
    "GOM": "#df8f44",
    "SYR": "#b24745",
    "POL": "#6a6599"
}

# Plot
fig, ax = plt.subplots(figsize=(3.2,2.8))
for col in growth_data.columns:
    ax.plot(time, growth_data[col], linewidth=6,
             label=col, color=custom_colors.get(col, "black"))

ax.grid(which="major", linestyle="--", linewidth=0.3, color="lightgray", alpha=0.3)
# ax.minorticks_on()
# ax.grid(which="minor", linestyle="--", linewidth=0.3, color="lightgray", alpha=0.3)

# Nature-style formatting
# ax.set_xlabel("Rescaled Age", fontsize=10, fontname="Arial")
# ax.set_ylabel("Growth Ratio", fontsize=10, fontname="Arial")
ax.set_xticks((0,0.5,1.0))
ax.set_yticks((1.0,1.5,2.0,2.5,3.0))

# ax.tick_params(axis="both", which="major", labelsize=10)
# ax.legend(frameon=False, fontsize=8,handlelength=1.5, columnspacing=0.5, handletextpad=0.5)
plt.tight_layout()

plt.savefig("growth0.tiff",dpi=600, bbox_inches='tight', pad_inches=0.05)
plt.show()
