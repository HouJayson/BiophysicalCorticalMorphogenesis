import sys
from odbAccess import openOdb
import numpy as np
import xlsxwriter


# Function to extract global coordinates from point set
def extract_point_set_coordinates_global(odb_path,instance_name,point_set_name,frameID):
    odb = openOdb(odb_path)
    assembly = odb.rootAssembly
    instance = assembly.instances[instance_name]
    point_set = instance.nodeSets[point_set_name]
    # Extract coordinates of the point set
    coordinates = {}
    frame=odb.steps['Step-1'].frames[frameID]
    coords = frame.fieldOutputs['COORD']
    mySetCoord = coords.getSubset(region=point_set)   #data
    fieldValues1 = mySetCoord.values
    for v in fieldValues1:
        node_label=v.nodeLabel
        node_coords_vec=[v.data[0],v.data[1],v.data[2]]
        coordinates[node_label] = node_coords_vec
    odb.close()
    return coordinates

# Function to extract ROI region nodal index (sorted ascending)
def extract_point_set_label(odb_path,instance_name,point_set_name):
    odb = openOdb(odb_path)
    assembly = odb.rootAssembly
    instance = assembly.instances[instance_name]
    point_set = instance.nodeSets[point_set_name]

    # Extract node labels
    label_sequence = []
    
    for i in range(len(point_set.nodes)):
        label_sequence.append(point_set.nodes[i].label)  # Store node labels in a list
    odb.close()
    
    # Sort the list of labels
    sorted_label_sequence = sorted(label_sequence)
    # sorted_label_sequence = label_sequence
    return sorted_label_sequence

# Function to extract displacement from point set
def extract_point_set_displacement_global(odb_path,instance_name,point_set_name,frameID):
    odb = openOdb(odb_path)
    assembly = odb.rootAssembly
    instance = assembly.instances[instance_name]
    point_set = instance.nodeSets[point_set_name]
    # Extract displacement of the point set
    displacement = {}
    frame=odb.steps['Step-1'].frames[frameID]
    disp =  frame.fieldOutputs['U']
    mySetDisp = disp.getSubset(region=point_set)
    for v in mySetDisp.values:
        node_label=v.nodeLabel
        node_disp_vec=[v.data[0],v.data[1],v.data[2]]
        displacement[node_label] = np.linalg.norm(node_disp_vec)
    odb.close()
    return displacement  


# Main function
def main():
    for s in range(1, 10):
        for region in ['GRAY', 'WHITE', 'MEDIUM']:
            odb_path = f'path_to_odb/Brain_S{s:02d}.odb'   # file path of odb file  
            file_path = 'path_for_excel'   # file path for output excel data
            excel_name = f'Data_{region.lower()}_S{s}_.xlsx'
            instance_name = 'BRAIN-1'
            point_set_name = f'SET-NODE-{region}-OUTERMOST'

            # Extract node labels in sequence
            extraction_sequence = extract_point_set_label(odb_path, instance_name, point_set_name)

            # Create an Excel workbook and add a worksheet
            workbook = xlsxwriter.Workbook(file_path + excel_name)

            # Loop over frames and extract global coordinates and displacement
            for j in range(0, 101, 1):
                print(j)
                coordinates_frame_global = extract_point_set_coordinates_global(odb_path, instance_name, point_set_name, j)
                displacement_frame_global = extract_point_set_displacement_global(odb_path, instance_name, point_set_name, j)

                # Prepare data for writing (x, y, z coordinates and displacement)
                data = [
                    [
                        float(x) if np.isfinite(x) else "#ERROR" 
                        for x in [
                            coordinates_frame_global[node_label][0],
                            coordinates_frame_global[node_label][1],
                            coordinates_frame_global[node_label][2],
                            displacement_frame_global[node_label]
                        ]
                    ]
                    for node_label in extraction_sequence
                ]

                # Add a worksheet for the current frame
                worksheet = workbook.add_worksheet(f'Frame{j}')

                # Write data to the worksheet
                for row_num, row_data in enumerate(data):
                    worksheet.write_row(row_num, 0, [float(x) if isinstance(x, np.float32) else x for x in row_data])

            # Close the workbook to save the Excel file
            workbook.close()

if __name__ == "__main__":
    main()

