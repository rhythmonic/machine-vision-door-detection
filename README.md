
# Machine Vision Door Detection and Localization

## Overview

This project implements a complete classical computer vision pipeline for detecting and localizing a door in an image using MATLAB.

The system processes an input image, extracts characteristic door-gap features, segments the door contours, detects straight-line boundaries using the Hough Transform, and computes the four corner coordinates of the door through geometric line intersection.

The project demonstrates fundamental machine vision concepts commonly used in robotics, industrial inspection, autonomous systems, and perception pipelines.

---

## Features

### Image Preprocessing
- RGB to grayscale conversion
- Contrast enhancement using histogram adjustment
- Noise reduction using a 5×5 separable binomial filter

### Feature Extraction
- Sobel gradient computation in x and y directions
- Gradient magnitude analysis
- Detection of light-to-dark and dark-to-light transitions

### Image Segmentation
- Threshold-based segmentation
- Morphological filtering
- Door-gap contour extraction

### Line Detection
- Hough Transform
- Hough Peak Detection
- Extraction of dominant door boundary lines

### Geometric Analysis
- Classification of vertical and horizontal door edges
- Line representation using Hesse Normal Form
- Computation of line intersections
- Sub-pixel corner estimation

---

## Processing Pipeline

```text
Input Image
      │
      ▼
Grayscale Conversion
      │
      ▼
Contrast Enhancement
      │
      ▼
Noise Filtering
      │
      ▼
Sobel Gradient Extraction
      │
      ▼
Thresholding
      │
      ▼
Morphological Processing
      │
      ▼
Door Gap Segmentation
      │
      ▼
Hough Transform
      │
      ▼
Line Classification
      │
      ▼
Corner Detection
```

---

## Results

The algorithm successfully identifies:

- Left door boundary
- Right door boundary
- Upper door boundary
- Lower door boundary

and estimates the four corner points:

- Top Left (LU)
- Top Right (RU)
- Bottom Left (LB)
- Bottom Right (RB)

These corner points can be used for further pose estimation and camera localization tasks.

---

## Technologies Used

- MATLAB
- Image Processing Toolbox
- Hough Transform
- Morphological Image Processing
- Gradient-Based Feature Extraction

---

## Example Outputs

### 1. Contrast Enhanced Image
Improved visibility of door contours and structural features.

### 2. Gradient Extraction
Sobel gradients highlight strong intensity transitions corresponding to door edges.

### 3. Door Gap Segmentation
Morphological operations isolate the door contours from background structures.

### 4. Hough Line Detection
Dominant vertical and horizontal door boundaries are extracted.

### 5. Corner Localization
Door corner coordinates are computed using geometric line intersections.

---

## Applications

This project demonstrates techniques commonly used in:

- Robotics Perception
- Autonomous Navigation
- Industrial Inspection
- Visual Localization
- Machine Vision Systems
- Geometric Object Detection

