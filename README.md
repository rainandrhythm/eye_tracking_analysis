# eye_tracking_analysis
Eye-tracking analysis of how image features influence visual attention and gaze allocation.

**Overview**

Visual attention is guided by a combination of low-, mid-, and high-level image features. This project investigates how visual features influence gaze allocation by analyzing fixation locations in grayscale images.

**Research Question**

Do specific image features predict where people look?
The analysis tests whether saliency values at fixation locations are greater than those at randomly sampled locations.

**Methods**

Saliency maps were generated for four image features:

Local contrast: Local luminance variability was calculated using a 7 × 7 sliding-window standard deviation filter (stdfilt).

Edge strength: Edges were detected using the Sobel operator to identify regions of rapid intensity change.

Brightness: Raw grayscale luminance was used to assess whether absolute brightness predicts fixation location.

Center bias: A two-dimensional Gaussian centered on the image midpoint was used to model the tendency for viewers to fixate near the center of an image.

All saliency maps were z-score normalized to enable comparison across images.

For each image, saliency values were extracted at observed fixation locations and at an equal number of randomly sampled control locations. A paired-samples t-test was used to determine whether saliency was greater at fixation locations than at random locations. Cohen's d was calculated to quantify effect size.

**Results**

Fixation Patterns

Fixation locations were not uniformly distributed across images but clustered in visually salient regions. Qualitative inspection suggested that gaze was influenced by multiple image properties, including local contrast, prominent edges, brightness, and image-center location.

Local Contrast

Fixation locations had significantly higher local-contrast saliency than randomly sampled locations:

p = 8.82 × 10⁻⁶

Cohen's d = 0.251

This indicates a positive association between local luminance variability and fixation location.

Edge Strength

Edge strength did not significantly differ between fixation and random locations:

p = 0.497

Cohen's d = 0.039

This suggests that edge strength alone was not a reliable predictor of fixation behavior in this dataset.

Brightness

Absolute brightness was also not a significant predictor:

p = 0.350

Cohen's d = −0.054

Although some fixations occurred in particularly bright or dark regions, this relationship was not consistent across images.

Center Bias

Center bias showed the strongest association with fixation locations:

p = 1.10 × 10⁻¹⁵

Cohen's d = 0.459

Fixations occurred significantly closer to the image center than would be expected from randomly sampled locations, demonstrating a substantial positional bias in gaze allocation.

**Conclusion**

The findings suggest that gaze allocation cannot be explained by a single low-level visual feature. Local contrast predicted fixation locations, while edge strength and absolute brightness did not. The strong center-bias effect further demonstrates that gaze behavior is influenced by spatial viewing tendencies in addition to image-derived visual features.

More broadly, the results are consistent with the idea that visual attention reflects interactions between low-level visual properties, spatial viewing biases, and higher-level factors such as semantic meaning, object relevance, and scene interpretation.

**Data Availability**

The eye-tracking dataset was provided by the course instructor and is therefore not included in this repository.

**Code**

The code/ directory contains the scripts used for saliency-map generation and quantitative analysis.
