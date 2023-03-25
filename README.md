# Supplementary Data Codes 

**Atomic-scale identification of the active sites of nanocatalysts**

Yao Yang<sup>1*</sup>, Jihan Zhou<sup>1*</sup>, Zipeng Zhao<sup>2*</sup>, Geng Sun<sup>3*</sup>, Saman Moniri<sup>1</sup>, Colin Ophus<sup>4</sup>, Yongsoo Yang<sup>2</sup>, Ziyang Wei<sup>5</sup>, Yakun Yuan<sup>1</sup>, Cheng Zhu<sup>6</sup>, Yang Liu<sup>2</sup>, Qingying Jia<sup>7</sup>, Hendrik Heinz<sup>6</sup>, Peter Ercius<sup>4</sup>, Philippe Sautet<sup>3,5</sup>, Yu Huang<sup>1</sup> & Jianwei Miao<sup>1†</sup>    

*<sup>1</sup>Department of Physics & Astronomy and California NanoSystems Institute, University of California, Los Angeles, CA 90095, USA.*    
*<sup>2</sup>Department of Materials Science and Engineering, University of California, Los Angeles, CA 90095, USA.*     
*<sup>3</sup>Department of Chemical and Biomolecular Engineering, University of California, Los Angeles, Los Angeles, CA 90095, USA.*     
*<sup>4</sup>National Center for Electron Microscopy, Molecular Foundry, Lawrence Berkeley National Laboratory, Berkeley, CA 94720, USA.*   
*<sup>5</sup>Department of Chemistry and Biochemistry, University of California, Los Angeles, Los Angeles, CA 90095, USA.*     
*<sup>6</sup>Department of Chemical and Biological Engineering, University of Colorado at Boulder, Boulder, CO, USA.*      
*<sup>7</sup>Department of Chemistry and Chemical Biology, Northeastern University, Boston, MA, USA.*     
**These authors contributed equally to this work.*     
*†Correspondence and requests for materials should be addressed to J.M. (miao@physics.ucla.edu).*  

## Contents

- [Overview](#overview)
- [System Requirements](#system-requirements)
- [Repositary Contents](#repositary-contents)

# Overview

Heterogeneous catalysts play a key role in the chemical and energy industries1. To date, most industrial-scale heterogeneous catalytic reactions have relied on nanocatalysts. However, despite significant progress from theoretical, experimental and computational studies, identifying the active sites of alloy nanocatalysts remains a major challenge. This limitation is mainly due to an incomplete understanding of the three-dimensional (3D) atomic and chemical arrangement of different constituents and structural reconstructions driven by catalytic reactions. 

Here, we use atomic electron tomography to determine, for the first time, the 3D local atomic structure, surface morphology and chemical composition of Pt alloy nanocatalysts for the electrochemical oxygen reduction reaction (ORR). We reveal the facet, surface concaveness, structural and chemical order/disorder, coordination number, and bond length with unprecedented 3D atomic detail. The experimental 3D atomic coordinates are used by first-principles trained machine learning to identify the active sites of the nanocatalysts, which are corroborated by electrochemical measurements. By analyzing the structure-activity relationship, we formulate an equation named the local environment descriptor (LED) to balance the strain and ligand effects and gain physical and chemical insight into the ORR active sites of the Pt alloy nanocatalysts. The experimental data and source codes for the 3D image reconstruction and post analysis are provided here.

# System Requirements

We recommend a computer with 16G DRAM, standard i7 4-core CPU, and a GPU to run most data analysis source codes. But for the 3D reconstruction of the experimental data with RESIRE, atomic tracing and the determination of the MROs, we recommend a computer with large memory (256G DRAM, 16-core CPU and 1 GPU).

## Software Requirements

### OS Requirements

This package has been tested on the following Operating System:

Linux: CentOS 6 2.6.32    
Windows: Windows 10 18368.778    
Mac OSX: We have not tested it on a Mac yet, but it should in principle work.     

### Matlab Version Requirements

This package has been tested with `Matlab` R2019b. All the codes have to run in their own folders. We recommend the use of `Matlab` version R2018a or higher to test the data and source codes.

# Repositary Contents

### 1. Experiment Data

Folder: [Measured_data](./1_Measured_data)

This folder contains the experimental projections after denoising and alignment as well as their corresponding angles for all Pt alloys in the experiments.

### 2. Reconstructed 3D Volume

Folder: [Final_reconstruction_volume](./3_Final_reconstruction_volume)

This folder contains the 3D volume of all Pt alloys in the experiments reconstructed by projections and angles in [Measured_data](./1_Measured_data).

### 3. Experimental Atomic Model

Folder: [Final_coordinates](./4_Final_coordinates)

The final 3D atomic model and chemical species (i.e. type 1, 2 and 3) of the glass-forming nanoparticle.

### 4. Post Data Analysis —— Nanoparticle properties

Folder: [Data_analysis_np_properties](./7_Data_analysis_np_properties)

Run the code `Main_1_pdf_and_boo_calculation_all_atoms.m` to calculate the radial distribution function and the bond orientation order parameter for all the atoms in the glass-forming nanoparticle; Run the code `Main_2_pdf_calculation_amorphous_region.m` to compute the radial distribution function and pair distribution function for all the amorphous atoms in the sample; Run the code `Main_3_voronoi_calculation_amorphous_region.m` to determine the Voronoi indices for all the atoms in the sample.

### 5. Post Data Analysis —— Local environment descriptor

Folder: [Data_analysis_LED](./8_Data_analysis_LED)


Run the code `Main_1_fitting_LED_equation.m` to calculate the error of different descriptors conbination with equation 
<img src="https://render.githubusercontent.com/render/math?math={x_{1} \times \exp{-a_{1} x_{2}}}"> the possible MROs based on the breadth first search algorithm; Run the code `Main_2_final_mro.m` to determine the final MROs in the glass-forming nanoparticle.

