# Modeling Antibacterial Properties Based on Cerium Concentrations

## General Information
This project aims to model the survival of certain bacteria in the presence of a material with varying concentrations of cerium. The dataset used includes several characteristics of the material and bacteria, as well as parameters related to the material's structure and optical properties.

## Data 
The datase contains 432 records, each representing different concentrations of cerium in the presence of various bacteria. The data includes measurements and characteristics related to the material composition, bacterial survival, and other structural and optical properties.

* **Material**: The type of material being analyzed.
* **Contenio_Cerio**: (Cerium Content): The concentration of cerium in the material.
* **Time**: The duration over which bacterial survival was monitored.
* **Concentracion_material**: (Material Concentration): The overall concentration of the material in the experiment.
* **Supervivencia (Survival)**: The survival rate of the bacteria in the presence of the material.
* **Bacteria**: The specific type of bacteria being tested.
* **Lambda, Theta**: Parameters related to the material's structural properties.
* **a, c, D, d, c/a_ratio, v, ρ, R, n, V, APF, Positional**: Additional structural characteristics of the material, including dimensions, volume, and ratios.
* **b, b1, b2, b3**: Further parameters describing the material’s physical and structural properties.
* **alpha, beta**: Angles related to the material's crystalline structure.
* **Zn**: Zinc concentration in the material.
* **Ce**: Concentration of cerium in the material, similar to Contenio_Cerio.
* **Optical_band**: The optical bandgap of the material, indicating its optical properties.

## Methodology
**1. Initial Analysis and Preprocessing**

Highly correlated variables were identified and removed using Spearman's correlation method. This step is crucial to avoid multicollinearity issues in regression models.

**2. Linear Modeling**

Several linear regression models were constructed to analyze the relationship between variables and bacterial survival. Models with and without intercepts were fitted, but it was observed that the relationship between the variables was not linear.

**3. Non-Linear Modeling with MARS**

Since the linear models did not provide a good fit, the Multivariate Adaptive Regression Splines (MARS) method was used to capture non-linear relationships. Different configurations of degree and nprune were experimented with to optimize the model.

**4. Cross-Validation**

10-fold cross-validation was applied to evaluate the performance of the MARS models and select the best combination of parameters. The best model obtained has degree = 3 and nprune = 10.
![imagen](https://github.com/user-attachments/assets/7f084d88-95d4-49ab-9b75-ad03efb62d5e)



**5. Model Evaluation**

The final model was evaluated using an independent test dataset. Error metrics such as RMSE and MAE were calculated to quantify the model's accuracy.
