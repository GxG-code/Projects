/* 

Nashville, Tennessee Data Cleaning in SQL Queries

*/


SELECT *
FROM HousingData.dbo.NashvilleHousing;


-- Standardize Date Format

SELECT SaleDate, SaleDateConverted, CONVERT(date, SaleDate, 102)
FROM HousingData.dbo.NashvilleHousing;


ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate, 102);


-- Populate Property Address Data

SELECT *
FROM HousingData.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID;


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData.dbo.NashvilleHousing AS a
JOIN HousingData.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData.dbo.NashvilleHousing AS a
JOIN HousingData.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


-- Breaking out Adress into Individual Columns (Address, City and State)

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM HousingData.dbo.NashvilleHousing;


ALTER TABLE HousingData.dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE HousingData.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );


ALTER TABLE HousingData.dbo.NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE HousingData.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));


SELECT *
FROM HousingData.dbo.NashvilleHousing;


-- Owners Address

SELECT OwnerAddress
FROM HousingData.dbo.NashvilleHousing;


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM HousingData.dbo.NashvilleHousing;


ALTER TABLE HousingData.dbo.NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE HousingData.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);


ALTER TABLE HousingData.dbo.NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE HousingData.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);


ALTER TABLE HousingData.dbo.NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE HousingData.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


-- Change Y and N to Yes and No in "Sold as Vacant' field

SELECT DISTINCT(SoldAsVacant), count(SoldAsVacant)
FROM HousingData.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'Yes'
		ELSE SoldAsVacant
	END
FROM HousingData.dbo.NashvilleHousing;


UPDATE HousingData.dbo.NashvilleHousing
SET SoldAsVacant = 
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'Yes'
		ELSE SoldAsVacant
	END;


-- Remove Duplicates


WITH RowNumCTE AS (
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

FROM HousingData.dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;


-- Remove Unused Columns

SELECT *
FROM HousingData.dbo.NashvilleHousing;


ALTER TABLE HousingData.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;


ALTER TABLE HousingData.dbo.NashvilleHousing
DROP COLUMN SaleDate;