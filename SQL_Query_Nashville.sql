SELECT * FROM dbo.NashvilleHousing;

SELECT SaleDate FROM dbo.NashvilleHousing;


-- Standardize Date Format

-- Converting SaleDate column into 'DATE' type.
SELECT saleDateConverted, CONVERT(Date, SaleDate)
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)