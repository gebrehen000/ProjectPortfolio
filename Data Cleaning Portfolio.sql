/*
Cleaning Data in SQL Queries
*/


Select*
From PortfolioProject..NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaledateConverted1, Convert(Date, SaleDate)
From PortfolioProject..NashvilleHousing


--Update NashvilleHousing
--Set SaleDate = Convert(Date, SaleDate)


Alter Table NashvilleHousing
Add SaledateConverted1 Date;


Update NashvilleHousing
Set SaledateConverted1 = Convert(Date, SaleDate)


				-- Summary

-- Using the convert I standardarized the date Format or chnage the date format





 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID




Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
Where a.PropertyAddress is null



						-- Summary
-- Populated the Property Address Data Using Substring CharIndex


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

-- Delitor = seprates diffrent columns or values for s the delimitor is a comma

SELECT
SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress , CHARINDEX(',', PropertyAddress)+1, LEn(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing 


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 



Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress , CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 



Select *
From PortfolioProject.dbo.NashvilleHousing 




-- Using the OwnerAdress rathar than the property address


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing 


Select
PARSENAME(Replace(OwnerAddress, ',', '.'),3)
,PARSENAME(Replace(OwnerAddress, ',', '.'),2)
,PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From PortfolioProject.dbo.NashvilleHousing 



Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)




Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)
 



Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)




Select *
From PortfolioProject.dbo.NashvilleHousing


									-- Summary
-- Broke it down again using substring, Charstring Index  combined wth Parsename and Replace


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ElSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing




Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ElSE SoldAsVacant
	   END

							-- Summary
--- Kept moving and changed Y and N to Yes and No using case statements

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH ROWNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 Legalreference
				 Order By
					UniqueID
					)row_num


From PortfolioProject.dbo.NashvilleHousing
-- Order by ParcelID
)
Select *
From ROWNumCTE
Where row_num > 1
Order by PropertyAddress





Select*
From PortfolioProject.dbo.NashvilleHousing

											-- Summary
-- Then We removed Duplicates using RowNum, a CTE and window Function of partition By



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

			-- In the process of deelting the ( PropertyAddress ), ( OwnerAddress), (Tax District), and (SaleDate)

Select*
From PortfolioProject.dbo.NashvilleHousing


AlTER TABLE  PortfolioProject.dbo.NashvilleHousing
DROP Column OwnerAddress, TAxDistrict, PropertyAddress


AlTER TABLE  PortfolioProject.dbo.NashvilleHousing
DROP Column SaleDate


									-- Summary	
-- At the end we delted columns that weren't needed anymore and tha didnt contribute to the final outlook of our data set





