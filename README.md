# Supplementary Data

Atomic-scale identification of the active sites of nanocatalysts

Coherent Imaging Group, UCLA

## Contents

- [Overview](#overview)
- [System Requirements](#system-requirements)
- [Repo Contents](#repo-contents)

# Overview

Heterogeneous catalysts play a key role in the chemical and energy industries1. To date, most industrial-scale heterogeneous catalytic reactions have relied on nanocatalysts. However, despite significant progress from theoretical, experimental and computational studies, identifying the active sites of alloy nanocatalysts remains a major challenge. This limitation is mainly due to an incomplete understanding of the three-dimensional (3D) atomic and chemical arrangement of different constituents and structural reconstructions driven by catalytic reactions. Here, we use atomic electron tomography to determine, for the first time, the 3D local atomic structure, surface morphology and chemical composition of Pt alloy nanocatalysts for the electrochemical oxygen reduction reaction (ORR). We reveal the facet, surface concaveness, structural and chemical order/disorder, coordination number, and bond length with unprecedented 3D atomic detail. The experimental 3D atomic coordinates are used by first-principles trained machine learning to identify the active sites of the nanocatalysts, which are corroborated by electrochemical measurements. By analyzing the structure-activity relationship, we formulate an equation named the local environment descriptor to balance the strain and ligand effects and gain physical and chemical insight into the ORR active sites of the Pt alloy nanocatalysts. The experimental data and source codes for the 3D image reconstruction and post analysis are provided here.

# System Requirements

## Hardware Requirements

Most of the AET processing codes require only a standard computer with enough RAM to support the operations defined by a user. For minimal performance, this will be a computer with about 2 GB of RAM. For optimal performance, we recommend a computer with 16G DRAM, standard i7 4-core CPU, and a GPU, which could support running of `RESIRE` package on a projection set with less than 100 pixel size.
Users could check the code `Main_RESIRE_sample.m` in folder `2_RESIRE_package`.

When the matrix size is larger than 100^3 (such as 320^3 for the experimental data here). It is better to use super computer with larger memory (Testing environment: 256G DRAM, 16-core CPU, 1 GPU).

## Software Requirements

### OS Requirements

The package development version is tested on Linux operating systems. The developmental version of the package has been tested on the following systems:

Linux: CentOS 6 2.6.32   
Mac OSX:   
Windows: Windows 10 18368.778   

### Matlab Version Requirements

The package is tested with `Matlab` R2020b. For correctly using of this package, we suggest `Matlab` version R2018a or higher.

# Repo Contents

### 1. Input Experiment Data

Folder: [1_Measured_data](./1_Measured_data)

Denoised and aligned experimental projections by applying the Block-Matching and 3D filtering (BM3D) algorithm for the Metallic Glass sample. Please visit [BM3D package](http://www.cs.tut.fi/~foi/GCF-BM3D/) for more details.

### 2. RESIRE Package

Folder: [2_RESIRE_package](./2_RESIRE_package)

The Real Space Iterative Reconstruction (RESIRE) algorithm package. Run the sample code `Main_RESIRE_sample.m` to see the reconstruction from smaller size sample. Run the main code `Main_RESIRE_MG.m` to get the reconstruction of Metallic Glass nanoparticle.

### 3. Output Experiment Reconstruction Volume

Folder: [3_Final_reconstruction_volume](./3_Final_reconstruction_volume)

The Final reconstruction volume of the Metallic Glass nanoparticle achieved from Main_RESIRE_MG.m.

### 4. Tracing and Classification

Folder: [4_Tracing_and_classification](./4_Tracing_and_classification)

Run the main code `Main_polynomial_tracing.m` to get the initial tracing results from the reconstruction volume. After manually check the peak position, run the main code `Main_classification.m` to get the atomic species results of the Metallic Glass nanoparticle.

### 5. Position Refinement

Folder: [5_Position_refinement](./5_Position_refinement)

Run the main code `Main_position_refinement.m` to get the finalized atomic position of Metallic Glass nanoparticle.

### 6. Output Experimental Atomic Model

Folder: [6_Final_coordinates](./6_Final_coordinates)

The Final atomic model and species of the Metallic Glass nanoparticle.

### 7. Post Data Analysis —— Short Range Order

Folder: [7_Data_analysis_sro](./7_Data_analysis_sro)

Run the code `Main_1_rdf_and_boo_calculation_all_atoms.m` to get the Radial Distribution Function (RDF) and Bond Orientation Order (BOO) for all atoms in the Metallic Glass nanoparticle; Run the code `Main_2_rdf_calculation_amorphous_region.m` to get the Radial Distribution Function (RDF) and Pair Distribution Function (PDF) for amorphous atoms in the Metallic Glass nanoparticle; Run the code `Main_3_voronoi_calculation_amorphous_region.m` to get the Voronoi index for all atoms in the Metallic Glass nanoparticle.

### 8. Post Data Analysis —— Medium Range Order

Folder: [8_Data_analysis_mro](./8_Data_analysis_mro)

Run the code `Main_1_potential_mro.m` to calculate the potential Medium Range Order (MRO) networks based on breadth first search algorithm; Run the code `Main_2_final_mro.m` to get the final MRO networks to fill in the whole nanoparticle.
