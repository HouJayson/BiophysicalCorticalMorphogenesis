import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import matplotlib as mpl

# Define colors and markers
linecolors=['#80796b','#b24745','#6A6599']

region_color_list_new = ["#17BECC", "#FF7F0E", "#BB3640", "#DBDB88", "#9467BD", "#FFBB78", "#935F5B", "#C5B0D5", "#98DF88", "#ADE8E6", "#F7B6D3", "#BCBD22", "#2CA02C", "#1F77B4", "#E41A8A", "#FF9896", "#C29C94", "#9DC7A5"];                    

marker_list_scatter = ['o', 'v', 's']  # Different marker type for scatter points
marker_list_line = ['D', 's', '^']  # Different marker for line crossings

# File paths
file_path_real = r"path_to_4c"
file_path_simulation = r"path_to_4c"

# Sheet names
sheets_real = ["SulcDepth_real","SulcDepth_real"]
sheets_simulation = ["SulcDepth_simu","SulcDepth_alpha_simu"]

# Load data
data_real = {sheet: pd.read_excel(file_path_real, sheet_name=sheet) for sheet in sheets_real}
data_simulation = {sheet: pd.read_excel(file_path_simulation, sheet_name=sheet) for sheet in sheets_simulation}

scaling1 = np.ones((21, 1)) * 1.65 
scaling1[:5, 0] = [1.0, 1.05, 1.1, 1.15, 1.2]
scaling2 = np.ones((21, 1))

def plot_brain_metrics_nature_refined(sheet_real, sheet_sim,title, linecolors, maker_line_type, maker_scatter_type):
    """
    Function to plot individual brain metrics in a Nature-style layout with refinements.
    """
    sns.set_style("white")  # Remove mesh grid

    df_real = data_real[sheet_real]
    df_sim = data_simulation[sheet_sim]

    fig, axes = plt.subplots(3, 6, figsize=(18, 6), constrained_layout=True)
    axes = axes.flatten()


    for region_idx in range(18):
        ax = axes[region_idx]

        # Extract time, mean, and std for real data
        time_real = df_real.iloc[:, 0]
        mean_real = df_real.iloc[:, 1 + region_idx * 2]
        std_real = df_real.iloc[:, 2 + region_idx * 2]

        # Extract time and simulated data
        time_sim = df_sim.iloc[:, 0]
        data_sim = df_sim.iloc[:, 1 + region_idx * 2].to_numpy()
        std_sim = df_sim.iloc[:, 2 + region_idx * 2]

        # Plot simulation data as a line with smaller markers at crossings
        f_simu = ax.plot(time_sim, data_sim, color=linecolors, linewidth=3, marker=maker_line_type , markersize=5, markerfacecolor='none',label=f'Region {region_idx + 1}',zorder = 1)
        ax.fill_between(time_sim, data_sim - std_sim, data_sim + std_sim, color=linecolors, alpha=0.3,zorder = 3)


        # Plot real data with error bars, using different colors for each region
        f_real = ax.errorbar(time_real, mean_real, yerr=std_real, fmt=maker_scatter_type, color=region_color_list_new[region_idx],  capsize=3, markersize=8, linewidth=1.5, fillstyle='none',zorder = 2 )

        # Write region index inside the figure
        ax.text(0.05, 0.85, f"Region {region_idx + 1}", transform=ax.transAxes, fontsize=18,fontname="Arial")

        # Restore right and top axes
        ax.spines['top'].set_visible(True)
        ax.spines['right'].set_visible(True)
        for side in ['top', 'right', 'bottom', 'left']:
            ax.spines[side].set_visible(True)
            ax.spines[side].set_linewidth(0.5)

        tick_fontsize = 14    

        if sheet_real == "SulcDepth_real":
            if region_idx==1:
                ax.set_ylim(0, 16)
                ax.set_yticks([0, 8, 16])
            elif region_idx in [2,4,7,13]:
                ax.set_ylim(0, 8)
                ax.set_yticks([0, 4, 8])
            else:
                ax.set_ylim(0, 6)
                ax.set_yticks([0, 3, 6])
            ax.set_xticks([0, 1.0])
            ax.tick_params(axis='both', labelsize=tick_fontsize,direction ='out')

    fig.supxlabel("Rescaled Age (t)", fontsize=18, fontname="Arial")
    fig.supylabel("Sulcal Depth [mm]", fontsize=18, fontname="Arial")


    fig.savefig(fr"E:\PhD\PINN\WholeBrain\Figures\Figure4\\{sheet_real}.tiff", dpi=600)                       
    plt.show()


plot_brain_metrics_nature_refined("SulcDepth_real", "SulcDepth_simu", "Sulcal Depth [mm]",linecolors[2],marker_list_line[1],marker_list_scatter[0])
