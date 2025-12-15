import sympy 
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import seaborn as sns
from matplotlib import rcParams
from matplotlib.ticker import AutoMinorLocator
from tabulate import tabulate

# # Dataset
import os

file_name="path-to-areaData"

dfs = pd.read_excel(file_name, sheet_name='summary_normalizedArea',engine='openpyxl')
GA_1        = dfs.iloc[:,0].dropna().astype(np.float64).values            
g_square1   = dfs.iloc[:,1].dropna().astype(np.float64).values       

GA_2        = dfs.iloc[:,3].dropna().astype(np.float64).values           
g_square2   = dfs.iloc[:,4].dropna().astype(np.float64).values

GA_3       = dfs.iloc[:,6].dropna().astype(np.float64).values        
g_square3  = dfs.iloc[:,7].dropna().astype(np.float64).values

GA_4        = dfs.iloc[:,9].dropna().astype(np.float64).values         
g_square4   = dfs.iloc[:,10].dropna().astype(np.float64).values

GA_5       = dfs.iloc[:,12].dropna().astype(np.float64).values           
g_square5  = dfs.iloc[:,13].dropna().astype(np.float64).values

GA_6        = dfs.iloc[:,15].dropna().astype(np.float64).values            
g_square6   = dfs.iloc[:,16].dropna().astype(np.float64).values       

GA_7        = dfs.iloc[:,18].dropna().astype(np.float64).values           
g_square7   = dfs.iloc[:,19].dropna().astype(np.float64).values

GA_8       = dfs.iloc[:,21].dropna().astype(np.float64).values        
g_square8  = dfs.iloc[:,22].dropna().astype(np.float64).values

GA_9        = dfs.iloc[:,24].dropna().astype(np.float64).values         
g_square9   = dfs.iloc[:,25].dropna().astype(np.float64).values

GA_10      = dfs.iloc[:,27].dropna().astype(np.float64).values           
g_square10  = dfs.iloc[:,28].dropna().astype(np.float64).values

GA_11        = dfs.iloc[:,30].dropna().astype(np.float64).values            
g_square11   = dfs.iloc[:,31].dropna().astype(np.float64).values       

GA_12        = dfs.iloc[:,33].dropna().astype(np.float64).values           
g_square12   = dfs.iloc[:,34].dropna().astype(np.float64).values

GA_13       = dfs.iloc[:,36].dropna().astype(np.float64).values        
g_square13  = dfs.iloc[:,37].dropna().astype(np.float64).values

GA_14        = dfs.iloc[:,39].dropna().astype(np.float64).values         
g_square14   = dfs.iloc[:,40].dropna().astype(np.float64).values

GA_15      = dfs.iloc[:,42].dropna().astype(np.float64).values           
g_square15  = dfs.iloc[:,43].dropna().astype(np.float64).values

GA_16        = dfs.iloc[:,45].dropna().astype(np.float64).values            
g_square16   = dfs.iloc[:,46].dropna().astype(np.float64).values       

GA_17        = dfs.iloc[:,48].dropna().astype(np.float64).values           
g_square17   = dfs.iloc[:,49].dropna().astype(np.float64).values

GA_18       = dfs.iloc[:,51].dropna().astype(np.float64).values        
g_square18 = dfs.iloc[:,52].dropna().astype(np.float64).values

GA_list = [GA_1,GA_2,GA_3,GA_4,GA_5,GA_6,GA_7,GA_8,GA_9,GA_10,GA_11,GA_12,GA_13,GA_14,GA_15,GA_16,GA_17,GA_18]
g_square_list = [g_square1, g_square2, g_square3, g_square4, g_square5,g_square6, g_square7, g_square8, g_square9, g_square10,g_square11, g_square12, g_square13, g_square14, g_square15,g_square16, g_square17, g_square18]
color_list_new_latest = ["#17BECC", "#FF7F0E", "#BB3640", "#DBDB88", "#9467BD", "#FFBB78", "#935F5B", "#C5B0D5", "#98DF88", "#ADE8E6", "#F7B6D3", "#BCBD22", "#2CA02C", "#1F77B4", "#E41A8A", "#FF9896", "#C29C94", "#9DC7A5"];

x0 = sympy.Symbol('t')
models_list =[1.46*x0,       1.62*x0,       1.58*x0,       
              1.51*x0,       1.83*x0,       1.48*x0,
              1.67*x0,       1.60*x0,      1.80*x0,
              1.23*x0,       1.44*x0,       1.86*x0,
              1.29*x0,       1.73*x0,       1.39*x0,
              1.53*x0,      1.77*x0,       1.56*x0] 

expression_list = ["1.46t+1",    "1.62t+1",    "1.58t+1",
                   "1.51t+1",    "1.83t+1",    "1.48t+1",
                   "1.67t+1",    "1.60t+1",    "1.80t+1",
                   "1.23t+1",    "1.44t+1",    "1.86t+1",
                   "1.29t+1",    "1.73t+1",    "1.39t+1",
                   "1.53t+1",    "1.77t+1",    "1.56t+1"]

mpl.rcParams["text.usetex"] = True
plt.rcParams["font.family"] = "Arial"
sns.set_style("white")  # Remove mesh grid
fig, axes = plt.subplots(6, 3, figsize=(4.2, 6.5), constrained_layout=False)
fig.set_constrained_layout_pads(w_pad=0.02, h_pad=0.02, hspace=0.02, wspace=0.02)
axes = axes.flatten()

for region_idx in range(18):
    ax = axes[region_idx]

    GA = GA_list[region_idx].reshape(-1, 1)
    g_square = g_square_list[region_idx].reshape(-1, 1) - 1

    model = models_list[region_idx]
    model_expr = sympy.lambdify(('t'),model,"numpy")
    g_square_predict = model_expr(GA)
    mse = np.power(g_square_predict - g_square, 2).mean()
    r_square = 1 - np.power(g_square - g_square_predict, 2).sum() / np.power(g_square - g_square.mean(), 2).sum()  
    if r_square <0:
        r_square = 0

    ax.scatter(GA, g_square + 1, marker='o', s=15, c='#AEC7E8', alpha = 0.4, edgecolor =(0,0,0,0.4), linewidths=0.2, label='Measured data')
    GA_plot = np.linspace(0, max(GA), 100)
    g_square_plot = model_expr(GA_plot) + 1
    ax.plot(GA_plot, g_square_plot, color=color_list_new_latest[region_idx], linewidth = 2.5,label='Tangential prediction')


    # Write region index inside the figure
    ax.text(0.03, 0.85, f"Region {region_idx + 1}", transform=ax.transAxes, fontsize=9,fontname="Arial")
    ax.text(0.59, 0.85, r"$R^2\!\!=\!{:.2f}$".format(r_square),transform=ax.transAxes,fontsize=9,fontname="Arial")
    ax.text(0.5, 0.02,r"$"+expression_list[region_idx]+"$", transform=ax.transAxes,ha="center", va="bottom",fontsize=9,fontname="Arial")



    # Restore right and top axes
    ax.spines['top'].set_visible(True)
    ax.spines['right'].set_visible(True)
    for side in ['top', 'right', 'bottom', 'left']:
        ax.spines[side].set_visible(True)
        ax.spines[side].set_linewidth(0.2)

 
    ax.set_xlim(-0.08,1.08)
    ax.set_ylim(0,4.2)
    if region_idx in [0,3,6,9,12]:
        ax.set_xticks([])
        ax.set_yticks([1,2,3,4])
    elif region_idx in [16,17]:
        ax.set_yticks([])
        ax.set_xticks([0,0.5,1])
    elif region_idx in [1,2,4,5,7,8,10,11,13,14]:
        ax.set_yticks([])
        ax.set_xticks([])        
    else:
        ax.set_xticks([0,0.5,1])
        ax.set_yticks([1,2,3,4])

    ax.tick_params(axis='both', labelsize=8, direction ='out')
    ax.xaxis.set_tick_params(pad=1)
    ax.yaxis.set_tick_params(pad=0.1)

fig.supxlabel("Rescaled Age ("+r"$t$"+")", fontsize=9, fontname="Arial",ha='center',x=0.55)
fig.supylabel("Tangential Growth Ratio ("+r"$g_t(t)$"+")",fontsize=9,fontname="Arial")


handles, labels = axes[0].get_legend_handles_labels()

lgd = fig.legend(handles, labels,
                 loc="upper center",
                 ncol=len(labels),
                 fontsize=8,
                 frameon=False,
                 handlelength=2,
                 handletextpad=0.5,
                 labelspacing=0.5, 
                 columnspacing=1,
                 bbox_to_anchor=(0.5, 0.95),
                 bbox_transform=fig.transFigure
                 )

for handle in lgd.legend_handles:
    handle.set_color('gray')

fig.savefig("tangential_growth.tiff", dpi=600)                       
plt.show()

