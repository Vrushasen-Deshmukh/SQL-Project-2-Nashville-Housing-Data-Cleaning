SELECT * FROM NashvilleHousing

-- Standardize Date Format
SELECT SaleDate, CONVERT(Date, SaleDate)         -- Converts the 'SaleDate' value into the 'Date' type, removing any 'time' component that might be present in the original format.
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;                      -- This adds a new column named SaleDateConverted, which will store values in the Date format.

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT * FROM NashvilleHousing


-- ------------------------------------------------------------------------------------------------------


-- Populate Property Address Data
SELECT *
FROM NashvilleHousing
-- WHERE PropertyAddress is NULL
ORDER BY ParcelID

SELECT *
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- ------------------------------------------------------------------------------------------------------


-- Breaking out address into Individual Columns (Address, City, State)

-- SPLITTING PROPERTYADDRESS COLUMN INTO 2 DIFFERENT COLUMNS - PropertySplitAddress and PropertySplitCity
Select PropertyAddress 
FROM NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(250);                      
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(250);                      
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * FROM NashvilleHousing



-- SPLITTING OWNER ADDRESS INTO 3 SEPERATE COLUMNS - OwnerSplitAddress, OwnerSplitCity and OwnerSplitState
SELECT owneraddress FROM NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(250);                      
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(250);                      
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(250);                      
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


SELECT * FROM NashvilleHousing


-- ------------------------------------------------------------------------------------------------------



-- CHANGE Y AND N TO Yes AND No IN "SoldAsVacant" FIELD

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM NashvilleHousing   -- Finding out how many and what distinct values are present in the column.
GROUP BY SoldAsVacant
ORDER BY 2   -- Finding out how many values respectively


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END


-- ------------------------------------------------------------------------------------------------------


-- REMOVE DUPLICATES

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


-- ------------------------------------------------------------------------------------------------------


-- DELETE UNUSED COLUMNS

SELECT * FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate


-- ------------------------------------------------------------------------------------------------------


