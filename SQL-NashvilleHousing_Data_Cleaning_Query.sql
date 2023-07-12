/*
    Data Cleaning by SQL Queries
*/

Select * 
from NashvilleHousing

--------- Date format ---------

Alter table Nashvillehousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)

--------- PropertyAddress data ---------
 
Select *
From NashvilleHousing
-- Where PropertyAddress is Null
order by ParcelID

Select PropertyAddress
From NashvilleHousing
Where PropertyAddress is Null

/* We have some same ParcelID in our data, so we will use those ParcelID address
  and add it to the PropertyAddress which are null and have same ParcelID */

   -- First looking the ParcelID and PropertyAddress and try to Add address in null values
Select nash.ParcelID, nash.PropertyAddress, nashville.ParcelID, nashville.PropertyAddress, ISNULL(nash.PropertyAddress, nashville.PropertyAddress)
From NashvilleHousing nash
Join NashvilleHousing nashville
 on nash.ParcelID = nashville.ParcelID
 and nash.[UniqueID ] <> nashville.[UniqueID ]
Where nash.PropertyAddress is null

/* Updating PropertyAddress in our data */

Update nash
SET PropertyAddress = ISNULL(nash.PropertyAddress, nashville.PropertyAddress)
From NashvilleHousing nash
Join NashvilleHousing nashville
 on nash.ParcelID = nashville.ParcelID
 and nash.[UniqueID ] <> nashville.[UniqueID ]
Where nash.PropertyAddress is null

--------- Breaking Address (Address, City, State) ---------

Select PropertyAddress
From NashvilleHousing

/* Splitting the PropertyAddress */
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) As City

From NashvilleHousing

/* Updating our Data by adding splitted address */
Alter Table NashvilleHousing
Add Property_Address nvarchar(255);

Update NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add Property_City nvarchar(255);

Update NashvilleHousing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select *
From NashvilleHousing

/* Splitting OwnerAddress */
Select OwnerAddress
From NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From NashvilleHousing

/* Updating our data with new address format */
Alter table NashvilleHousing
ADD Owner_Address nvarchar(255);

Update NashvilleHousing
SET Owner_Address = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter table NashvilleHousing
ADD Owner_City nvarchar(255);

Update NashvilleHousing
SET Owner_City = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter table NashvilleHousing
ADD Owner_State nvarchar(255);

Update NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select * 
From NashvilleHousing


--------- Replace Y and N to Yes and No in SoldAsVacant column ---------
/* Taking count of all yes, no, y, n */
Select Distinct(SoldAsvacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant

/* Trying to changeY and N, using case statement */ 
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From NashvilleHousing

/* Updating our Data */
Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
                        When SoldAsVacant = 'N' Then 'No'
	                    Else SoldAsVacant
	                    End
From NashvilleHousing

/* Check the count again */

-------- Remove unsed columns ---------

Select *
From NashvilleHousing

Alter table NashvilleHousing
Drop Column PropertyAddress, SaleDate, OwnerAddress