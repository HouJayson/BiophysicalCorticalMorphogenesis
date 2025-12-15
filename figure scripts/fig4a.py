import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load the Excel file
file_path = 'path-to-GI'
xls = pd.ExcelFile(file_path)

# List all sheet names
sheet_names = xls.sheet_names

# Initialize a plot
# plt.figure(figsize=(10, 6))
plt.rcParams.update({
    'font.family': 'Arial',
    'font.size': 18,
    'axes.linewidth': 0.75,
    'xtick.direction': 'in',
    'ytick.direction': 'in',
    'xtick.major.size': 3,
    'ytick.major.size': 3,
})

fig, ax = plt.subplots(figsize=(8, 6))

# Plot L_real
df_real = xls.parse('L_real')
data_real = ax.scatter(df_real.iloc[:, 0], df_real.iloc[:, 1], marker='o', s=120, c='#1F77B4',edgecolor ='black', alpha=0.5, linewidth=0.5,zorder=1)

# Collect simulation values
sim_times = None
sim_values = []

for sheet in sheet_names:
    if sheet == 'L_real':
        continue

    df = xls.parse(sheet)
    df_skip = df.iloc[::1, :] 
    values = df_skip.iloc[:, 2].copy()

    if sim_times is None:
        sim_times = df_skip.iloc[:, 0]
    sim_values.append(values)

# Compute mean and std across simulations
sim_values_arr = np.vstack(sim_values)
mean_vals = np.mean(sim_values_arr, axis=0)
std_vals = np.std(sim_values_arr, axis=0)

ax.fill_between(sim_times, mean_vals - std_vals, mean_vals + std_vals, color='gray', alpha=0.3,zorder=10)

# Plot mean with error bars
errbar = ax.errorbar(sim_times, mean_vals, fmt='s--', color='black',markersize=8, markerfacecolor='none', 
                      linewidth=3, elinewidth=1, capsize=4, zorder=3,label = 'simualtion')

# Customize plot
ax.spines['top'].set_visible(True)
ax.spines['right'].set_visible(True)
ax.spines['top'].set_linewidth(0.75)
ax.spines['right'].set_linewidth(0.75)
ax.set_xticks(np.arange(22, 41, 3))
ax.set_yticks(np.arange(1.0, 2.21, 0.3))
ax.set_xlabel('Gestational Week (GW)', fontsize=22)
ax.set_ylabel('Global GI', fontsize=22)
ax.tick_params(axis='both', which='both', labelsize=22)

ax.legend(handles=[data_real, errbar[0]], 
          labels=['Real brain', 'Simulated brain'],frameon=False, fontsize=20, loc='upper left', bbox_to_anchor=(0.02, 1))

plt.tight_layout()

fig.savefig("GI_1.tiff", dpi=600, bbox_inches='tight', pad_inches=0.05)  

plt.show()