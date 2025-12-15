import sympy 
import numpy as np
import pandas as pd
from pysr import PySRRegressor

from pysr.julia_helpers import init_julia

from julia import SymbolicRegression
from julia import Serialization
from julia import MLJ
from julia import Zygote
from julia import SymbolicUtils


# # Dataset
import os
file_name="file-to-thicknessData"


dfs = pd.read_excel(file_name, sheet_name='summary_rawThickness',engine='openpyxl')
GA_1        = dfs.iloc[:,0].dropna().astype(np.float64).values            
g_thickness1   = dfs.iloc[:,1].dropna().astype(np.float64).values       

GA_2        = dfs.iloc[:,3].dropna().astype(np.float64).values           
g_thickness2   = dfs.iloc[:,4].dropna().astype(np.float64).values

GA_3       = dfs.iloc[:,6].dropna().astype(np.float64).values        
g_thickness3  = dfs.iloc[:,7].dropna().astype(np.float64).values

GA_4        = dfs.iloc[:,9].dropna().astype(np.float64).values         
g_thickness4   = dfs.iloc[:,10].dropna().astype(np.float64).values

GA_5      = dfs.iloc[:,12].dropna().astype(np.float64).values           
g_thickness5  = dfs.iloc[:,13].dropna().astype(np.float64).values

GA_6        = dfs.iloc[:,15].dropna().astype(np.float64).values            
g_thickness6   = dfs.iloc[:,16].dropna().astype(np.float64).values       

GA_7        = dfs.iloc[:,18].dropna().astype(np.float64).values           
g_thickness7   = dfs.iloc[:,19].dropna().astype(np.float64).values

GA_8       = dfs.iloc[:,21].dropna().astype(np.float64).values        
g_thickness8  = dfs.iloc[:,22].dropna().astype(np.float64).values

GA_9        = dfs.iloc[:,24].dropna().astype(np.float64).values         
g_thickness9   = dfs.iloc[:,25].dropna().astype(np.float64).values

GA_10      = dfs.iloc[:,27].dropna().astype(np.float64).values           
g_thickness10  = dfs.iloc[:,28].dropna().astype(np.float64).values

GA_11        = dfs.iloc[:,30].dropna().astype(np.float64).values            
g_thickness11   = dfs.iloc[:,31].dropna().astype(np.float64).values       

GA_12        = dfs.iloc[:,33].dropna().astype(np.float64).values           
g_thickness12   = dfs.iloc[:,34].dropna().astype(np.float64).values

GA_13       = dfs.iloc[:,36].dropna().astype(np.float64).values        
g_thickness13  = dfs.iloc[:,37].dropna().astype(np.float64).values

GA_14        = dfs.iloc[:,39].dropna().astype(np.float64).values         
g_thickness14   = dfs.iloc[:,40].dropna().astype(np.float64).values

GA_15      = dfs.iloc[:,42].dropna().astype(np.float64).values           
g_thickness15  = dfs.iloc[:,43].dropna().astype(np.float64).values

GA_16        = dfs.iloc[:,45].dropna().astype(np.float64).values            
g_thickness16   = dfs.iloc[:,46].dropna().astype(np.float64).values       

GA_17        = dfs.iloc[:,48].dropna().astype(np.float64).values           
g_thickness17   = dfs.iloc[:,49].dropna().astype(np.float64).values

GA_18       = dfs.iloc[:,51].dropna().astype(np.float64).values        
g_thickness18 = dfs.iloc[:,52].dropna().astype(np.float64).values


fig_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18']
GA_list = [GA_1,GA_2,GA_3,GA_4,GA_5,GA_6,GA_7,GA_8,GA_9,GA_10,GA_11,GA_12,GA_13,GA_14,GA_15,GA_16,GA_17,GA_18]
thickness_list = [g_thickness1, g_thickness2, g_thickness3, g_thickness4, g_thickness5,g_thickness6, g_thickness7, g_thickness8, g_thickness9, g_thickness10,g_thickness11, g_thickness12, g_thickness13, g_thickness14, g_thickness15,g_thickness16, g_thickness17, g_thickness18]

objective_contraints="""
function derivative_loss(tree, dataset::Dataset{T,L}, options, idx)::L where {T,L}

	# Column-major:
	X = idx === nothing ? dataset.X : view(dataset.X, :, idx)
	y = idx === nothing ? dataset.y : view(dataset.y, idx)

	ŷ, completed = eval_tree_array(tree, X, options)
	!completed && return L(Inf)

	y_29GW = ŷ[1]
    if abs(y_29GW) > 10^(-3)
    return  L(Inf)
    end

    diffs = ŷ .- y
	mse = sum(diffs .^ 2) / length(y)
	return mse
end
"""

for i in [3]:
	print(i+1)
	GA = GA_list[i].reshape(-1, 1)
	thickness = thickness_list[i].reshape(-1, 1) - 1

	model = PySRRegressor(
		procs=6,
		populations=18,
		loss_function = objective_contraints,
		binary_operators=["+","*"],
		complexity_of_variables=2,
		complexity_of_constants=1,
		maxsize=30,
		maxdepth=10,
		enable_autodiff=True,
	    warmup_maxsize_by=0.1,
		niterations=1000,
	)


	model.fit(GA, thickness,variable_names=["t"])

	print(model.equations_)
	print(model.sympy())


	#calculate the R_square and mse
	from tabulate import tabulate
	x0 = sympy.Symbol('t')
	thickness_predict_model = model.sympy()
	thickness_predict_model_diff= sympy.diff(thickness_predict_model,x0)
	thickness_predict_expr = sympy.lambdify(('t'),thickness_predict_model,"numpy")
	thickness_predict_diff_expr = sympy.lambdify(('t'),thickness_predict_model_diff,"numpy")

	# predicted thickness
	thickness_predict = thickness_predict_expr(GA)

	# Calculate the MSE and R_square
	mse = np.power(thickness_predict - thickness, 2).mean()
	r_square = 1 - np.power(thickness - thickness_predict, 2).sum() / np.power(thickness - thickness.mean(), 2).sum()

	# Create a list of lists for the table
	table_data = [
	    ['Metric', 'Value'],
	    ['MSE', mse],
	    ['R-Squared', r_square]
	]

	# Create the table with horizontal lines
	table = tabulate(table_data, tablefmt='fancy_grid', numalign='right', stralign='left')
	# Display the table
	print(table)


	#plot the results
	import matplotlib.pyplot as plt
	import matplotlib as mpl
	from matplotlib import rcParams
	from matplotlib.ticker import AutoMinorLocator

	fig_growth = plt.figure(figsize=(8, 6))  # Adjust the figure size if needed
	# Adjust the position of the plot within the figure
	left, bottom, width, height = 0.2, 0.15, 0.9, 0.8
	plt.subplots_adjust(left,bottom,width )

	# Set custom font size and font family
	config = {
	    'text.usetex': True,
	    "font.family":'sans-serif',
	}
	rcParams['text.latex.preamble']=r"\usepackage{amsmath}"
	rcParams['font.sans-serif']='Times New Roman'
	rcParams.update(config)

	# Create the scatter plot
	plt.scatter(GA, thickness + 1, marker='o', s=60, c='#BBCCE9', edgecolor =(0,0,0,0.8), linewidths=1, label='Measured data')

	# Create the curve plot
	GA_plot = np.linspace(0, max(GA), 100)
	thickness_plot = thickness_predict_expr(GA_plot) + 1
	plt.plot(GA_plot, thickness_plot, color='#DC0000', linewidth = 4,label='Prediction')

	# Add R-squared value at the top (min(lam_ut)+max(lam_ut))/2
	plt.text(0.85, 1.35,"$R_2= $"+ ' ' + "{:.3f}".format(r_square, 3), fontsize=22, ha='center', va='center')
	plt.text(0.5, 1.45,"$g_r(t)= $"+' '+"$"+model.latex()+"+1"+"$", fontsize=24, ha='center', va='center',fontweight='bold')


	plt.xlabel('Rescaled Age (t)',fontsize=22)  
	plt.ylabel('Normalized Growth Ratio',fontsize=22)  
	plt.xlim(-0.05,1.05)
	plt.ylim(0.8,1.4)
	#ticks' properties
	plt.xticks((0,0.2,0.4,0.6,0.8,1), ('0.0','0.2','0.4','0.6','0.8','1.0'),size=22,color='k')
	plt.yticks((0.8, 1.0, 1.2,1.4),('0.8','1.0','1.2','1.4'), size=22,color='k')

	plt.minorticks_on()
	plt.gca().xaxis.set_minor_locator(AutoMinorLocator())
	plt.gca().yaxis.set_minor_locator(AutoMinorLocator())
	plt.tick_params(axis='both', which='major', direction='in', length= 4, width=1)
	plt.tick_params(axis='both', which='minor', direction='in', length= 2, width=0.75)
	ax = plt.gca()

	# Change the line width of the outer box (axes border)
	ax.spines['top'].set_linewidth(0.5)    # Top border
	ax.spines['right'].set_linewidth(0.5)  # Right border
	ax.spines['bottom'].set_linewidth(1) # Bottom border
	ax.spines['left'].set_linewidth(1)   # Left border

	# Show the legend if multiple datasets are plotted
	plt.legend(frameon=False, loc='upper left',handlelength=1.5, fontsize=22)
	# Save the plot
	# plt.savefig("growth-thickness_fit_region"+fig_list[i]+".tiff",dpi=300, bbox_inches='tight', pad_inches=0.05)
	# Show the plot
	# plt.show()
	print(model)
