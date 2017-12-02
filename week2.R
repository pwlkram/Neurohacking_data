install.packages('oro.dicom')
install.packages('oro.nifti')
library(oro.dicom)
library(oro.nifti)
slice = readDICOM('BRAINIX/DICOM/FLAIR')
class(slice)
names(slice)
class(slice$hdr)
class(slice$hdr[[1]])
class(slice$img)
class(slice$img[[1]])
slice$img[[1]]
dim(slice$img[[1]])
?t
d = dim(t(slice$img[[11]]))
image(1:d[1], 1:d[2], t(slice$img[[11]]), col=gray(0:64/64))


#choose just small matrix of voxels
slice$img[[11]][101:105, 121:125]
# higher intensities = higher numbers
# histogram of the whole image
hist(slice$img[[11]][,], breaks = 50, xlab="FLAIR",
     prob = T, col = rgb(0,0,1,1/4), main = "")

# DICOM HEADER
hdr = slice$hdr[[11]]
names(hdr)
hdr$name
# 162 fields
hdr[hdr$name == "PixelSpacing", "value"]
# "0.79861110448837 0.79861110448837"  <- MILIMETERS
hdr[hdr$name =="FlipAngle",]
# FlipAngle - aquisition parameters - here FlipAngle is 4

# group element      name code length value sequence
# 107  0018    1314 FlipAngle   DS      4  90.0 

all_slices_T1 = readDICOM("BRAINIX/DICOM/T1")
dim(all_slices_T1$img[[11]])
# 512 512 - higher resolution
hdr = all_slices_T1$hdr[[11]]
hdr[hdr$name == "PixelSpacing",]

# convert to NIfTI
nii_T1 = dicom2nifti(all_slices_T1)
d = dim(nii_T1); d; class(nii_T1)
image(1:d[1], 1:d[2], nii_T1[,,11], col = gray(0:64/64), xlab="", ylab = "")
image(1:d[2], 1:d[3], nii_T1[128,,], col = gray(0:64/64), xlab="", ylab = "")

setwd("D:/R/neurohacking/Neurohacking_data/BRAINIX/NIfTI")
fname= "Output_3D_File"
writeNIfTI(nim=nii_T1,filename = fname)
list.files()
list.files(pattern = "Output_3D_File")
list.files(pattern = "T")
nii_T2=readNIfTI("T2.nii.gz", reorient = FALSE)
dim(nii_T2)
?readNIfTI

print({nii_T1 = readNIfTI(fname = fname)})
# oro.nifti has special image function different from R image
image(nii_T1, z = 11, plot.type = "single")
image(nii_T1, plot.type = "multiple") # = image(nii_T1)
image(nii_T1, plane = "axial")
ortographic(nii_T1, xyz=c(200, 220, 11))