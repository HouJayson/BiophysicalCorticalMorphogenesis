import sympy 
import numpy as np
import pandas as pd
from pysr import PySRRegressor

from pysr.julia_helpers import init_julia

from julia import SymbolicRegression  # Needed to load library (usually this is done by .fit())
from julia import Serialization
from julia import MLJ
from julia import Zygote
from julia import SymbolicUtils

# # Dataset
import os
file_name="file-to-areaData"  


dfs = pd.read_excel(file_name, sheet_name='summary_normalizedArea',engine='openpyxl')
GA_1        = dfs.iloc[:,0].dropna().astype(np.float64).values            
g_square1   = dfs.iloc[:,1].dropna().astype(np.float64).values       

GA_2        = dfs.iloc[:,3].dropna().astype(np.float64).values           
g_square2   = dfs.iloc[:,4].dropna().astype(np.float64).values

GA_3       = dfs.iloc[:,6].dropna().astype(np.float64).values        
g_square3  = dfs.iloc[:,7].dropna().astype(np.float64).values

GA_4        = dfs.iloc[:,9].dropna().astype(np.float64).values         
g_square4   = dfs.iloc[:,10].dropna().astype(np.float64).values

GA_5      = dfs.iloc[:,12].dropna().astype(np.float64).values           
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

GA_white1  = dfs.iloc[:,54].dropna().astype(np.float64).values 
g_square_white1 = dfs.iloc[:,55].dropna().astype(np.float64).values

fig_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19']
GA_list = [GA_1,GA_2,GA_3,GA_4,GA_5,GA_6,GA_7,GA_8,GA_9,GA_10,GA_11,GA_12,GA_13,GA_14,GA_15,GA_16,GA_17,GA_18,GA_white1]
g_square_list = [g_square1, g_square2, g_square3, g_square4, g_square5,g_square6, g_square7, g_square8, g_square9, g_square10,g_square11, g_square12, g_square13, g_square14, g_square15,g_square16, g_square17, g_square18, g_square_white1]


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
for i in range(18):
	GA = GA_list[i].reshape(-1, 1)
	g_square = g_square_list[i].reshape(-1, 1) - 1
	print(i)


	model = PySRRegressor(
	procs=6,
	populations=18,
	loss_function = objective_contraints,
	binary_operators=["+","*"],
	unary_operators=["exp","log","tanh","square","cube"],
	complexity_of_operators={"exp":2,"log":2,"tanh":1},
    nested_constraints={"exp": { "exp":0,"log":0,"tanh":0,"square":1,"cube":1},
					"log": { "exp":0,"log":0,"tanh":0,"square":1,"cube":1},
					"tanh": { "exp":0,"log":0,"tanh":0,"square":1,"cube":1,"+":0},
					"square": { "exp":0,"log":0,"tanh":0,"square":0,"cube":0},
					"cube": { "exp":0,"log":0,"tanh":0,"square":0,"cube":0}},
	complexity_of_variables=2,
	complexity_of_constants=1,
	maxsize=100,
	maxdepth=10,
	enable_autodiff=True,
    warmup_maxsize_by=0.1,
	niterations=1000,)


	model.fit(GA, g_square,variable_names=["t"])

	print(model.equations_)
	print(model.sympy())


	#calculate the R_square and mse
	from tabulate import tabulate
	x0 = sympy.Symbol('t')
	g_square_predict_model = model.sympy()
	g_square_predict_expr = sympy.lambdify(('t'),g_square_predict_model,"numpy")

	# predicted g_square
	g_square_predict = g_square_predict_expr(GA)

	# Calculate the MSE and R_square
	mse = np.power(g_square_predict - g_square, 2).mean()
	r_square = 1 - np.power(g_square - g_square_predict, 2).sum() / np.power(g_square - g_square.mean(), 2).sum()

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
	plt.scatter(GA, g_square + 1, marker='o', s=60, c='#BBCCE9', edgecolor =(0,0,0,0.8), linewidths=1, label='Measured data')

	# Create the curve plot
	GA_plot = np.linspace(min(GA), max(GA), 100)
	g_square_plot = g_square_predict_expr(GA_plot) + 1
	plt.plot(GA_plot, g_square_plot, color='#DC0000', linewidth = 4,label='Prediction')

	# Add R-squared value at the top (min(lam_ut)+max(lam_ut))/2
	plt.text(0.85, 3.5,"$R_2= $"+ ' ' + "{:.3f}".format(r_square, 3), fontsize=22, ha='center', va='center')
	plt.text(0.5, 4.3,"$g_t(t)= $"+' '+"$"+model.latex()+"+1"+"$", fontsize=24, ha='center', va='center')


	plt.xlabel('Rescaled Age (t)',fontsize=22)  
	plt.ylabel('Normalized Growth Ratio',fontsize=22)  
	plt.xlim(-0.05,1.05)
	plt.ylim(0,4)
	#ticks' properties
	plt.xticks((0,0.2,0.4,0.6,0.8,1), ('0.0','0.2','0.4','0.6','0.8','1.0'),size=22,color='k')
	plt.yticks((0, 1, 2, 3, 4),('0','1','2','3','4'), size=22,color='k')

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
	plt.legend(frameon=False, loc='upper left',handlelength=1.5, fontsize=18)
	# Save the plot
	plt.savefig("growth-region_"+fig_list[i]+".tiff",dpi=300,bbox_inches='tight', pad_inches=0.05)
	# Show the plot
	# plt.show() 
	print(model)


