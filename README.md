# Classical Digital Image Processing for Reflection and Glass-Ghost Suppression in Indoor Glass Photography

### Project Description:

#### Summary -

This project focuses on detecting and suppressing reflections and glass-ghost effects in indoor glass photography using classical Digital Image Processing techniques. 
It implements an integrated MATLAB-based pipeline involving image analysis, automatic reflection detection, interactive manual mask refinement and image reconstruction.

#### Course concepts used -

**Unit 1 – Digital Image Fundamentals**
1. RGB and grayscale image representation.
2. Pixel intensity and intensity distribution.
3. Image histogram analysis.

**Unit 2 – Image Transforms**
1. Two-Dimensional Discrete Fourier Transform (2D-DFT).
2. Fourier spectrum analysis.
3. Frequency-domain representation of images.

**Unit 3 – Image Enhancement and Restoration**
1. Spatial filtering – Averaging, Median and Gaussian filters.
2. Image sharpening.
3. Edge detection – Canny operator.
4. Morphological operations – Top-hat transformation and closing.
5. Image restoration – Region-based inpainting using `regionfill()`.

**Unit 4 – Image Segmentation and Analysis**
1. Intensity-based segmentation using local intensity differences.
2. Local contrast analysis for reflection candidate detection.
3. Morphological mask refinement and connected-region processing.
4. Interactive region selection and binary mask manipulation..

#### Additional concepts used -

1. **Automatic Reflection Detection**
   - Local intensity difference and local contrast analysis to identify potential reflection regions.

2. **Interactive Mask Refinement and Image Inpainting**
   - Manual mask addition and removal using freehand selection.
   - Region-based image reconstruction using MATLAB's `regionfill()` function.


#### Dataset -

A self-created dataset consisting of indoor glass photographs containing different types of reflections and glass-ghost effects.
The images are used to evaluate automatic reflection detection, manual mask refinement and single-view reconstruction.


#### Novelty -

1. Development and use of a self-created dataset of indoor glass photographs rather than relying entirely on standard benchmark datasets.
2. Integration of automatic intensity- and contrast-based reflection detection with interactive manual mask refinement.
3. Implementation of a unified, single-view reflection suppression pipeline using purely classical Digital Image Processing techniques without deep learning or pretrained models.

### Contributors:

1.Sumaiya Parveen (PES1UG24EC341)
2.Vachana Hiremath( PES1UG24EC230)
3.teja(PES1UG24EC)


### Steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/DIP-2026-MINI-PROJECT/Classical-DIP-Reflection-Removal.git
   ```

2. Open MATLAB (R2024b or compatible version).
3. Open the cloned project folder in MATLAB.
4. Ensure the Image Processing Toolbox is installed.
5. Run the main MATLAB script:
   ```matlab
   ghostimgs_reflection_suppression.m
   ```
6. Select an indoor glass photograph when prompted.
7. Inspect the automatically detected reflection regions and use the interactive mask editor to add or remove regions.
8. Confirm the final mask to perform reflection removal and view the reconstructed output.

### Outputs:

- Original RGB and grayscale images.
- Grayscale histogram and horizontal intensity profile.
- 2D Fourier magnitude spectrum.
- Spatial filtering and image sharpening results.
- Canny edge detection and morphological processing results.
- Automatically detected reflection candidate regions.
- Manual verification and editing
- Interactive and final reflection masks.
- Final reconstructed image after reflection suppression.

### References:

1. Gonzalez, R. C., and Woods, R. E., *Digital Image Processing*, 4th Edition, Pearson.
2. Levin, A., and Weiss, Y. (2007). "User Assisted Separation of Reflections from a Single Image Using a Sparsity Prior."
    IEEE Transactions on Pattern Analysis and Machine Intelligence, 29(9), 1647–1654. https://doi.org/10.1109/TPAMI.2007.1106
3.Huang, Y., Quan, Y., Xu, Y., Xu, R., and Ji, H. (2020). "Removing Reflection From a Single Image With Ghosting Effect."
    IEEE Transactions on Computational Imaging, 6, 34–45. https://doi.org/10.1109/TCI.2019.2899320
4. MathWorks Documentation:
   - `regionfill()` – Image Processing Toolbox.
   - `imgaussfilt()` – Gaussian filtering.
   - `stdfilt()` – Local standard deviation filtering.
   - `drawfreehand()` – Interactive ROI selection.

### Limitations and Future Work:

- Single-view reconstruction cannot reliably recover scene details completely hidden by reflections; multi-view approaches can provide additional information from other viewpoints.
- Region-based inpainting may produce smooth patches or texture loss when reflections cover complex objects or large areas.
- Future work can explore texture-aware and patch-based inpainting methods to improve reconstruction quality.
